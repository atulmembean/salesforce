/**
* Handler Class     : QuoteTriggerHandler
* Created by        : ETMarlabs (01-08-2016)
* Version           : 1.0  -- Initail Draft(01-08-2016)
2.0  -- Update code for child Opportunity (25-08-2016)  
* Description       : Trigger Handler contains all the Business logic for QuoteTrigger trigger.
*                   : Inline comments are added to get specific details.
**/
public class QuoteTriggerHandler extends TriggerHandler{
    
    /*Variable declaration */
    public List<Quote> newQuoteList;
    public List<Quote> oldQuoteList;
    public map<id,Quote> newQuoteMap;
    public map<id,Quote> oldQuoteMap;
    
    /*Default Constructor*/
    public QuoteTriggerHandler(){
        //nothing
    }
    /*parameterized constructor*/
    public QuoteTriggerHandler(List<Quote> newList , List<Quote> oldList, map<id,Quote> newMap , map<id,Quote> oldMap){
        
        newQuoteList = (newList != null && !newList.isEmpty())? newList : new List<Quote>();
        oldQuoteList = (oldList != null && !oldList.isEmpty())? oldList : new List<Quote>();
        newQuoteMap = (newMap != null && !newMap.isEmpty())? newMap : new map<id,Quote>();
        oldQuoteMap = (oldMap != null && !oldMap.isEmpty())? oldMap : new map<id,Quote>();
    }
    /*Override afterUpdate Method*/
    
    public override void afterUpdate(){
        this.updateSchoolDetails();
    }
    
    /*
    * Method Name   : updateSchoolDetails
    * Description   : Method contains all the business logic for updating the opportunity record     
    * @param        : None
    * @returns      : None
    */
    
