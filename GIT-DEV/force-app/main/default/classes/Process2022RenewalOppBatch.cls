global class Process2022RenewalOppBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
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
            Temp__c tmp = [Select Opportunity_ID__c, Id,Status__c,Temp__c from Temp__c where Id = :rId];
            Opportunity o = [Select Id,Account.Id from Opportunity where Id = :tmp.Opportunity_ID__c];
            if (o != Null)
            {
                List<Payment__c> p = [Select Id,Create_Renewal_Oppty__c,Invoice__c from Payment__c where Invoice__r.Quote__r.OpportunityId = :tmp.Opportunity_ID__c];
                if (p.Size() > 0)
                {
                    List<Opportunity> olst = [Select Id from Opportunity where Subscription_Start_Year__c > '2022' AND AccountId = :o.Account.Id AND StageName = 'Close Won'];
                    if (olst.Size()>0)
                    {
                        for (opportunity op :olst)
                        {
                            tmp.Temp__c = tmp.Temp__c + ',';
                        }
                        //delete olst;
                    }
                    Invoice__c inv = [Select Id,Renewal_Oppty_Created__c,Quote__c from Invoice__c where Id = :p[0].Invoice__c];
                    inv.Renewal_Oppty_Created__c = FALSE;
                    update inv;
                    Quote qt = [Select Id,Renewal_Oppty_Created__c from Quote where Id = :inv.Quote__c];
                    qt.Renewal_Oppty_Created__c = FALSE;
                    update qt;
                    p[0].Create_Renewal_Oppty__c= TRUE;
                    update p[0];
                }
            }
           tmp.Status__c = 'Processed';
           update tmp;     
       }
}