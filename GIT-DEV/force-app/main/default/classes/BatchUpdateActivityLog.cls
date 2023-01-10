global class BatchUpdateActivityLog implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
           
        global Database.QueryLocator start(Database.BatchableContext BC){
            string query; 
            List<String> status = new List<String>{'Prospecting','Nurturing','On the Fence','Presented to Admin','Quote Submitted','Negotiation','Promising','Verbal'};
            
            
            if (Test.isRunningTest())
            {           
                List<Quote> q = [select Id,Opportunity.Id from Quote where Status = 'Presented' and Opportunity.RecordTypeId =:Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId() and Opportunity.Account.No_of_Students__c <> NULL and Opportunity.StageName IN:status limit 10];
                Set<Id> Ids = New Set<Id>();
                for (Quote qu : q)
                    Ids.add(qu.Opportunity.Id);
                query = 'select Id,Scaling_down_from_last_year__c,Scaling_up_from_last_year__c,Scaling_up_consideration__c,Scaling_down_consideration__c,Account.No_of_Students__c,RecordTypeId,(select Status,Count_Quantity__c,OpportunityId from Quotes order by CreatedDate asc) from Opportunity where Id IN :Ids';
            }
            else
            {
                query = 'select Id,Scaling_down_from_last_year__c,Scaling_up_from_last_year__c,Scaling_up_consideration__c,Scaling_down_consideration__c,Account.No_of_Students__c,RecordTypeId,(select Status,Count_Quantity__c,OpportunityId from Quotes order by CreatedDate asc)  from Opportunity where StageName IN:status limit 9999';
            }
            system.debug(query);
            return Database.getQueryLocator(query);
        }
       
        global void execute(Database.BatchableContext BC, List<Opportunity>scope){
            for (Opportunity opp :scope)
            {
               ProcessRecord(opp);
            }
        }
    
        global void finish(Database.BatchableContext BC){
            
        }
   
        global void ProcessRecord(Opportunity op)
        {
            List<String> rtypeIds = new List<String>();
            rtypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId());
            rtypeIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Returning').getRecordTypeId());
            //String rtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            Boolean toBeUpdated = False;
           if (op.Scaling_down_from_last_year__c == TRUE)
            {
                op.Scaling_down_from_last_year__c = FALSE;
                toBeUpdated = TRUE;
            }
            if (op.Scaling_up_from_last_year__c  == TRUE)
            {
                op.Scaling_up_from_last_year__c  = FALSE;
                toBeUpdated = TRUE;
            }
            if (op.Scaling_up_consideration__c == TRUE)
            {
                op.Scaling_up_consideration__c = FALSE;
               toBeUpdated = TRUE;
            }
            if (op.Scaling_down_consideration__c == TRUE)
            {
                op.Scaling_down_consideration__c = FALSE;
                toBeUpdated = TRUE;
            }
            if (toBeUpdated == TRUE)
                update op;
            
            toBeUpdated = FALSE;
            if(op.Quotes.size()>0){
                if(op.Account.No_of_Students__c != NULL && (op.Quotes[0].Status == 'Presented') && rtypeIds.contains(op.RecordTypeId)){
                    Integer membeanStudentCount = Integer.valueOf(Math.ceil(Integer.valueOf(op.Account.No_of_Students__c)* 0.2));
                   
                    if(Integer.valueOf(op.quotes[0].Count_Quantity__c) <= (Integer.valueOf(op.Account.No_of_Students__c) - membeanStudentCount)){
                        op.Scaling_down_from_last_year__c = True;
                        toBeUpdated = True;
                    }
                    else if(Integer.valueOf(op.quotes[0].Count_Quantity__c) >= (Integer.valueOf(op.Account.No_of_Students__c) + membeanStudentCount)){
                        op.Scaling_up_from_last_year__c = True;
                        toBeUpdated = True;
                    }
                }
               
               
                Integer studentCount = Integer.valueOf(Math.ceil(Integer.valueOf(op.quotes[0].Count_Quantity__c)* 0.2));
                if (op.quotes.Size()>1)
                {
                    if(Integer.valueOf(op.quotes[op.quotes.size()-1].Count_Quantity__c) <= (Integer.valueOf(op.quotes[0].Count_Quantity__c) - studentCount)){
                        op.Scaling_down_consideration__c = True;
                        toBeUpdated = True;
                    }
                    else if(Integer.valueOf(op.quotes[op.quotes.size()-1].Count_Quantity__c) >= (Integer.valueOf(op.quotes[0].Count_Quantity__c) + studentCount)){                       
                        op.Scaling_up_consideration__c = True;
                        toBeUpdated = True;
                    }
                }
               
            }
            
            if(!!toBeUpdated){
                update op;
            }
                        
        }
    
}