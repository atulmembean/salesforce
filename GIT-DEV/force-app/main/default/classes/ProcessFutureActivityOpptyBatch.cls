global class ProcessFutureActivityOpptyBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Opportunity where Has_Future_Activity__c = TRUE LIMIT 1';  
            }
            else{
               query = 'Select id from Opportunity where Has_Future_Activity__c = TRUE';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Opportunity> scope){

                for(Opportunity o:scope){
                    ProcessRecord(o.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            Date dt = system.Today();
            List<Task> taskList = new List<Task>();           
            Opportunity o = [Select Id,Has_Future_Activity__c  from Opportunity where Id = :rId];
            if (o != Null)
            {
                tasklist = [Select Id from task where Status != 'Completed' And WhatId = :o.Id AND ActivityDate > :dt];
                if (taskList.Size() == 0)
                {
                    o.Has_Future_Activity__c = FALSE;
                    update o;
                }
            }
       }
}