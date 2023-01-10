global class ProcessMassMailerVeriBatchOnetime implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Cloudrop__MassMailer_Email_Verify_Status__c order by LastModifiedDate DESC LIMIT 1';  
            }
            else{
               query = 'Select id from Cloudrop__MassMailer_Email_Verify_Status__c where Processed__c = FALSE LIMIT 49500';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Cloudrop__MassMailer_Email_Verify_Status__c> scope){

                for(Cloudrop__MassMailer_Email_Verify_Status__c ver :scope){
                    ProcessRecord(ver.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            Cloudrop__MassMailer_Email_Verify_Status__c veri = [Select Id,Processed__c,CreatedDate,Cloudrop__Contact__c,Cloudrop__Lead__c,Cloudrop__Status__c from Cloudrop__MassMailer_Email_Verify_Status__c where Id = :rId];
            if (veri != Null)
            {
                DateTime dT = veri.CreatedDate;
                Date d = date.newinstance(dT.year(), dT.month(), dT.day());
                if (veri.Cloudrop__Lead__c != Null)
                {
                    Lead l = [Select Id,Last_Verified_Date__c,Verification_Status__c from Lead where Id = :veri.Cloudrop__Lead__c AND isConverted = FALSE];
                    If (l != Null)
                    {
                        l.Last_Verified_Date__c = d;
                        l.Verification_Status__c = veri.Cloudrop__Status__c;
                        update l;
                    }
                }
                if (veri.Cloudrop__Contact__c != Null)
                {
                    Contact c = [Select Id,Last_Verified_Date__c,Verification_Status__c from Contact where Id = :veri.Cloudrop__Contact__c];
                    If (c != Null)
                    {
                        c.Last_Verified_Date__c = d;
                        c.Verification_Status__c = veri.Cloudrop__Status__c;
                        update c;
                    }
                }
                veri.Processed__c = TRUE;
                update veri;
             }  
         }
       
}