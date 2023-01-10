global class Process2022RenewalOppPayBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Temp__c where Payment_ID__c != NULL and CreatedDate = TODAY LIMIT 5';  
            }
            else{
               query = 'Select id from Temp__c where Payment_ID__c != NULL and CreatedDate = TODAY';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Temp__c> scope){

                for(Temp__c t:scope){
                    ProcessRecord(t.Id);
                    system.debug('t.Id:::'+t.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            system.debug('rId:::'+rId);
            Temp__c tmp = [Select Payment_Id__c, Id,Status__c from Temp__c where Id = :rId];
            List<Payment__c> p = new List<Payment__c>();
            List<Payment__c> p2021 = new List<Payment__c>();
            p = [Select Id,Temp__c,Invoice__r.Quote__r.Opportunity.Account.Id from Payment__c where Id = :tmp.Payment_Id__c];
            if (p.Size() > 0)
            {
                List<Opportunity> olst = [Select Id from Opportunity where Subscription_Start_Year__c = '2021' AND subscription_End_Year__c = '2022' AND AccountId = :p[0].Invoice__r.Quote__r.Opportunity.Account.Id AND StageName = 'Close Won' LIMIT 1];
                if (olst.Size()>0)
                {
                    p2021 = [Select Id,Temp__c,Invoice__c from Payment__c where Invoice__r.Quote__r.Opportunity.Id = :olst[0].Id];
                    if (p2021.Size() > 0)
                    { 
                        List<Opportunity> renoppty = [Select Id,Account.RecordType.Name from Opportunity where AccountId = :p[0].Invoice__r.Quote__r.Opportunity.Account.Id AND Subscription_Start_Year__c = '2022' AND Subscription_End_Year__c = '2023' LIMIT 1];
                        if (renoppty.Size() == 0)
                        {
                            Invoice__c inv = [Select Id,Renewal_Oppty_Created__c,Quote__c from Invoice__c where Id = :p2021[0].Invoice__c];
                            inv.Renewal_Oppty_Created__c = FALSE;
                            update inv;
                            Quote qt = [Select Id,Renewal_Oppty_Created__c from Quote where Id = :inv.Quote__c];
                            qt.Renewal_Oppty_Created__c = FALSE;
                            update qt;
                            p2021[0].Temp__c = TRUE;
                            update p2021[0];
                        }
                    }
                }
            }
           tmp.Status__c = 'Processed';
           update tmp;     
       }
}