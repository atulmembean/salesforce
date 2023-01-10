global class ProcessOneTimeAccountCountyBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            dt = dt.addDays(-210);
            String close = 'Close Lost';
            close = '\''+close+'\'';
            List<String> stage = New List<String>{'Renewal'};
            if(Test.isRunningTest()){
               query = 'Select id from Account where County_Name__c != Null LIMIT 5';  
            }
            else{
               query = 'Select id from Account where County_Name__c != Null AND State_County_Mapping__c = NULL LIMIT 49000';
            }
            
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Account> scope){

                for(Account a:scope){
                    ProcessRecord(a.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            List<account> acclst = [Select Id, State_County_Mapping__c, County_Name__c, BillingState from Account where Id = :rId];
            
            if (acclst.Size()>0)
            {
                String chk = acclst[0].BillingState + ' ' + acclst[0].County_Name__c;
                List<City_State_Mapping__c> sclst = [Select Id,Name from City_State_Mapping__c where Type__c = 'Tax' AND Name = :chk];
                if (sclst.size() >0)
                {
                    acclst[0].State_County_Mapping__c = sclst[0].Id;
                    update acclst[0];
                }
                
            }
       }
}