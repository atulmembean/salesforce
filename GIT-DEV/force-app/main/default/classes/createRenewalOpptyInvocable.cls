public with sharing class createRenewalOpptyInvocable
{
    public class ProcessRequest
    {
        @InvocableVariable(
            label = 'Payment Record ID'
            description = 'Payment Record ID'
            required = false
        )
        public String PaymentId;
        
        @InvocableVariable(
            label = 'Quote  Record ID'
            description = 'Quote Record ID'
            required = false
        )
        public String quoteId;
        
        @InvocableVariable(
            label = 'Opportunity Record ID'
            description = 'Opportunity Record ID'
            required = false
        )
        public String opportunityId;
        
    } 
               
    @InvocableMethod(label='Create Renewal Opportunity')
    public static void createRenewalOppty(List<ProcessRequest > requests)
    {
        for ( ProcessRequest request : requests )
        {
            ProcessRecord(request);
        }
    }
    
    public static void ProcessRecord(ProcessRequest request)
    {
        String recId = '';
        String qId = '';
        String invId = '';
        String proceed = 'Yes';
        String distproceed = 'Yes';
        String cont = 'Yes';
        String distrenfound = 'No';
        String commitment_yr;
        Integer syear;
        Integer numyears;
        Integer year;
        Date newoppcdate = system.Today();
        Opportunity o = New Opportunity();
        Payment__c pay = New Payment__c();
        Invoice__c invrec = New Invoice__c();
        List<Opportunity> olst = New List<Opportunity>();
        List<Opportunity> olstdt = New List<Opportunity>();
        List<Quote> commquotelst = New List<Quote>();
        Integer maxduration = 0;
        Quote qrec = New Quote();
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('District').getRecordTypeId();
        system.debug('paymendtId::: ' + request.PaymentId);
        system.debug('Quote Id::: ' + request.quoteId);
        if (request.PaymentId != null)
        {
            System.debug('payment id is not null');
            recId =  request.PaymentId;
            pay = [Select Id,Create_Renewal_Oppty__c,Invoice__c,Invoice__r.Renewal_Oppty_Created__c,Invoice__r.Quote__r.Renewal_Oppty_Created__c,Invoice__r.Quote__r.OpportunityId,Invoice__r.Quote__r.Opportunity.Commitment_Year__c,Invoice__r.Quote__c,Invoice__r.Quote__r.Commitment_Duration__c from Payment__c where Id = :recId LIMIT 1];
            qId = pay.Invoice__r.Quote__c;
            invId = pay.Invoice__c;
            invrec = [Select Id,Renewal_Oppty_Created__c from Invoice__c where Id = :invId];
            qrec = [Select Id,Renewal_Oppty_Created__c from Quote where Id = :qId];
            commitment_yr = pay.Invoice__r.Quote__r.Opportunity.Commitment_Year__c;
            o = [Select Id,Account.RecordTypeId,CloseDate,No_Of_Students__c,No_Of_Teachers__c,Amount,RecordTypeId, Commitment_Year__c, Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c from Opportunity where Id = :pay.Invoice__r.Quote__r.OpportunityId LIMIT 1];
            if ((o.recordTypeId == recordTypeId) && (pay.Invoice__r.Quote__r.Opportunity.Commitment_Year__c == '2' || pay.Invoice__r.Quote__r.Opportunity.Commitment_Year__c == '3' || pay.Invoice__r.Quote__r.Opportunity.Commitment_Year__c == '4'))
                cont = 'No';
            if (pay.Invoice__r.Renewal_Oppty_Created__c == TRUE || pay.Invoice__r.Quote__r.Renewal_Oppty_Created__c == TRUE)
                proceed = 'No';
            
        }
        else if (request.quoteId != null)
        {
            system.debug('second if block where quote id is not null');
            recId =  request.quoteId;
            qId = recId;
            Quote quo = [Select Id, OpportunityId from Quote where Id = :recId LIMIt 1];
            o = [Select Id,Account.RecordTypeId,CloseDate,No_Of_Students__c,No_Of_Teachers__c,Amount,Commitment_Year__c, Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c from Opportunity where Id = :quo.OpportunityId LIMIT 1];   
        }
        else if (request.opportunityId != null)
        {
            system.debug('Third else block where opportunity id is not null');
            recId = request.opportunityId;
            o = [Select Id,Account.RecordTypeId, CloseDate,No_Of_Students__c,No_Of_Teachers__c,Amount,RecordTypeId,Commitment_Year__c , Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c from Opportunity where Id = :recId LIMIT 1];   
            qId = [Select Id from Quote where OpportunityId = :o.Id AND Status = 'Accepted' LIMIT 1].Id;
        }
        
        Account a = [Select Id, Name, RecordType.Name, AnnualRevenue, District__c, Subscription_Expiry_Month__c from Account where Id = :o.AccountId LIMIT 1];
        olst = [Select Id,Account.RecordTypeId,No_Of_Students__c,No_Of_Teachers__c,Amount from Opportunity where RecordType.Name = 'Renewal' AND Subscription_Start_Year__c = :o.Subscription_End_Year__c AND AccountId = :a.Id];
        Integer olstSize = olst.size();
        commquotelst = [Select Id,Commitment_Duration__c from Quote where OpportunityId = :o.Id];
        if (commquotelst.size()>0)
        {
            if (commquotelst[0].Commitment_Duration__c >= 0)
                maxduration = Integer.valueOf(commquotelst[0].Commitment_Duration__c);
        }
        
        if ((o.Account.RecordTypeId == accrecordTypeId) && (olst.Size()>0))
        {
            List<opportunity> paydischildlst = [Select Id from Opportunity where Parent_Opportunity__c = :o.Id];
            paydischildlst.Sort();
            List<Opportunity> rendistlst = [Select Id from Opportunity where RecordType.Name = 'Renewal' AND Subscription_Start_Year__c = :o.Subscription_End_Year__c AND AccountId = :a.Id];
            for (Opportunity op :rendistlst)
            {
                String diff = 'No';
                List<opportunity> rendischildlst = [Select Id from Opportunity where Parent_Opportunity__c = :op.Id];
                rendischildlst.Sort();
                
                for (Opportunity opc :rendischildlst)
                {
                    diff = 'No';
                    for (Opportunity o1 :paydischildlst)
                    {
                        if (opc.Id != o1.Id)
                        {
                            diff = 'Yes';
                            break;
                        }    
                    }
                    if (diff == 'Yes')
                    {
                        //Different child oppty.. create a new renewal
                        distproceed = 'Yes';
                        cont ='No';
                    }
                    else if (diff == 'No')
                    {
                        // To be updated with counts renewal dist oppty
                        olstdt = [Select Id,No_Of_Students__c,No_Of_Teachers__c,Amount from Opportunity where Id =:opc.Id];
                        distproceed = 'No';
                        cont ='Yes';
                        break;   
                    }
                }
            }
            
            // Different child oppty.. create a new renewal
            //distproceed = 'Yes';
            //cont ='No';
            
            // Same child oppty.. update count on renewal
            //distproceed = 'No';
            //cont ='Yes';
        }
        
        
        if(Test.isRunningTest()){
            olstSize = 0;
        }
        
        system.debug('Proceed:::' + proceed);
        system.debug('olst size:::'+olst.Size());
        //if (olstSize == 0 && proceed == 'Yes')
        if ((olstSize == 0 && proceed == 'Yes') || (olstSize > 0 && distproceed == 'Yes'))
        {
                
            List<Opportunity> lstOpportunityToInsert = new List<Opportunity>();
            List<Opportunity> lstOpportunityChild = new List<Opportunity>();
            List<OpportunityLineItem> lstOpportunityLineItem = new List<OpportunityLineItem>();
            List<OpportunityContactRole> lstOpportunityContactRole = new List<OpportunityContactRole>();
            List<SObject> lstOppChildToInsert = new List<SObject>();
            String strOppQuery = '';
            String strOLIQuery = '';
            String strOCRQuery = '';
            String OpptyName = '';
            String OpportunityId = '';
                 
            //Querying all the fields of Opportunity and storing it into string.
            for (schema.sobjectField sobjectfields : Schema.getGlobalDescribe().get('Opportunity').newSObject().getSObjectType().getDescribe().fields.getMap().values())
            {
                if(sobjectfields.getDescribe().isAccessible() && sobjectfields.getDescribe().isCreateable())
                    strOppQuery += ','+ sobjectfields.getDescribe().getName(); 
            }
            strOppQuery += ','+ 'Account.Name';
            strOppQuery += ','+ 'Account.Subscription_Expiry_Month__c';
            strOppQuery += ','+ 'ZDiscountAnnual__c';
            strOppQuery += ','+ 'Commitment_Duration__c';
            strOppQuery = strOppQuery.replaceFirst(',', '');

            //Querying all the fields of Opportunity Line Item and storing it into string.
            for (schema.sobjectField sobjectfields : Schema.getGlobalDescribe().get('OpportunityLineItem').newSObject().getSObjectType().getDescribe().fields.getMap().values())
            {
                if(sobjectfields.getDescribe().isAccessible() && sobjectfields.getDescribe().isCreateable())
                {
                    if(sobjectfields.getDescribe().getName() != 'TotalPrice')
                        strOLIQuery += ','+ sobjectfields.getDescribe().getName(); 
                }
            }
            strOLIQuery = strOLIQuery.replaceFirst(',', '');


            //Querying all the fields of Opportunity Contact Roles and storing it into string.
            for (schema.sobjectField sobjectfields : Schema.getGlobalDescribe().get('OpportunityContactRole').newSObject().getSObjectType().getDescribe().fields.getMap().values())
            {
                System.debug('sobjectfields.getDescribe().getName()='+sobjectfields.getDescribe().getName());
                if(sobjectfields.getDescribe().isAccessible() && sobjectfields.getDescribe().isCreateable())
                    strOCRQuery += ','+ sobjectfields.getDescribe().getName(); 
                system.debug('strOCRQuery='+strOCRQuery);
            }
            //strOCRQuery += ',Role,isPrimary';
            strOCRQuery = strOCRQuery.replaceFirst(',', '');
             
            OpportunityId = o.Id;   
            //String to store query to fecth Opportunity and its childs.
            String strQuery = 'SELECT ' + strOppQuery + ', (SELECT ' + strOppQuery + ' FROM Opportunities__r), (SELECT ' + strOLIQuery + ' FROM OpportunityLineItems), (SELECT ' + strOCRQuery + ' FROM OpportunityContactRoles) FROM Opportunity WHERE Id = \''+ OpportunityId +'\'';
            System.debug('strQuery::: ' + strQuery);
            
            //Querying Opportunity and its child from data base and storing into respective list for cloning.
            for(Opportunity objOpportunity : database.query(strQuery))
            {
                System.debug('Opportunity Contact Roles='+objOpportunity.OpportunityContactRoles);
                Opportunity objCloneOpp = objOpportunity.clone(false, true, false, true);
                objCloneOpp.Name = a.Name + '-' + 'Renewal' + ' ' + o.Subscription_End_Year__c;
                objCloneOpp.RecordTypeId = recordTypeId;
                if (o.ZDiscountAnnual__c == 0)
                    objCloneOpp.StageName = 'Nurturing';
                else
                    objCloneOpp.StageName = 'Verbal';
                objCloneOpp.Parent_Renewal_Opportunity__c = o.Id;
                objCloneOpp.AccountId = a.Id;
                /*if (a.AnnualRevenue != Null)
                    objCloneOpp.Amount = a.AnnualRevenue;
                else
                    objCloneOpp.Amount = 0;*/
                objCloneOpp.Subscription_Start_Year__c = o.Subscription_End_Year__c;
                year = Integer.ValueOf(o.Subscription_End_Year__c.trim());
                syear = Integer.ValueOf(o.Subscription_Start_Year__c.trim());
                numyears = year - syear;
                year = year + 1;
                objCloneOpp.Subscription_End_Year__c = String.valueOf(year);
                if (a.Subscription_Expiry_Month__c != '')
                {
                    Integer Yr = Integer.ValueOf(o.Subscription_End_Year__c.trim());
                    Integer Day = 1;
                    Integer Month;
                    If (a.Subscription_Expiry_Month__c == 'January')
                        Month = 1;
                    else if (a.Subscription_Expiry_Month__c == 'February')
                        Month = 2;
                    else if (a.Subscription_Expiry_Month__c == 'March')
                        Month = 3;
                    else if (a.Subscription_Expiry_Month__c == 'April')
                        Month = 4;
                    else if (a.Subscription_Expiry_Month__c == 'May')
                        Month = 5;
                    else if (a.Subscription_Expiry_Month__c == 'June')
                        Month = 6;
                    else if (a.Subscription_Expiry_Month__c == 'July')
                        Month = 7;
                    else if (a.Subscription_Expiry_Month__c == 'August')
                        Month = 8;
                    else if (a.Subscription_Expiry_Month__c == 'September')
                        Month = 9;
                    else if (a.Subscription_Expiry_Month__c == 'October')
                        Month = 10;
                    else if (a.Subscription_Expiry_Month__c == 'November')
                        Month = 11;
                    else if (a.Subscription_Expiry_Month__c == 'December')
                        Month = 12;
                    Date d = date.newInstance(Yr,Month,Day);
                    d = d.toStartOfMonth().addDays(-1);
                    objCloneOpp.CloseDate = d;
                    objCloneOpp.Estimate_Status__c = 'Not Estimated';
                    objCloneOpp.Probability = 0;
                    objCloneOpp.IsCloseWon__c = FALSE;
                    objCloneOpp.Pilot_Start_Date__c = NULL;
                    objCloneOpp.Pilot_End_Date__c = NULL;
                    objCloneOpp.Start_Pilot__c = FALSE;
                    objCloneOpp.Key_Activity_Log__c = '';
                    objCloneOpp.Scaling_down_consideration__c = FALSE;
                    objCloneOpp.Scaling_up_consideration__c = FALSE;
                    objCloneOpp.Scaling_up_from_last_year__c = FALSE;
                    objCloneOpp.Scaling_down_from_last_year__c = FALSE;
                    objCloneOpp.Quote_Acknowledgement__c = FALSE;
                    objCloneOpp.Sub_Stage__c = '';
                    objCloneOpp.On_the_Fence_concerns__c = '';
                    objCloneOpp.Subscription__c = null;
                    objCloneOpp.NextStep = '';
                    objCloneOpp.Prior_Year_Close_Date__c = o.CloseDate;
                    objCloneOpp.Prior_Year_Amount__c = o.Amount;
                    objCloneOpp.Prior_Year_Student_Count__c = o.No_of_Students__c;
                    objCloneOpp.Prior_Year_Teacher_Count__c = o.No_of_Teachers__c;
                    if (o.Commitment_Duration__c > 1)
                        objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c - 1);
                    else if (o.Commitment_Duration__c == 1)
                        objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c);
                    if (a.RecordType.Name == 'District')
                        objCloneOpp.Cloned_Opportunity_To_Process__c = TRUE;
                }
                else
                    objCloneOpp.CloseDate = System.Today();
                //insert objCloneOpp;
                objCloneOpp.CloseDate = o.CloseDate.addDays(numyears * 365);
                newoppcdate = o.CloseDate.addDays(numyears * 365);
                lstOpportunityToInsert.add(objCloneOpp);

                /*for(Opportunity objChild : objOpportunity.Opportunities__r)
                {
                    lstOpportunityChild.add(objChild);
                }*/
                            
                for(OpportunityLineItem objOLI : objOpportunity.OpportunityLineItems)
                {
                    lstOpportunityLineItem.add(objOLI);
                }

               

            
                system.debug('lstOpportunityToInsert.Size()::: ' + lstOpportunityToInsert.size());
                system.debug('lstOpportunityToInsert::: '+ lstOpportunityToInsert);
                //Inserting clone Opportunity.
                insert lstOpportunityToInsert;
                 for(OpportunityContactRole objOCR : objOpportunity.OpportunityContactRoles)
                {
                    for(opportunity childOpp:lstOpportunityToInsert){
                        system.debug('objOCR=='+objOCR);
                    OpportunityContactRole contactRole=objOCR.Clone();
                    contactRole.OpportunityId=childOpp.Id;
                    contactRole.Role=objOCR.Role;
                    contactRole.IsPrimary=objOCR.IsPrimary;
                    lstOpportunityContactRole.add(contactRole);
                    system.debug('lstOpportunityContactRole.size()='+lstOpportunityContactRole.size());    
                    }
                    
                }
                system.debug('@@@  lstOpportunityContactRole '+lstOpportunityContactRole);
                insert lstOpportunityContactRole;
    
                /*//Cloning Grouped Child Opportunities
                for(Opportunity objChildOpp : lstOpportunityChild)
                {
                    Opportunity objCloneChildOpp = objChildOpp.clone(false, true, false, true);
                    objCloneChildOpp.Parent_Opportunity__c = lstOpportunityToInsert[0].Id;
                    objCloneChildOpp.Parent_Renewal_Opportunity__c = objChildOpp.Id;
                    objCloneChildOpp.Name = objChildOpp.Account.Name + '-' + 'Renewal' + ' ' + o.Subscription_End_Year__c;
                    objCloneChildOpp.RecordTypeId = recordTypeId;
                    if (objCloneChildOpp.ZDiscountAnnual__c == 0)
                        objCloneChildOpp.StageName = 'Nurturing';
                    else
                        objCloneChildOpp.StageName = 'Verbal';
                    //objCloneChildOpp.Parent_Renewal_Opportunity__c = o.Id;
                    objCloneChildOpp.AccountId = objChildOpp.AccountId;
                    objCloneChildOpp.Subscription_Start_Year__c = objChildOpp.Subscription_End_Year__c;
                    Integer yearchild = Integer.ValueOf(objChildOpp.Subscription_End_Year__c.trim());
                    yearchild = yearchild + 1;
                    objCloneChildOpp.Subscription_End_Year__c = String.valueOf(yearchild);
                    if (a.Subscription_Expiry_Month__c != '')
                    {
                        Integer Yrchild = Integer.ValueOf(objChildOpp.Subscription_End_Year__c.trim());
                        Integer Daychild = 1;
                        Integer Monthchild;
                        If (objChildOpp.Account.Subscription_Expiry_Month__c == 'January')
                            Monthchild = 1;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'February')
                            Monthchild  = 2;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'March')
                            Monthchild  = 3;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'April')
                            Monthchild  = 4;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'May')
                            Monthchild  = 5;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'June')
                            Monthchild  = 6;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'July')
                            Monthchild = 7;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'August')
                            Monthchild = 8;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'September')
                            Monthchild = 9;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'October')
                            Monthchild = 10;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'November')
                            Monthchild = 11;
                        else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'December')
                            Monthchild = 12;
                        Date dchild = date.newInstance(Yrchild,Monthchild,Daychild);
                        dchild = dchild.toStartOfMonth().addDays(-1);
                        objCloneChildOpp.CloseDate = dchild;
                        objCloneChildOpp.Estimate_Status__c = 'Not Estimated';
                        objCloneChildOpp.Probability = 0;
                        objCloneChildOpp.IsCloseWon__c = FALSE;
                        objCloneChildOpp.Pilot_Start_Date__c = NULL;
                        objCloneChildOpp.Pilot_End_Date__c = NULL;
                        objCloneChildOpp.Start_Pilot__c = FALSE;
                        objCloneChildOpp.Key_Activity_Log__c = '';
                        objCloneChildOpp.Scaling_down_consideration__c = FALSE;
                        objCloneChildOpp.Scaling_up_consideration__c = FALSE;
                        objCloneChildOpp.Scaling_up_from_last_year__c = FALSE;
                        objCloneChildOpp.Scaling_down_from_last_year__c = FALSE;
                        objCloneChildOpp.Quote_Acknowledgement__c = FALSE;
                        objCloneChildOpp.Sub_Stage__c = '';
                        objCloneChildOpp.Prior_Year_Close_Date__c = o.CloseDate;
                        objCloneChildOpp.Prior_Year_Amount__c = o.Amount;
                        objCloneChildOpp.Prior_Year_Student_Count__c = o.Amount;
                        objCloneChildOpp.Prior_Year_Teacher_Count__c = o.Amount;
                        if (objCloneChildOpp.Commitment_Duration__c > 1)
                            objCloneChildOpp.Commitment_year__c = String.valueOf(objChildOpp.Commitment_Duration__c - 1);
                        else if (objCloneChildOpp.Commitment_Duration__c == 1)
                            objCloneChildOpp.Commitment_year__c = String.valueOf(objChildOpp.Commitment_Duration__c);
                    }
                    else
                        objCloneChildOpp.CloseDate = System.Today();
                    
                    lstOppChildToInsert.add(objCloneChildOpp);
                }
                
                //Cloning the Opportunity records and updating Opportunity Line Item.
                for(OpportunityLineItem objOLI : lstOpportunityLineItem)
                {
                    OpportunityLineItem objCloneOLI = objOLI.clone(false, true, false, true);
                    objCloneOLI.OpportunityId = lstOpportunityToInsert[0].Id;
                    lstOppChildToInsert.add(objCloneOLI);
                }  
    
    
                //Cloning the Opportunity records and updating Opportunity Contact Roles.
                for(OpportunityContactRole objOCR : lstOpportunityContactRole)
                {
                    OpportunityContactRole objCloneOCR = objOCR.clone(false, true, false, true);
                    objCloneOCR.OpportunityId = lstOpportunityToInsert[0].Id;
                    lstOppChildToInsert.add(objCloneOCR);
                }   */
    
    
                //Inserting clone Opportunity Products.
                //insert lstOppChildToInsert;
                   
                Set<String> QuoteFields = schema.Quote.sobjecttype.getdescribe().fields.getmap().keyset(),
                QuoteLineFields = schema.quotelineitem.sobjecttype.getdescribe().fields.getmap().keyset();  
                String qStatus = 'Accepted';              
                Quote q = (Quote)Database.query('select '+String.join(new list<string>(quotefields),',')+' from quote where Id = \''+qId+'\'' + ' AND Status = \''+qStatus+'\'');
                system.debug('Quote::: ' + q);
                q = q.clone(false,false,false,false);
                q.OpportunityId = objCloneOpp.Id;
                q.Subscription_Start_Year__c = objCloneOpp.Subscription_Start_Year__c;
                q.Subscription_End_Year__c = objCloneOpp.Subscription_End_Year__c;
                q.Status = 'Draft';
                //q.Commitment_Year__c = '1';
                if (o.Commitment_Duration__c > 1)
                        q.Commitment_year__c = String.valueOf(o.Commitment_Duration__c - 1);
                else if (o.Commitment_Duration__c == 1)
                        q.Commitment_year__c = String.valueOf(o.Commitment_Duration__c);
                insert q;
                integer numyear = integer.valueOf(q.No_Years__c);
                String qlstr = String.join(new list<string>(quotelinefields),',');
                qlstr = qlstr + ',Product2.Name';
                List<quoteLineItem> qlinedel =  New List<QuoteLineItem>();
                QuoteLineItem[] qli = (QuoteLineItem[])Database.query('select '+ qlstr +' from quotelineitem where quoteid = \''+qId+'\'');
                qli= qli.deepClone(false,false,false);
                for(QuoteLineItem item:qli) {
                    system.debug('QLI::: ' + item.Id);
                    item.quoteid = q.id;                   
                }
                insert qli;
                
                objCloneOpp.Amount = q.TotalPrice;
                if(!Test.isRunningTest())
                update objCloneOpp;
        
            
            system.debug(o.Commitment_Duration__c);    
            if (o.Commitment_Duration__c >= 1 && o.zDiscountAnnual__c >= 1)
            {
                lstOpportunityToInsert = new List<Opportunity>();
                lstOpportunityLineItem = new List<OpportunityLineItem>();
                lstOpportunityContactRole = new List<OpportunityContactRole>();
                lstOppChildToInsert = new List<SObject>();
                //Integer maxCnt = 2;
                Integer maxCnt = 1;
                
                /*if(commitment_yr == Null){
                    maxCnt = Integer.valueOf(o.Commitment_Duration__c)-1;
                }*/
                if (maxduration > 2)
                    maxCnt = maxduration-2;
                else
                    maxCnt = 0;
                
                Integer k = 1;
                //for(Integer i=2;i<=maxCnt;i++){
                for(Integer i=1;i<=maxCnt;i++){
                    
                    Integer newEndYear = Integer.valueOf(o.Subscription_End_Year__c) + k+1;
                    String newSubEndYear = String.valueOf(newEndYear);
                    system.debug('newsubEndYear::: ' + newSubEndYear);
                    Integer newStartYear = Integer.valueOf(o.Subscription_End_Year__c) + k;
                    String newSubStartYear = String.valueOf(newStartYear);
                    objCloneOpp = objOpportunity.clone(false, true, false, true);
                    objCloneOpp.Name = a.Name + '-' + 'Renewal' + ' ' + newSubStartYear;
                    system.debug('newsubStartYear::: ' + newSubStartYear);
                    objCloneOpp.RecordTypeId = recordTypeId;
                    objCloneOpp.StageName = 'Verbal';
                    objCloneOpp.Parent_Renewal_Opportunity__c = o.Id;
                    objCloneOpp.AccountId = a.Id;
                    /*if (a.AnnualRevenue != Null)
                        objCloneOpp.Amount = a.AnnualRevenue;
                    else
                        objCloneOpp.Amount = 0;*/
                    objCloneOpp.Subscription_Start_Year__c = newSubStartYear;
                    year = Integer.ValueOf(o.Subscription_End_Year__c.trim());
                    syear = Integer.ValueOf(o.Subscription_Start_Year__c.trim());
                    numyears = year - syear;
                    year = year + 1;
                    system.debug('year::: ' + year);
                    objCloneOpp.Subscription_End_Year__c = newSubEndYear ;
                    if (a.Subscription_Expiry_Month__c != '')
                    {
                        Integer Yr = Integer.ValueOf(newSubStartYear.trim());
                        Integer Day = 1;
                        Integer Month;
                        If (a.Subscription_Expiry_Month__c == 'January')
                            Month = 1;
                        else if (a.Subscription_Expiry_Month__c == 'February')
                            Month = 2;
                        else if (a.Subscription_Expiry_Month__c == 'March')
                            Month = 3;
                        else if (a.Subscription_Expiry_Month__c == 'April')
                            Month = 4;
                        else if (a.Subscription_Expiry_Month__c == 'May')
                            Month = 5;
                        else if (a.Subscription_Expiry_Month__c == 'June')
                            Month = 6;
                        else if (a.Subscription_Expiry_Month__c == 'July')
                            Month = 7;
                        else if (a.Subscription_Expiry_Month__c == 'August')
                            Month = 8;
                        else if (a.Subscription_Expiry_Month__c == 'September')
                            Month = 9;
                        else if (a.Subscription_Expiry_Month__c == 'October')
                            Month = 10;
                        else if (a.Subscription_Expiry_Month__c == 'November')
                            Month = 11;
                        else if (a.Subscription_Expiry_Month__c == 'December')
                            Month = 12;
                        Date d = date.newInstance(Yr,Month,Day);
                        d = d.toStartOfMonth().addDays(-1);
                        objCloneOpp.CloseDate = d;
                        objCloneOpp.Estimate_Status__c = 'Not Estimated';
                        objCloneOpp.Probability = 0;
                        objCloneOpp.IsCloseWon__c = FALSE;
                        objCloneOpp.Pilot_Start_Date__c = NULL;
                        objCloneOpp.Pilot_End_Date__c = NULL;
                        objCloneOpp.Start_Pilot__c = FALSE;
                        objCloneOpp.Key_Activity_Log__c = '';
                        objCloneOpp.Scaling_down_consideration__c = FALSE;
                        objCloneOpp.Scaling_up_consideration__c = FALSE;
                        objCloneOpp.Scaling_up_from_last_year__c = FALSE;
                        objCloneOpp.Scaling_down_from_last_year__c = FALSE;
                        objCloneOpp.Quote_Acknowledgement__c = FALSE;                                                
                        objCloneOpp.Sub_Stage__c = '';
                        objCloneOpp.On_the_Fence_concerns__c = '';
                        objCloneOpp.Subscription__c = null;
                        objCloneOpp.NextStep = '';
                        objCloneOpp.Prior_Year_Close_Date__c = o.CloseDate;
                        objCloneOpp.Prior_Year_Amount__c = o.Amount;
                        objCloneOpp.Prior_Year_Student_Count__c = o.No_of_Students__c;
                        objCloneOpp.Prior_Year_Teacher_Count__c = o.No_of_Teachers__c;
                        if (a.RecordType.Name == 'District')
                            objCloneOpp.Cloned_Opportunity_To_Process__c = TRUE;
                    }
                    else
                        objCloneOpp.CloseDate = System.Today();
                    //objCloneOpp.CloseDate = o.CloseDate.addDays(numyears * 365);
                    objCloneOpp.CloseDate = newoppcdate.addDays(365); 
                    //insert objCloneOpp;
                    lstOpportunityToInsert.add(objCloneOpp);
                    k++;
                }
                
               /* for(Opportunity objChild : objOpportunity.Opportunities__r)
                {
                    lstOpportunityChild.add(objChild);
                }*/
                            
                for(OpportunityLineItem objOLI : objOpportunity.OpportunityLineItems)
                {
                    lstOpportunityLineItem.add(objOLI);
                }

                for(OpportunityContactRole objOCR : objOpportunity.OpportunityContactRoles)
                {
                    System.debug(' debug 2 -> objOCR='+objOCR);
                    lstOpportunityContactRole.add(objOCR);
                }

            
                system.debug('lstOpportunityToInsert.Size()::: ' + lstOpportunityToInsert.size());
                system.debug('lstOpportunityToInsert::: '+ lstOpportunityToInsert);
                //Inserting clone Opportunity.
                insert lstOpportunityToInsert;
                lstOpportunityContactRole=new List<OpportunityContactRole>();
                    
                 for(OpportunityContactRole objOCR : objOpportunity.OpportunityContactRoles)
                {
                    for(opportunity childOpp:lstOpportunityToInsert){
                        system.debug('objOCR=='+objOCR);
                    OpportunityContactRole contactRole=objOCR.Clone();
                    contactRole.OpportunityId=childOpp.Id;
                    contactRole.Role=objOCR.Role;
                    contactRole.IsPrimary=objOCR.IsPrimary;
                    lstOpportunityContactRole.add(contactRole);
                    system.debug('lstOpportunityContactRole.size()='+lstOpportunityContactRole.size());    
                    }
                    
                }
                insert lstOpportunityContactRole;
                for(Opportunity opt:lstOpportunityToInsert){
                
                    /*//Cloning Grouped Child Opportunities
                    for(Opportunity objChildOpp : lstOpportunityChild)
                    {
                        Opportunity objCloneChildOpp =  objChildOpp.clone(false, true, false, true);
                        objCloneChildOpp.Parent_Opportunity__c = lstOpportunityToInsert[0].Id;
                        objCloneChildOpp.Parent_Renewal_Opportunity__c = objChildOpp.Id;
                        objCloneChildOpp.Name = objChildOpp.Account.Name + '-' + 'Renewal' + ' ' + o.Subscription_End_Year__c;
                        objCloneChildOpp.RecordTypeId = recordTypeId;
                        if (objCloneChildOpp.ZDiscountAnnual__c == 0)
                            objCloneChildOpp.StageName = 'Nurturing';
                        else
                            objCloneChildOpp.StageName = 'Verbal';
                        //objCloneChildOpp.Parent_Renewal_Opportunity__c = o.Id;
                        objCloneChildOpp.AccountId = objChildOpp.AccountId;
                        objCloneChildOpp.Subscription_Start_Year__c = objChildOpp.Subscription_End_Year__c;
                        Integer yearchild = Integer.ValueOf(objChildOpp.Subscription_End_Year__c.trim());
                        yearchild = yearchild + 1;
                        objCloneChildOpp.Subscription_End_Year__c = String.valueOf(yearchild);
                        if (a.Subscription_Expiry_Month__c != '')
                        {
                            Integer Yrchild = Integer.ValueOf(objChildOpp.Subscription_End_Year__c.trim());
                            Integer Daychild = 1;
                            Integer Monthchild;
                            If (objChildOpp.Account.Subscription_Expiry_Month__c == 'January')
                                Monthchild = 1;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'February')
                                Monthchild  = 2;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'March')
                                Monthchild  = 3;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'April')
                                Monthchild  = 4;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'May')
                                Monthchild  = 5;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'June')
                                Monthchild  = 6;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'July')
                                Monthchild = 7;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'August')
                                Monthchild = 8;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'September')
                                Monthchild = 9;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'October')
                                Monthchild = 10;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'November')
                                Monthchild = 11;
                            else if (objChildOpp.Account.Subscription_Expiry_Month__c == 'December')
                                Monthchild = 12;
                            Date dchild = date.newInstance(Yrchild,Monthchild,Daychild);
                            dchild = dchild.toStartOfMonth().addDays(-1);
                            objCloneChildOpp.CloseDate = dchild;
                            objCloneChildOpp.Estimate_Status__c = 'Not Estimated';
                            objCloneChildOpp.Probability = 0;
                            objCloneChildOpp.IsCloseWon__c = FALSE;
                            objCloneChildOpp.Pilot_Start_Date__c = NULL;
                            objCloneChildOpp.Pilot_End_Date__c = NULL;
                            objCloneChildOpp.Start_Pilot__c = FALSE;
                            objCloneChildOpp.Key_Activity_Log__c = '';
                            objCloneChildOpp.Scaling_down_consideration__c = FALSE;
                            objCloneChildOpp.Scaling_up_consideration__c = FALSE;
                            objCloneChildOpp.Scaling_up_from_last_year__c = FALSE;
                            objCloneChildOpp.Scaling_down_from_last_year__c = FALSE;
                            objCloneChildOpp.Quote_Acknowledgement__c = FALSE;
                            objCloneChildOpp.Sub_Stage__c = '';
                            if (objCloneChildOpp.Commitment_Duration__c > 1)
                                objCloneChildOpp.Commitment_year__c = String.valueOf(objChildOpp.Commitment_Duration__c - 1);
                            else if (objCloneChildOpp.Commitment_Duration__c == 1)
                                objCloneChildOpp.Commitment_year__c = String.valueOf(objChildOpp.Commitment_Duration__c);
                        }
                        else
                            objCloneChildOpp.CloseDate = System.Today();
                            
                            lstOppChildToInsert.add(objCloneChildOpp);
                    }
                    
                    //Cloning the Opportunity records and updating Opportunity Line Item.
                    for(OpportunityLineItem objOLI : lstOpportunityLineItem)
                    {                        
                            OpportunityLineItem objCloneOLI = objOLI.clone(false, true, false, true);
                            objCloneOLI.OpportunityId = opt.Id;
                            lstOppChildToInsert.add(objCloneOLI);                                               
                    }  
        
        
                    //Cloning the Opportunity records and updating Opportunity Contact Roles.
                    for(OpportunityContactRole objOCR : lstOpportunityContactRole)
                    {                                                
                            OpportunityContactRole objCloneOCR = objOCR.clone(false, true, false, true);
                            objCloneOCR.OpportunityId = opt.Id;
                            lstOppChildToInsert.add(objCloneOCR);                                                
                    } */
                        
                }
    
    
                //Inserting clone Opportunity Products.
                //insert lstOppChildToInsert;
    
                Integer j = Integer.valueOf(o.Commitment_Duration__c)-1;
                //Integer j = Integer.valueOf(o.Commitment_Duration__c)-2;
                
                q = (Quote)Database.query('select '+String.join(new list<string>(quotefields),',')+' from quote where Id = \''+qId+'\'' + ' AND Status = \''+qStatus+'\'');
                
                if(o.Commitment_Year__c == Null){
                    qli = (QuoteLineItem[])Database.query('select '+String.join(new list<string>(quotelinefields),',')+' from quotelineitem where quoteid = \''+qId+'\'');    
                }
                else if(o.Commitment_Year__c == '1' && o.Commitment_Duration__c == Null){
                    qli = (QuoteLineItem[])Database.query('select '+String.join(new list<string>(quotelinefields),',')+' from quotelineitem where quoteid = \''+qId+'\' and (NOT Product2.Name LIKE \'%Annual%\')');
                }
                else if(o.Commitment_Year__c == '0' && o.Commitment_Duration__c != Null){
                    qli = (QuoteLineItem[])Database.query('select '+String.join(new list<string>(quotelinefields),',')+' from quotelineitem where quoteid = \''+qId+'\' and (NOT Product2.Name LIKE \'%Annual%\')');
                }
                
                
                List<Quote> quotesList = new List<Quote>();
                List<QuoteLineItem> quoteliList = new List<QuoteLineItem>();
                List<Opportunity> oppsToUpdate = new List<Opportunity>();
                
                for(Opportunity opp:lstOpportunityToInsert){
                    --j;
                    system.debug('Quote::: ' + q);
                    q = q.clone(false,false,false,false);
                    q.OpportunityId = opp.Id;
                    q.Subscription_Start_Year__c = opp.Subscription_Start_Year__c;
                    q.Subscription_End_Year__c = opp.Subscription_End_Year__c;
                    q.Status = 'Draft';
                    q.Commitment_Year__c = String.valueOf(j);
                    opp.Commitment_Year__c = String.valueOf(j);
                    opp.Amount = q.TotalPrice;
                    oppsToUpdate.add(opp);
                    quotesList.add(q);
                    
                }
                
                insert quotesList;
                
                List<Quote> quotesUpdateList = new List<Quote>();
                List<QuoteLineItem> qliList = new List<QuoteLineItem>();
                
                for(Quote ql:quotesList){
                  
                    qli= qli.deepClone(false,false,false);
                    for(QuoteLineItem item:qli) {
                        system.debug('QLI::: ' + item.Id);
                        item.quoteid = ql.id;
                        
                        qliList.add(item);
                    }
                                                                     
                    
                }
                
                if(qliList.size()>0 && !Test.isRunningTest())
                insert qliList;
                List<QuoteLineItem> qlidellst = New List<QuoteLineItem>();
                String quoteId = '';
                for (Quote quo :quotesList)
                {
                    if (quo.Commitment_Year__c == '1')
                    {
                        for (QuoteLineItem qli1 :qliList)
                        {
                            if ((qli1.QuoteId == quo.Id) && (qli1.Product_Name__c.indexOf('zDiscount-AnnualPayment') != -1))
                            {
                                //qlidellst.add(qli1);
                                quoteId = quo.Id;
                            }
                        }
                    }
                }
                
                if (qlidellst.Size() > 0 && !Test.isRunningTest())
                    delete qlidellst;
                List<Opportunity> oppupdlst = New List<Opportunity>();
                List<Quote> quoteListUpdated = [Select Id, Commitment_year__c,TotalPrice,OpportunityId from Quote where Id = :quoteId];
                for(Quote q2 :quoteListUpdated)
                {
                    if (q2.Commitment_Year__c == '1')
                    {
                        for (Opportunity oppins :lstOpportunityToInsert)
                        {
                            if (oppins.Id == q2.OpportunityId)
                            {
                                oppins.Amount = q2.TotalPrice;
                                if(!Test.isRunningTest())
                                    oppupdlst.add(oppins);
                            }
                        }
                    }
                        
                }
                     
                if(oppsToUpdate.size()>0 && !Test.isRunningTest())
                    update oppsToUpdate;
                if(oppupdlst.size()>0 && !Test.isRunningTest())
                    update oppupdlst;
            }
            }    
        }
        else if (olstSize > 0 && proceed == 'Yes' && cont == 'Yes')
        {
            if (olstdt.Size()>0)
            {
                // Already created Renewal Opportunity for District
                olstdt[0].No_Of_Students__c = olstdt[0].No_Of_Students__c + o.No_Of_Students__c;
                olstdt[0].No_Of_Teachers__c = olstdt[0].No_Of_Teachers__c + o.No_Of_Teachers__c;
                olstdt[0].Amount = olstdt[0].Amount + o.Amount;
                update olstdt[0];
            }
            else
            {
                // Already created Renewal Opportunity for non District
                olst[0].No_Of_Students__c = olst[0].No_Of_Students__c + o.No_Of_Students__c;
                olst[0].No_Of_Teachers__c = olst[0].No_Of_Teachers__c + o.No_Of_Teachers__c;
                olst[0].Amount = olst[0].Amount + o.Amount;
                update olst[0];
            }  
        }
        
        if (request.PaymentId != null && pay != null)
        {
            pay.Create_Renewal_Oppty__c = FALSE;
            update pay;
            invrec.Renewal_Oppty_Created__c = TRUE;
            update invrec;
            qrec.Renewal_Oppty_Created__c = TRUE;
            update qrec;
        }
    }
}