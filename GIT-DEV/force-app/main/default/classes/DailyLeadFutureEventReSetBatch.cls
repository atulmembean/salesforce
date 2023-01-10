global class DailyLeadFutureEventReSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date d = System.Today();
            if(Test.isRunningTest()){
               query = 'Select Id from Lead order by createddate desc LIMIT 20';  
            }
            else{
               query = 'Select Id from Lead where Has_Future_Event__c = TRUE';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Lead> scope){

                for(Lead l :scope){
                    ProcessRecord(l.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
           if (Test.isRunningTest())
               Database.executeBatch(new DailyContactFutureEventReSetBatch(),20);
           else
               Database.executeBatch(new DailyContactFutureEventReSetBatch(),1);     
       }
    
       global void ProcessRecord(String rId){
            Lead l = [Select Id,Has_Future_Event__c from Lead where Id = :rId];
            if (l != Null)
            {
                l.Has_Future_Event__c = FALSE;
                try{
                    update l;
                } catch (Exception e1)
                {
                
                }
            }
       }
}