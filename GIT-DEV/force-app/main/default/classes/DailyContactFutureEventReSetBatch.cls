global class DailyContactFutureEventReSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date d = System.Today();
            if(Test.isRunningTest()){
               query = 'Select Id from Contact order by createddate desc LIMIT 20';  
            }
            else{
               query = 'Select Id from Contact where Has_Future_Event__c = TRUE';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Contact> scope){

                for(Contact c :scope){
                    ProcessRecord(c.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
           if (Test.isRunningTest())
               Database.executeBatch(new DailyFutureEventSetBatch(),20);
           else
               Database.executeBatch(new DailyFutureEventSetBatch(),1);    
       }
    
       global void ProcessRecord(String rId){
            Contact con = [Select Id,Has_Future_Event__c from Contact where Id = :rId];
            if (con != Null)
            {
                con.Has_Future_Event__c = FALSE;
                try{
                    update con;
                } catch (Exception e)
                {
                
                }
            }
       }
}