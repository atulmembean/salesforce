global class ProcessOneTimeSubscriptionsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Temp__c LIMIT 5';  
            }
            else{
               query = 'Select id from Temp__c';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Temp__c> scope){

                for(Temp__c tm:scope){
                    ProcessRecord(tm.Id);
                    system.debug('tm.Id:::'+tm.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
           system.debug('rId:::'+rId);
            List<Contract> subs = new List<Contract>();        
            Temp__c t = [Select Id,Account_Id__c,No_Of_Students__c,Amount__c,Status__c from temp__c where Id = :rId];
            
            if (t != Null)
            {
                List<Account> acc = [Select Id,X18_Digit_ID__c from Account where Id  = :t.Account_Id__c];
                if (acc.Size()>0)
                {
                    subs = [Select Id,AccountId,No_of_Students__c,Amount__c,Subscription_Start_Year__c ,Subscription_End_Year__c from Contract where AccountId = :acc[0].X18_Digit_ID__c AND Subscription_Start_Year__c = '2021' AND Subscription_End_Year__c = '2022' LIMIT 1];              
                    if (subs.Size()>0)
                    {
                        system.debug('subs[0].Id::: ' + subs[0].Id);
                        subs[0].No_of_Students__c = t.No_of_Students__c;
                        subs[0].Amount__c = t.Amount__c;
                        update subs[0];
                        t.Status__c = 'Processed';
                        update t;
                    }
                    else
                    {
                        t.Status__c = 'No Subscription Found';
                        update t;
                    }
                }
                else
                {
                    t.Status__c = 'No Account Found';
                    update t;
                }
            }
       }
}