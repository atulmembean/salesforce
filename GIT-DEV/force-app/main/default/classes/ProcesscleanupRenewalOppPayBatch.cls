global class ProcesscleanupRenewalOppPayBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Temp__c where Opportunity_ID__c != NULL and CreatedDate = TODAY LIMIT 5';  
            }
            else{
               query = 'Select id from Temp__c where Opportunity_ID__c != NULL and CreatedDate = TODAY';
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
            Temp__c tmp = [Select Temp__c,Opportunity_ID__c,Id,Status__c from Temp__c where Id = :rId];
            List<Payment__c> p = new List<Payment__c>();
            List<Payment__c> p2021 = new List<Payment__c>();
            Opportunity op = [Select Id,X18_Digit_ID__c from Opportunity where Id = :tmp.Opportunity_ID__c];
            p = [Select Id,Create_Renewal_Oppty__c,Invoice__r.Quote__r.Opportunity.Account.X18_Digit_ID__c from Payment__c where Invoice__r.Quote__r.OpportunityId = :op.X18_Digit_ID__c LIMIT 1];
            if (p.Size() > 0)
            {
                List<Opportunity> olst = [Select Id,X18_Digit_ID__c from Opportunity where Subscription_Start_Year__c > '2022' AND AccountId = :p[0].Invoice__r.Quote__r.Opportunity.Account.X18_Digit_ID__c];
                if (olst.Size()>0)
                {
                    for (Opportunity o :olst)
                    {
                        //tmp.Temp__c= tmp.Temp__c + o.X18_Digit_ID__c + ', ' ;
                    }
                    
                    delete olst;
                    Invoice__c inv = [Select Id,Renewal_Oppty_Created__c,Quote__c from Invoice__c where Id = :p[0].Invoice__c];
                    inv.Renewal_Oppty_Created__c = FALSE;
                    update inv;
                    Quote qt = [Select Id,Renewal_Oppty_Created__c from Quote where Id = :inv.Quote__c];
                    qt.Renewal_Oppty_Created__c = FALSE;
                    update qt;
                    p[0].Create_Renewal_Oppty__c = TRUE;
                    update p[0];
                     
                }
            }
           tmp.Status__c = 'Processed';
           update tmp;     
       }
}