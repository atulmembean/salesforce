global class ProcessMMLeadLastContactTimeBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            dt = dt.addDays(-210);
            String close = 'Close Lost';
            close = '\''+close+'\'';
            List<String> stage = New List<String>{'Renewal'};
            if(Test.isRunningTest()){
               query = 'Select id from Lead where Process_Massmailer__c = TRUE LIMIT 1';  
            }
            else{
               query = 'Select id from Lead where Process_Massmailer__c = TRUE';
            }
            
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Lead> scope){

                for(Lead l:scope){
                    ProcessRecord(l.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            Lead ld = [Select Id,Lead_Contacted_DateTime__c,Process_Massmailer__c from Lead where Id = :rId];
            if (ld != Null)
            {
                ld.Lead_Contacted_DateTime__c = System.Now();
                ld.Process_Massmailer__c = FALSE;
                update ld;               
            }
       }
}