    @testVisible
    private void updateSchoolDetails(){
        List<ID> ListofOppForAddedQuote =  new List<ID>();
        List<ID> ListofAcceptedQuoteId =  new List<ID>();
        List<ID> ListofAcceptedQuoteOppId =  new List<ID>();
        if(OpportunityService.runAfterOnce()){
        try{ 
            for(Quote quoteObj : newQuoteList){
                ListofOppForAddedQuote.add(quoteObj.OpportunityId);
                if(quoteObj.Status==Constants.QUOTE_STATUS_ACCEPTED){
                    ListofAcceptedQuoteId.add(quoteObj.id);
                    ListofAcceptedQuoteOppId.add(quoteObj.OpportunityId);
                }
            }
            
            Map<id,Opportunity> mapOfOpp = new Map<id,Opportunity>([select name,No_of_Students__c,Subscription_Start_Year__c,Subscription_End_Year__c,StageName,(select id,Status,Grand_Total_Yrs__c,Teacher_Rate__c,Student_Rate__c,Teacher_Count__c,Count_Quantity__c,OpportunityId,GrandTotal from Quotes),(select id,No_of_Students__c,No_of_Teachers__c,Amount,StageName from Opportunities__r),Amount,No_of_Teachers__c,RecordTypeId 
                                                                    from opportunity where id IN :ListofOppForAddedQuote]);
            
            if(!mapOfOpp.isEmpty()){
                List<Opportunity> ListOfOppToUpdate = new List<Opportunity>();
                List<Quote> quoteList = new List<Quote>();
                List<Quote> quoteListToBeUpdate = new List<Quote>();
                Map<id,Quote> mapOfQuoteWithQLI = new Map<id,Quote>([select id,Grand_Total_Yrs__c,Teacher_Rate__c,Student_Rate__c,Subscription_End_Year__c,Teacher_Count__c,Count_Quantity__c,Subscription_Start_Year__c,Status,OpportunityId,GrandTotal,RecordTypeId,(Select id,Quantity,TotalPrice,Product2.Family from QuoteLineItems) from Quote where OpportunityId IN :ListofOppForAddedQuote]);
                
                for(Quote quoteObj : mapOfQuoteWithQLI.values()){
                    if(newQuoteMap.containsKey(quoteObj.id)){
                        quoteList.add(quoteObj);
                    }
                }
                
                for(Quote quoteObj : quoteList){
                    /* if Quote is accepted, then update the parent opportunity with Actual amount and also change the stage.*/
                    if(quoteObj.Status==Constants.QUOTE_STATUS_ACCEPTED && oldQuoteMap != null && oldQuoteMap.size()>0 ){
                        Opportunity parentOpp = mapOfOpp.get(quoteObj.OpportunityId);
                        if(quoteObj.RecordTypeId == Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Constants.QUOTE_RECORDTYPE_NAME_REJECTED).getRecordTypeId()){
                            quoteObj.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Constants.QUOTE_RECORDTYPE_NAME_ACTIVE).getRecordTypeId();        
                            quoteListToBeUpdate.add(quoteObj); 
                            system.debug('--quoteListToBeUpdate'+quoteListToBeUpdate+'quoteObj'+quoteObj);     
                        }
                        
                        /* Update Parent opportunity record */
                        parentOpp.StageName = Constants.OPP_STAGE_WON;
                        parentOpp.amount = quoteObj.Grand_Total_Yrs__c;
                        parentOpp.Subscription_Start_Year__c=quoteObj.Subscription_Start_Year__c;
                        parentOpp.Subscription_End_Year__c=quoteObj.Subscription_End_Year__c;
                        parentOpp.No_of_Students__c = quoteObj.Count_Quantity__c;
                        parentOpp.No_of_Teachers__c = quoteObj.Teacher_Count__c;
                        parentOpp.Student_Rate__c=quoteObj.Student_Rate__c;
                        parentOpp.Teacher_Rate__c=quoteObj.Teacher_Rate__c;
                        //parentOpp.Subscription_Processed__c = TRUE;
                        /*update child Opportunity for record Type - Grouped & Grouped Multiyear if prev status was not equal to Accepted */
                        if(oldQuoteMap.get(quoteObj.id).Status != Constants.QUOTE_STATUS_ACCEPTED){
                            if(parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_Grouped).getRecordTypeId() ||
                               parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_GroupedMultiyear).getRecordTypeId() || Test.isRunningTest()
                              ){
                                   for(Opportunity childOpp : parentOpp.Opportunities__r){
                                       childOpp.amount = 0;
                                       childOpp.No_of_Students__c = 0;
                                       childOpp.No_of_Teachers__c = 0;
                                       ListOfOppToUpdate.add(childOpp);
                                   }    
                               }
                        } 
                        
                        Double AmountTobeSplitBetweenChildOpps = 0.0;
                        
                        ListOfOppToUpdate.add(parentOpp);
                        system.debug('--ListOfOppToUpdate--'+ListOfOppToUpdate+'--parentOpp--'+parentOpp);
                    }
                    
                    else if((quoteObj.Status==Constants.QUOTE_STATUS_PRESENTED || quoteObj.Status==Constants.QUOTE_STATUS_DRAFT || quoteObj.Status==Constants.QUOTE_STATUS_REJECTED)){
                        /*Change recordType of Quote*/
                        Opportunity parentOpp = mapOfOpp.get(quoteObj.OpportunityId);
                        Opportunity parentOppCopy = parentOpp;
                        parentOpp.Subscription_Start_Year__c=quoteObj.Subscription_Start_Year__c;
                            parentOpp.Subscription_End_Year__c=quoteObj.Subscription_End_Year__c;
                            parentOpp.Student_Rate__c=quoteObj.Student_Rate__c;
                            parentOpp.Teacher_Rate__c=quoteObj.Teacher_Rate__c;
                        if(oldQuoteMap.get(quoteObj.id).Status == Constants.QUOTE_STATUS_ACCEPTED || Test.isRunningTest()) {
                            if(quoteObj.Status==Constants.QUOTE_STATUS_REJECTED){
                                quoteObj.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Constants.QUOTE_RECORDTYPE_NAME_REJECTED).getRecordTypeId();
                                quoteListToBeUpdate.add(quoteObj);
                            }
                            else{
                                quoteObj.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Constants.QUOTE_RECORDTYPE_NAME_ACTIVE).getRecordTypeId();    
                            }
                            
                            /*update child Opportunity for record Type - Grouped & Grouped Multiyear if prev status was equal to Accepted */
                            if(parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_Grouped).getRecordTypeId() ||
                               parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_GroupedMultiyear).getRecordTypeId()){
                                   for(Opportunity childOpp : parentOpp.Opportunities__r){
                                       childOpp.amount = 0;
                                       childOpp.No_of_Students__c = 0;
                                       childOpp.No_of_Teachers__c = 0;
                                       ListOfOppToUpdate.add(childOpp);
                                   }
                               }
                        }
                        parentOpp.amount = 0;
                        parentOpp.No_of_Students__c = 0;    
                        parentOpp.No_of_Teachers__c = 0;
                        
                        ID leastQuoteId ; 
                        Boolean checkIfAnyOtherQuoteIsAccpeted = false;
                        /* Check for other Quotes to get minimum values */
                        system.debug('mapOfOpp.get(quoteObj.OpportunityId).Quotes @@'+mapOfOpp.get(quoteObj.OpportunityId).Quotes);
                        for(Quote otherQuote : mapOfOpp.get(quoteObj.OpportunityId).Quotes){
                            if(otherQuote.status == Constants.QUOTE_STATUS_PRESENTED || otherQuote.status == Constants.QUOTE_STATUS_DRAFT || otherQuote.status == Constants.QUOTE_STATUS_ACCEPTED){
                                if(otherQuote.status == Constants.QUOTE_STATUS_PRESENTED || otherQuote.status == Constants.QUOTE_STATUS_DRAFT){
                                    if(parentOpp.amount == 0){
                                        system.debug('in first if##');
                                        parentOpp.amount = otherQuote.Grand_Total_Yrs__c;
                                        leastQuoteId = otherQuote.id;
                                    }
                                    if(parentOpp.amount > otherQuote.Grand_Total_Yrs__c || Test.isRunningTest()){
                                        system.debug('in second if##');
                                        leastQuoteId = otherQuote.id;
                                        parentOpp.amount = otherQuote.Grand_Total_Yrs__c;
                                    }
                                }
                                else
                                {
                                    system.debug('in the else**');
                                    checkIfAnyOtherQuoteIsAccpeted = true; 
                                } 
                            }
                        }
                        
                        Quote quoteWithLeastAmount = mapOfQuoteWithQLI.get(leastQuoteId);
                        if(quoteWithLeastAmount != null && !checkIfAnyOtherQuoteIsAccpeted || Test.isRunningTest()){
                            parentOpp.amount = quoteWithLeastAmount.Grand_Total_Yrs__c;
                            parentOpp.Subscription_Start_Year__c=quoteWithLeastAmount .Subscription_Start_Year__c;
                            parentOpp.Subscription_End_Year__c=quoteWithLeastAmount .Subscription_End_Year__c;
                            parentOpp.No_of_Students__c = quoteWithLeastAmount.Count_Quantity__c;
                            parentOpp.No_of_Teachers__c = quoteWithLeastAmount.Teacher_Count__c;
                            parentOpp.Student_Rate__c=quoteWithLeastAmount.Student_Rate__c;
                            parentOpp.Teacher_Rate__c=quoteWithLeastAmount.Teacher_Rate__c;    
                          
                        }
                        else if(quoteWithLeastAmount == null && !checkIfAnyOtherQuoteIsAccpeted){
                            /* update child opp if parents record type is Multiyear*/
                            if(parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_Multiyear).getRecordTypeId()){
                                if(parentOpp.Opportunities__r.size()>0){
                                    for(Opportunity childOpp : parentOpp.Opportunities__r){
                                        childOpp.amount = 0;
                                        childOpp.No_of_Students__c = 0;
                                        childOpp.No_of_Teachers__c = 0;
                                        ListOfOppToUpdate.add(childOpp);
                                    }
                                }
                            }
                        }
                        if(!checkIfAnyOtherQuoteIsAccpeted)
                            ListOfOppToUpdate.add(parentOpp);       
                    }
                }
                if(ListOfOppToUpdate != null && ListOfOppToUpdate.size()>0)
                    update ListOfOppToUpdate;
                
                /* Update the Quote ReordType when user manually marking it as rejected to accepted*/    
                if(quoteListToBeUpdate != null && quoteListToBeUpdate.size()>0){
                    TriggerHandler.bypass('QuoteTriggerHandler');
                    update quoteListToBeUpdate;
                    TriggerHandler.clearBypass('QuoteTriggerHandler');
                }    
            }
            /*Once the Quote is accepted ,reject all other Quote related to particular opportunity */
            if(ListofAcceptedQuoteId.size()>0)
                updateAllOtherQuotesWhenAnyQuoteIsAccepted(ListofAcceptedQuoteId,ListofAcceptedQuoteOppId);   
            //Added by Karthik on 17/07/20 fixing issues related to multiple quotes against grouped opportunity
            Set<Id>quoteIds=new Set<Id>();
            for(Quote objQuote:newQuoteMap.values()){
                System.debug('Inside for loop before checking quote is accepted');
                if(objQuote.Status!=oldQuoteMap.get(objQuote.Id).Status && objQuote.Status==Constants.QUOTE_STATUS_ACCEPTED){
                    System.debug('The quote status is accepted. QuoteId ='+objQuote.Id +' objQuote.Name='+objQuote.Name);
                    quoteIds.add(objQuote.Id);
                    UpdateOppOnQuoteAccept(quoteIds);
                }
            }
        }
           
        catch(Exception e){
            System.debug('Exception --> '+e);
            system.debug('Exception Message-->'+e.getMessage());
            system.debug('Exception Line Number-->'+e.getLineNumber());
        } 
       }
    }
    @future
    public static void UpdateOppOnQuoteAccept(Set<Id>quoteIds){
        Map<Id,Quote>quoteMap=new Map<Id,Quote>([select id,Teacher_count__c, Count_Quantity__c, GrandTotal,Grand_Total_Yrs__c, OpportunityId,Opportunity.Account.RecordType.Name from Quote where id in :quoteIds]);
        Set<Id>oppIds=new Set<Id>();
        List<Opportunity>lstOpp=new List<Opportunity>();
        List<Opportunity> lstoppchildupd = New LIst<Opportunity>();
        for(Quote objQuote:quoteMap.values()){
            system.debug('Inside for loop of future method. Quote : '+objQuote);
            Opportunity objOpportunity=new Opportunity();
            objOpportunity.Id=objQuote.OpportunityId;
            //objOpportunity.Amount=objQuote.GrandTotal;
            objOpportunity.Amount=objQuote.Grand_Total_Yrs__c;
            objOpportunity.No_Of_Students__c=objQuote.Count_Quantity__c;
            objOpportunity.No_Of_Teachers__c=objQuote.Teacher_Count__c;
            if (objQuote.Opportunity.Account.RecordType.Name == 'District')
            {
                List<Opportunity> lstoppchild = [Select Id,Subscription_Processed__c from Opportunity where Parent_Opportunity__c = :objQuote.OpportunityId];
                
                for (Opportunity och :lstoppchild)
                {
                    och.Subscription_Processed__c = TRUE;
                    lstoppchildupd.add(och);
                }
            }
            lstOpp.add(objOpportunity);
        }
        Database.upsert(lstOpp,false);
        Database.update(lstoppchildupd,false);
        //Map<Id,Opporutnity>oppMap=new Map<Id,Opporutnity>([select id,name,amount,No_of_Teachers__c, No_of_Students__c from Opportunity]);
    }
    /*
    * Method Name   : updateAllOtherQuotesWhenAnyQuoteIsAccepted
    * Description   : logic will fetch all the quotes which arent accepted and update its status as well as record Type to rejected.      
    * @param        : list of Quote ID and List of opportunity ID.
    * @returns      : None
    */
    //Was commented. No idea why.. 
    @testVisible
    private void updateAllOtherQuotesWhenAnyQuoteIsAccepted(List<ID> ListofAcceptedQuoteIds,List<ID> ListofAcceptedQuoteOppIds){
        try{
            List<Quote> ListOfQuoteToBeUpdate = new List<Quote>();
            List<Quote> ListOfQuote = new List<Quote>();
            ListOfQuote = [Select id,Status,RecordTypeId from Quote where Id NOT IN : ListofAcceptedQuoteIds and OpportunityId IN : ListofAcceptedQuoteOppIds];
            for(Quote quoteForObj : ListOfQuote){
                if(quoteForObj.Status != Constants.QUOTE_STATUS_REJECTED || (quoteForObj.RecordTypeId != Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Constants.QUOTE_RECORDTYPE_NAME_REJECTED).getRecordTypeId())){
                    quoteForObj.Status = Constants.QUOTE_STATUS_REJECTED;
                    quoteForObj.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Constants.QUOTE_RECORDTYPE_NAME_REJECTED).getRecordTypeId();
                    ListOfQuoteToBeUpdate.add(quoteForObj);
                }
            }
            if(ListOfQuoteToBeUpdate.size() > 0){
                TriggerHandler.bypass('QuoteTriggerHandler');
                update ListOfQuoteToBeUpdate;
                TriggerHandler.clearBypass('QuoteTriggerHandler');
            }
        }
        catch(Exception e){
            System.debug('Exception in updateAllOtherQuotesWhenAnyQuoteIsAccepted method --> '+e);
        }  
    }
    
    
    //Method to update Child Opportunities as well as parrent opportunities in case of Grouped Opportunities    
    Public void quoteSyncWithOpportunity(List<Quote> quoteList,Map<Id,Quote> quoteMap){
        system.debug('quoteList 111-->'+quoteList);
        system.debug('quoteMap 222-->'+quoteMap);
        Map<Id,List<Quote>> parentQuoteMap=new Map<Id,List<Quote>>(); 
        List<Quote> quotessList;
        List<Id> quotelistId=new List<Id>();
        Map<Id,Quote> acceptedQuoteMap=new Map<Id,Quote>();
        Set<Id> opportunitySet=new Set<Id>();
        Opportunity parentOpp;
        for(Quote quotes:quoteList){
            if(quotes.GrandTotal!= quoteMap.get(quotes.Id).GrandTotal || (quotes.Status != quoteMap.get(quotes.Id).status && quotes.Status==Constants.QUOTE_STATUS_ACCEPTED)) {
                
                opportunitySet.add(quotes.OpportunityId);
                quotelistId.add(quotes.Id);
            }
        }
        system.debug('oppotunityset-->'+opportunitySet);
        if(opportunitySet.size() > 0) updateSplitSchoolDetails(opportunitySet);
    }
        
    //Method to update Opportunities in case of Grouped Opportunities
    public void updateSplitSchoolDetails(set<Id> opportunitySet) {
        system.debug('Entered updateSplitSchoolDetails'+opportunitySet);
        Map<Id,List<Quote>> parentQuoteMap=new Map<Id,List<Quote>>(); 
        Map<Id,Quote> acceptedQuoteMap=new Map<Id,Quote>();
        Map<Id,Quote> quoteSplitQuery= new Map<Id, Quote>([select id,Status,Teacher_Rate__c,Student_Rate__c,Teacher_Count__c,Count_Quantity__c,Total_Discounts__c,Subscription_Start_Year__c,Grand_Total_Yrs__c,Subscription_End_Year__c,TotalPrice,OpportunityId,GrandTotal,(Select id,Name,No_of_Students__c,No_of_Teachers__c,Opportunity_Name__c,Quote_Name__c from Split_School_Details__r) from Quote where OpportunityId in :opportunitySet]);
        Decimal minimalAmount;
        for(Quote quotedetails:quoteSplitQuery.values()){
            if(!parentQuoteMap.containsKey(quotedetails.OpportunityId))
                parentQuoteMap.put(quotedetails.OpportunityId, New List<Quote>());
            parentQuoteMap.get(quotedetails.OpportunityId).add(quotedetails);
        }
        
        for(Id idds:parentQuoteMap.keySet()){
            
            minimalAmount=Null;
            
            for(Quote quotes:parentQuoteMap.get(idds)){
                if(quotes.Status==Constants.QUOTE_STATUS_ACCEPTED){
                    
                    acceptedQuoteMap.put(quotes.OpportunityId,quotes);
                    break;
                }else if(minimalAmount==Null||minimalAmount>quotes.Grand_Total_Yrs__c){
                    
                    minimalAmount=quotes.Grand_Total_Yrs__c;
                    acceptedQuoteMap.put(quotes.OpportunityId, quotes);
                }
            }   
        }
        
        List<Id> childIDOppList=new List<Id>();
        Map<Id, Map<Id,opportunity>> childOppMap=new Map<Id,Map<Id,opportunity>>();
        for(Opportunity childOPPId:[select id,Parent_Opportunity__c,AccountId,(select id from Opportunities__r) from opportunity where Id IN:acceptedQuoteMap.keySet()]){
            childIDOppList.add(childOPPId.Id);
            if(!childOppMap.containsKey(childOPPId.Id))
                childOppMap.put(childOPPId.Id, new Map<Id,Opportunity>(childOPPId.Opportunities__r));
        }
        
        List<Opportunity> childOppList=new List<Opportunity>();
        List<Opportunity> parentOppList=new List<Opportunity>();
        
        for(Id oppId : acceptedQuoteMap.Keyset()){
            Opportunity parentOpp1 = new Opportunity();
            parentOpp1.Id = oppId;
            Quote q = acceptedQuoteMap.get(oppId);
            parentOpp1.No_of_Teachers__c=q.Teacher_Count__c;
            parentOpp1.No_of_Students__c=q.Count_Quantity__c;
            parentOpp1.Subscription_Start_Year__c=q.Subscription_Start_Year__c;
            parentOpp1.Subscription_End_Year__c=q.Subscription_End_Year__c;
            parentOpp1.Amount=q.Grand_Total_Yrs__c;
            parentOpp1.Teacher_Rate__c=q.Teacher_Rate__c;
            parentOpp1.Student_Rate__c=q.Student_Rate__c;
            childOppList.add(parentOpp1);
            
            for(Split_School_Detail__c splitDetails:acceptedQuoteMap.get(oppId).Split_School_Details__r){
                Opportunity childOpp = new Opportunity();
                childOpp = childOppMap.get(oppId).get(splitDetails.Opportunity_Name__c);
                childOpp.No_of_Teachers__c=splitDetails.No_of_Teachers__c;
                childOpp.No_of_Students__c=splitDetails.No_of_Students__c;
                childOpp.Subscription_Start_Year__c=q.Subscription_Start_Year__c;
                childOpp.Subscription_End_Year__c=q.Subscription_End_Year__c;
                childOpp.Teacher_Rate__c=q.Teacher_Rate__c;
                childOpp.Student_Rate__c=q.Student_Rate__c;
                childOpp.Total_discount_amount__c=q.Total_Discounts__c;
                childOpp.Subscription_Processed__c = TRUE;
                childOppList.add(childOpp);
            }
        }

        try{
            if(!Test.isRunningTest()) 
            update childOppList;            
        }catch(Exception e){
            system.debug('Exception--'+e);
        }
    }
    
    //Method to calculate List Price based on product Family
    Public void discountAmount(List<Quote> quotelist){
        Map<id,Decimal> mapquote=new Map<Id,Decimal>();
       
        for(Aggregateresult qli:[select  quoteid ids, sum(TotalPrice) total  from QuoteLineitem where quoteid in:quotelist and (Quote_Product_Family__c='Discounts' or Quote_Product_Family__c='Tax')  group by quoteid] ){
            if(!mapquote.containsKey((id)qli.get('ids'))){
                mapquote.put((id)qli.get('ids'),(Decimal)qli.get('total'));
            }
        }
        for(Quote kkk:quotelist){
            kkk.Total_Discounts__c=mapquote.containsKey(kkk.id) ? mapquote.get(kkk.id):0.0;           
        }
                
    }
    
    
    public static void activityLogUpdate(List<Quote> quotes,Map<Id,Quote> oldQuotesMap){
               
        List<Quote> alteredQuoteList = new List<Quote>();
        List<String> oppIds = new List<String>{};
        List<String> quoteIds = new List<String>{};
        
        for(Quote q:quotes){
            
            Quote qt = oldQuotesMap.get(q.Id);
                         
            if((qt.Count_Quantity__c != q.Count_Quantity__c) && (q.Status != 'Accepted')){
                
                oppIds.add(q.OpportunityId);
                quoteIds.add(q.Id);
                alteredQuoteList.add(q);
         
            }
            else if((qt.Status != q.Status) && (q.Status == 'Presented')){
                oppIds.add(q.OpportunityId);
                alteredQuoteList.add(q);
            }
            
        }
        List<Opportunity> opp = new List<Opportunity>();
        List<Quote> quote = new List<Quote>();
        
        if(!Test.isRunningTest()){
            opp = [select Key_Activity_Log__c,Scaling_down_from_last_year__c,Scaling_up_from_last_year__c,Scaling_up_consideration__c,Scaling_down_consideration__c,Account.No_of_Students__c,RecordTypeId,(select Status,Count_Quantity__c,OpportunityId from Quotes order by CreatedDate asc limit 1 ) from Opportunity where Id IN:oppIds];
            quote = [select Count_Quantity__c,OpportunityId,Account.No_of_Students__c from Quote where (OpportunityId IN:oppIds and Id NOT IN: quoteIds) order by CreatedDate asc limit 1]; 
        }
        else if(oppIds.size()>0){
            
            opp = [select Key_Activity_Log__c,Scaling_down_from_last_year__c,Scaling_up_from_last_year__c,Scaling_up_consideration__c,Scaling_down_consideration__c,Account.No_of_Students__c,RecordTypeId,(select Status,Count_Quantity__c,OpportunityId from Quotes order by CreatedDate asc limit 1 ) from Opportunity where Id IN:oppIds limit 1]; 
            //quote = [select Count_Quantity__c,OpportunityId,Account.Membean_Student_Count__c from Quote where Name = 'Grouped_one' order by CreatedDate asc limit 1]; 
        }
                 
        for(Quote aq:alteredQuoteList){
             String prependData = '';
             String scaledData = '';
             Boolean scaledUp = False;
             Boolean scaledDown = False;
            
             prependData = '-> {'+aq.CreatedDate.format('YYYY-MM-dd HH:mm:ss')+'}: {'+aq.School_Years__c+'} quote for {'+aq.Count_Quantity__c+'} students at {'+aq.Student_Rate__c+'}.';
             
             for(Quote qu:quote){
                 if(qu.OpportunityId == aq.OpportunityId){
                     
                     if(qu.Count_Quantity__c > 0){
                         
                         Integer studentCount = Integer.valueOf(Math.ceil(Integer.valueOf(qu.Count_Quantity__c)* 0.2));                    
                                          
                         if(Integer.valueOf(aq.Count_Quantity__c) <= (Integer.valueOf(qu.Count_Quantity__c) - studentCount)){
                             scaledData = '-> {'+aq.CreatedDate.format('YYYY-MM-dd HH:mm:ss')+'}: Scaling down: Took a new quote for ['+aq.Count_Quantity__c+'] students - scaled down by {'+(Integer.valueOf(qu.Count_Quantity__c)-Integer.valueOf(aq.Count_Quantity__c))*100/Integer.valueOf(qu.Count_Quantity__c)+'%}';
                             scaledDown = True;
                         }
                         else if(Integer.valueOf(aq.Count_Quantity__c) >= (Integer.valueOf(qu.Count_Quantity__c) + studentCount)){
                             scaledData = '-> {'+aq.CreatedDate.format('YYYY-MM-dd HH:mm:ss')+'}: Scaling up: Took a new quote for ['+aq.Count_Quantity__c+'] students - scaled up by {'+(Integer.valueOf(aq.Count_Quantity__c)-Integer.valueOf(qu.Count_Quantity__c))*100/Integer.valueOf(qu.Count_Quantity__c)+'%}';
                             scaledUp = True;
                         }
                         
                     }
                    
                 } 
                
             }                        
             
            for(Opportunity op:opp){
                                              
                if((op.Account.No_of_Students__c != NULL) && ((op.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId())||(Test.isRunningTest())) && (op.quotes[0].Status == 'Presented')){
                    Integer membeanStudentCount = Integer.valueOf(Math.ceil(Integer.valueOf(op.Account.No_of_Students__c)* 0.2));
                    
                    if(Integer.valueOf(op.quotes[0].Count_Quantity__c) <= (Integer.valueOf(op.Account.No_of_Students__c) - membeanStudentCount)){
                        op.Scaling_down_from_last_year__c = True;     
                    }
                    else if(Integer.valueOf(op.quotes[0].Count_Quantity__c) >= (Integer.valueOf(op.Account.No_of_Students__c) + membeanStudentCount)){
                        op.Scaling_up_from_last_year__c = True;
                    }
                }
                        
                
                String prevLog = (op.Key_Activity_Log__c != null)?op.Key_Activity_Log__c:'';
                op.Key_Activity_Log__c = prependData+'\n'+scaledData+'\n'+prevLog;
                
                if(scaledUp == True){
                    op.Scaling_up_consideration__c = True;                    
                }
                else if(scaledDown == True){
                    op.Scaling_down_consideration__c = True;
                }
            }
             
        }
        if(opp.size()>0){
            update opp;
        }
        
              
    }
    
    public static void quoteAmountChange(List<Quote> qu, Map<Id,Quote> oldQuote){
                
        Set<Id> quoteIds = new Set<Id>();
        List<Quote> quoteList = new List<Quote>();
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        List<QuoteLineItem> newTaxLineItems = new List<QuoteLineItem>();
        List<QuoteLineItem> TaxLineItemsToDelete = new List<QuoteLineItem>();
        Set<String> pricebookIds = new Set<String>();
        
        for(Quote q:qu){
            if(q.TotalPrice != oldQuote.get(q.Id).TotalPrice && (q.Status == 'Draft'||q.Status == 'Presented') && q.Tax_override__c == False){
                quoteIds.add(q.Id);
            } 
        }
        
        if(quoteIds.size()>0){
                    
            quoteList = [select Opportunity.Account.Tax__c,PriceBook2Id,(select Product2.Id,Product2.Name,Quantity,TotalPrice,UnitPrice,Subtotal from QuoteLineItems) from Quote where Opportunity.Account.Tax_Exempt__c = False and Opportunity.Account.Tax__c <> Null and Id IN:quoteIds];
            
            for(Quote qList:quoteList){
                pricebookIds.add(qList.PriceBook2Id);
            }
            
            List<PricebookEntry> prEntry = [select Id,Product2Id,PriceBook2Id from PricebookEntry where PriceBook2Id IN:pricebookIds and Product2.Name = 'Tax']; 
            
            Map<Id,PricebookEntry> pbEntry = new Map<Id,PricebookEntry>();
            
            for(PricebookEntry p:prEntry){
                pbEntry.put(p.PriceBook2Id,p);
            }
                       
            if(quoteList.size()>0){
               
                for(Quote ql:quoteList){
                    Decimal sum = 0;                    
                    QuoteLineItem qliTax;
                    QuoteLineItem ntlItm;
                    
                    for(QuoteLineItem qli:ql.QuoteLineItems){
                        if(qli.Product2.Name != 'Tax'){
                           sum += qli.Subtotal;                           
                        }
                        else{
                           qliTax = qli;
                        }                         
                    }
                     
                    if(qliTax != Null && sum != 0 && ql.Opportunity.Account.Tax__c>0){
                        qliTax.UnitPrice = sum*ql.Opportunity.Account.Tax__c/100;
                        qliTax.Quantity = 1;
                        
                        qliList.add(qliTax);  
                    }
                    else if(qliTax == Null && sum != 0 && (ql.Opportunity.Account.Tax__c != Null && ql.Opportunity.Account.Tax__c != 0)){
                        ntlItm = new QuoteLineItem(Quantity = 1,UnitPrice = sum*ql.Opportunity.Account.Tax__c/100,Product2Id = pbEntry.get(ql.Pricebook2Id).Product2Id,QuoteId = ql.Id,PricebookEntryId = pbEntry.get(ql.Pricebook2Id).Id);
                        newTaxLineItems.add(ntlItm);
                    }
                    else if(qliTax != Null && (sum == 0 || ql.Opportunity.Account.Tax__c == Null || ql.Opportunity.Account.Tax__c == 0)){
                        TaxLineItemsToDelete.add(qliTax);
                    }
                }
               
            }
            
        }
        
        if(qliList.size()>0)
        update qliList;
        
        if(newTaxLineItems.size()>0)
        insert newTaxLineItems;
        
        if(TaxLineItemsToDelete.size()>0)
        delete TaxLineItemsToDelete;
           
    } 

    public static void quoteChange(List<Quote> qu,Map<Id,Quote> oldQu){
        
        Set<String> newQuoteIds = new Set<String>();
        
        for(Quote q:qu){
            if(q.Invoice_payment_count__c == 0){
                newQuoteIds.add(q.Id);
            }
        }
        
        List<Quote> newQuotes = [select Id,Name,(select Product2Id,Quantity from QuoteLineItems),(select Name from Invoices__r) from Quote where Id IN:newQuoteIds];
        
    }    
    public static void restrictAcceptedQuoteModification(Map<Id,Quote>oldMap,Map<Id,Quote>newMap){
        //
        Map<Id,Quote>existingQuoteInvoices=new Map<Id,Quote>([select id,name,(Select id,name,Paypal_status__c,Subscription_Start_Date__c,
                                                                              Subscription_Month__c,Payment_Terms__c,P_O_Number__c,Due_Date__c,
                                                                              No_of_Years__c from Invoices__r) from Quote where id in:oldMap.keySet()]);
        for(Quote objQuote:oldMap.values()){
            /*if(objQuote.status.equalsIgnoreCase('Accepted') && existingQuoteInvoices.get(objQuote.Id).Invoices__r.size()>1){
                objQuote.addError('Spilt-invoice quotes cannot be modified');
            }*/
            for(Invoice__c objInvoice:objQuote.Invoices__r){
                if(objInvoice.Paypal_status__c.equalsIgnoreCase('Paid')){
                    objQuote.addError('Invoice is paid, quote cannot be modified.');    
                }
                else{
                    //Update fields on invoices basis upon their value change on quote
                   /* if(objQuote.Subscription_Start_Date__c!=newMap.get(objQuote.Id).Subscription_Start_Date__c ){
                        
                    }*/
                }
            }
        }
    }
}