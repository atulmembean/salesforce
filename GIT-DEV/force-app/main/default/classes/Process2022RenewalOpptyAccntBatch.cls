global class Process2022RenewalOpptyAccntBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Temp__c where Account_ID__c != NULL and CreatedDate = TODAY LIMIT 20';  
            }
            else{
               query = 'Select id from Temp__c where Account_ID__c != NULL and CreatedDate = TODAY';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Temp__c> scope){

                for(Temp__c accnt:scope){
                    ProcessRecord(accnt.Id);
                    system.debug('accnt.Id:::'+accnt.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            system.debug('rId:::'+rId);
            Temp__c t = [Select Account_Id__c, Id from Temp__c where Id = :rId];
            List<Payment__c> p = new List<Payment__c>();
            p = [Select Id,Temp__c,Invoice__r.Quote__r.Opportunity.Account.Id from Payment__c where CreatedDate = THIS_YEAR AND Invoice__r.Quote__r.Opportunity.Account.Id = :t.Account_Id__c];
            if (p.Size() > 0 && p[0].Invoice__r.Quote__r.Opportunity.Account.Id != NULL)
            {
                List<Opportunity> renoppty = [Select Id,Account.RecordType.Name from Opportunity where AccountId = :p[0].Invoice__r.Quote__r.Opportunity.Account.Id AND Subscription_Start_Year__c = '2022' AND Subscription_End_Year__c = '2023' LIMIT 1];
                if (renoppty.Size() == 0)
                {
                    p[0].Temp__c = TRUE;
                    update p[0];
                }
            }
            
       }
}