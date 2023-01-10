global class CloneChildOppsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            if(Test.isRunningTest()){
               query = 'Select Id, Amount, No_of_Teachers__c,No_of_Students__c,Parent_Renewal_Opportunity__c, CloseDate, Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c from Opportunity where Cloned_Opportunity_To_Process__c = TRUE ORDER By CreatedDate DESC LIMIT 1';  
            }
            else{
               query = 'Select Id, Amount, No_of_Teachers__c,No_of_Students__c,Parent_Renewal_Opportunity__c, CloseDate, Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c from Opportunity where Cloned_Opportunity_To_Process__c = TRUE';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Opportunity> scope){
                Opportunity ocloned = New Opportunity();
                List<Opportunity> oppchildList = New List<Opportunity>();
                List<Opportunity> oppList = New List<Opportunity>();
                Account acc = New Account();
                List<Id> accid = New List<Id>();
                List<account> acclst = New List<Account>();
                for(Opportunity o:scope){
                    //ocloned = [select Id, Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c,Amount,CloseDate,No_of_Students__c,No_of_Teachers__c from Opportunity where Id = :o.Parent_Renewal_Opportunity__c];
                    oppchildList = [Select Id, Cloned_Opportunity_To_Process__c , Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c,Amount,CloseDate,No_of_Students__c,No_of_Teachers__c from Opportunity where Parent_Opportunity__c = :o.Parent_Renewal_Opportunity__c];
                    for (Opportunity opp :oppchildList)
                    {
                        accid.add(opp.AccountId);
                    }
                    
                    //Account a = [Select Id, Name, RecordType.Name, AnnualRevenue, District__c, Subscription_Expiry_Month__c from Account where Id = :o.AccountId LIMIT 1];
                   
                    acclst = [Select Id, Name, RecordType.Name, AnnualRevenue, District__c, Subscription_Expiry_Month__c from Account where Id IN :accid];
                    
                    for (Opportunity opp :oppchildList)
                    {
                        oppList = New List<Opportunity>();
                        oppList.add(opp);
                        for (Account accntl: acclst)
                        {
                            if (accntl.Id == opp.AccountId)
                                ProcessRecord(o.Id,oppList,accntl,o);        
                        }
                        
                    }
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            if (!Test.isRunningTest())
            {
                ProcessDistrictOpptyChildCountScheduled s = new ProcessDistrictOpptyChildCountScheduled();
                s.execute(null);
            }    
       }
    
       global void ProcessRecord(String rId, List<Opportunity> ochildList,Account a,Opportunity opp){
            String recId = '';
            String proceed = 'Yes';
            String commitment_yr;
            Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            //Opportunity opp = [Select Id, Amount, No_of_Teachers__c,No_of_Students__c,Parent_Renewal_Opportunity__c, CloseDate, Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c from Opportunity where Id = :rId];
            Opportunity ocloned = New Opportunity();
            if (opp != Null)
            {
                //ocloned = [select Id, Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c,Amount,CloseDate,No_of_Students__c,No_of_Teachers__c from Opportunity where Id = :parentId];
            
                //List<Opportunity> ochildList = [Select Id, Cloned_Opportunity_To_Process__c , Commitment_Duration__c, ZDiscountAnnual__c, AccountId, Subscription_End_Year__c,Subscription_Start_Year__c,Amount,CloseDate,No_of_Students__c,No_of_Teachers__c from Opportunity where Parent_Opportunity__c = :ocloned.Id];
            
            
                for (Opportunity o :ochildList)
                {
                    //Account a = [Select Id, Name, RecordType.Name, AnnualRevenue, District__c, Subscription_Expiry_Month__c from Account where Id = :o.AccountId LIMIT 1];
                    //List<Opportunity> olst = [Select Id from Opportunity where RecordType.Name = 'Renewal' AND Subscription_Start_Year__c = :o.Subscription_End_Year__c AND AccountId = :a.Id];
                    //Integer olstSize = olst.size();
                    
                    
                    //if (olstSize == 0)
                    //{
                            
                        List<Opportunity> lstOpportunityToInsert = new List<Opportunity>();
                        List<Opportunity> lstOpportunityChild = new List<Opportunity>();
                        List<OpportunityLineItem> lstOpportunityLineItem = new List<OpportunityLineItem>();
                        List<OpportunityContactRole> lstOpportunityContactRole = new List<OpportunityContactRole>();
                        List<Quote> lstOpportunityQuote = New List<Quote>();
                        List<SObject> lstOppChildToInsert = new List<SObject>();
                        String strOppQuery = '';
                        String strOLIQuery = '';
                        String strOCRQuery = '';
                        String strQuoteQuery = '';
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
                        strOppQuery += ','+ 'Student_Amount__c';
                        strOppQuery += ','+ 'Teacher_Amount__c';
                        strOppQuery += ','+ 'Child_discount_amount__c';


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
                            if(sobjectfields.getDescribe().isAccessible() && sobjectfields.getDescribe().isCreateable())
                                strOCRQuery += ','+ sobjectfields.getDescribe().getName(); 
                        }
                        strOCRQuery = strOCRQuery.replaceFirst(',', '');
                        
                        //Querying all the fields of Quote and storing it into string.
                        for (schema.sobjectField sobjectfields : Schema.getGlobalDescribe().get('Quote').newSObject().getSObjectType().getDescribe().fields.getMap().values())
                        {
                            if(sobjectfields.getDescribe().isAccessible() && sobjectfields.getDescribe().isCreateable())
                                strQuoteQuery += ','+ sobjectfields.getDescribe().getName(); 
                        }
                        strQuoteQuery = strQuoteQuery.replaceFirst(',', '');
                        
                        OpportunityId = o.Id;   
                        //String to store query to fecth Opportunity and its childs.
                        String strQuery = 'SELECT ' + strOppQuery + ', (SELECT ' + strOppQuery + ' FROM Opportunities__r), (SELECT ' + strOLIQuery + ' FROM OpportunityLineItems), (SELECT ' + strOCRQuery + ' FROM OpportunityContactRoles), (SELECT ' + strQuoteQuery + ' FROM Quotes) FROM Opportunity WHERE Id = \''+ OpportunityId +'\'';
                        System.debug('strQuery::: ' + strQuery);
                        
                        //Querying Opportunity and its child from data base and storing into respective list for cloning.
                        for(Opportunity objOpportunity : database.query(strQuery))
                        {
                            //List<Opportunity> clonedOppty = [Select Id from Opportunity where Parent_Renewal_Opportunity__c = :o.Id];
                            lstOpportunityLineItem = new List<OpportunityLineItem>();
                            lstOpportunityContactRole = new List<OpportunityContactRole>();
                            Opportunity objCloneOpp = objOpportunity.clone(false, true, false, true);
                            objCloneOpp.Name = a.Name + '-' + 'Renewal' + ' ' + opp.Subscription_Start_Year__c;
                            objCloneOpp.RecordTypeId = recordTypeId;
                            if (o.ZDiscountAnnual__c == 0)
                                objCloneOpp.StageName = 'Nurturing';
                            else
                                objCloneOpp.StageName = 'Verbal';
                            objCloneOpp.Parent_Renewal_Opportunity__c = Null;
                            objCloneOpp.Parent_Opportunity__c = opp.Id;
                            objCloneOpp.AccountId = a.Id;
                            //if (a.AnnualRevenue != Null)
                                //objCloneOpp.Amount = a.AnnualRevenue;
                            //else
                                //objCloneOpp.Amount = 0;
                            //objCloneOpp.Subscription_Start_Year__c = opp.Subscription_End_Year__c;
                            objCloneOpp.Subscription_Start_Year__c = opp.Subscription_Start_Year__c;
                            Integer year = Integer.ValueOf(opp.Subscription_End_Year__c.trim());
                            Integer syear = Integer.ValueOf(opp.Subscription_End_Year__c.trim());
                            Integer numyears = year - syear;
                            //year = year + 1;
                            objCloneOpp.Subscription_End_Year__c = String.valueOf(year);
                            objCloneOpp.Subscription__c = Null;
                            objCloneOpp.NextStep = '';
                            objCloneOpp.Prior_Year_Amount__c = opp.Amount;
                            objCloneOpp.Prior_Year_Close_Date__c = opp.CloseDate;
                            objCloneOpp.Prior_Year_Teacher_Count__c = opp.No_of_Teachers__c;
                            objCloneOpp.Prior_Year_Student_Count__c = opp.No_of_Students__c;
                            if (a.Subscription_Expiry_Month__c != '')
                            {
                                Integer Yr = Integer.ValueOf(opp.Subscription_End_Year__c.trim());
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
                                objCloneOpp.CloseDate = opp.CloseDate;
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
                                if (o.Commitment_Duration__c > 1)
                                    objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c - 1);
                                else if (o.Commitment_Duration__c == 1)
                                    objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c);
                                if(objCloneOpp.Parent_Opportunity__c!=null && objCloneOpp.Subscription_End_Year__c!=null && objCloneOpp.Subscription_Start_Year__c!=null&&objCloneOpp.Teacher_Amount__c!=null&&objCloneOpp.Student_Amount__c!=null&&objCloneOpp.Child_discount_amount__c!=null){
                                    objCloneOpp.Amount=(objCloneOpp.Teacher_Amount__c+objCloneOpp.Student_Amount__c+objCloneOpp.Child_discount_amount__c)*(Integer.valueOf(objCloneOpp.Subscription_End_Year__c)-Integer.valueOf(objCloneOpp.Subscription_Start_Year__c));
                                    system.debug('objCloneOpp.Amount'+objCloneOpp.Amount); 
                                }
                            }
                            else
                                objCloneOpp.CloseDate = System.Today();
                            //objCloneOpp.CloseDate = opp.CloseDate.addDays(numyears*365);
                            //insert objCloneOpp;
                            lstOpportunityToInsert.add(objCloneOpp);
            
                            for(Opportunity objChild : objOpportunity.Opportunities__r)
                            {
                                lstOpportunityChild.add(objChild);
                            }
                                        
                            for(OpportunityLineItem objOLI : objOpportunity.OpportunityLineItems)
                            {
                                lstOpportunityLineItem.add(objOLI);
                            }
            
                            for(OpportunityContactRole objOCR : objOpportunity.OpportunityContactRoles)
                            {
                                lstOpportunityContactRole.add(objOCR);
                            }
                            
                            for (Quote objQuote :objOpportunity.Quotes)
                            {
                                lstOpportunityQuote.add(objQuote);
                            }
            
                            system.debug('objCloneOpp.Parent_Opportunity__c::: ' + objCloneOpp.Parent_Opportunity__c);
                            system.debug('opp.Id::: ' + opp.Id);
                            //system.debug('lstOpportunityToInsert.Size()::: ' + lstOpportunityToInsert.size());
                            system.debug('lstOpportunityToInsert::: '+ lstOpportunityToInsert);
                            //Inserting clone Opportunity.
                            insert lstOpportunityToInsert;
                
                            
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
                            }   
                            
                            for(Quote objQuote : lstOpportunityQuote)
                            {
                                Quote objCloneQuote = objQuote.clone(false, true, false, true);
                                objCloneQuote.OpportunityId = lstOpportunityToInsert[0].Id;
                                objCloneQuote.Status =  'Draft';
                                //lstOppChildToInsert.add(objCloneQuote);
                            }
                
                            //Inserting clone Opportunity Products.
                            insert lstOppChildToInsert;
                           
                            /*String qId;
                            List<Quote> quotes = [Select Id from Quote where OpportunityId = :o.Id AND Status = 'Accepted' LIMIT 1];
                            if (quotes.size() > 0)
                            {
                                qId = quotes[0].Id;
                                Set<String> QuoteFields = schema.Quote.sobjecttype.getdescribe().fields.getmap().keyset(),
                                QuoteLineFields = schema.quotelineitem.sobjecttype.getdescribe().fields.getmap().keyset();                
                                Quote q = (Quote)Database.query('select '+String.join(new list<string>(quotefields),',')+' from quote where Id = \''+qId+'\'');
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
                                for(QuoteLineItem item:qli)
                                {
                                    system.debug('QLI::: ' + item.Id);
                                    item.quoteid = q.id;                   
                                }
                                insert qli;
                                objCloneOpp.Amount = q.TotalPrice;
                                
                            }
                            if(!Test.isRunningTest())
                                update objCloneOpp;*/
                    
                        
                        }    
                    //}
                
                }
            opp.Cloned_Opportunity_To_Process__c = FALSE;
            update opp;                  
            }
      }
}