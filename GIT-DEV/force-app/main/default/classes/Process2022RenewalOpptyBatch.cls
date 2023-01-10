global class Process2022RenewalOpptyBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Payment__c where Payment_Date__c = THIS_YEAR AND Temp__c = FALSE LIMIT 10';  
            }
            else{
               query = 'Select id from Payment__c where Payment_Date__c = THIS_YEAR AND Temp__c = FALSE AND Invoice__r.Quote__r.Opportunity.Account.RecordType.Name != \'Tutoring\'';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Payment__c> scope){

                for(Payment__c pay:scope){
                    ProcessRecord(pay.Id);
                    system.debug('pay.Id:::'+pay.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            system.debug('rId:::'+rId);
            List<Payment__c> p = new List<Payment__c>();
            p = [Select Id from Payment__c where Id = :rId];        
            Payment__c pmnt = [Select Id,Temp__c,Invoice__r.Quote__r.Opportunity.Account.Id from Payment__c where Id = :rId];
            if (pmnt != Null && pmnt.Invoice__r.Quote__r.Opportunity.Account.Id != NULL)
            {
                List<Opportunity> renoppty = [Select Id,Account.RecordType.Name from Opportunity where AccountId = :pmnt.Invoice__r.Quote__r.Opportunity.Account.Id AND Subscription_Start_Year__c = '2022' AND Subscription_End_Year__c = '2023' LIMIT 1];
                if (renoppty.Size()>0)
                {
                    //delete and create new one
                    List<Temp__c> tmp = [Select Id, Opportunity_Id__c from Temp__c where Opportunity_ID__c != Null];
                    String flg = 'N';
                    for (Temp__c t :tmp)
                    {
                        if (renoppty[0].Id == t.Opportunity_Id__c)
                        {
                            flg = 'Y';
                            break;
                        }
                    }
                    if (flg == 'N')
                    {
                        if (renoppty[0].Account.RecordType.Name == 'District')
                        {
                            List<Opportunity> childoppty = [Select Id,Parent_Opportunity__c from Opportunity where Parent_Opportunity__c = :renoppty[0].Id AND Subscription_Start_Year__c = '2022' AND Subscription_End_Year__c = '2023'];
                            if (childoppty.Size()>0)
                                delete childoppty;
                            delete renoppty[0];
                        }
                        else
                        {
                            delete renoppty[0];
                        }    
                    }
                }
                // create new renewal oppty from payment
                //pmnt.Temp__c = TRUE;
                //update pmnt;
            }
            
       }
}