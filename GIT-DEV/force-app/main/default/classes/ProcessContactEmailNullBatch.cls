global class ProcessContactEmailNullBatch implements Database.Batchable<sObject>{
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = System.Today();
            dt = dt.addDays(-1);
            Date dttest = Date.newInstance(2022, 8, 25);
            if(Test.isRunningTest()){
               query = 'Select id from Contact where Total_Events_Conducted__c != Null OR Total_Emails_Received__c != Null OR Total_Emails_Sent__c != Null or Last_Email_Sent_Time__c != Null OR Last_Email_Received_Time__c != Null LIMIT 20';  
            }
            else{
               query = 'Select id from Contact where Total_Events_Conducted__c != Null OR Total_Emails_Received__c != Null OR Total_Emails_Sent__c != Null OR Last_Email_Sent_Time__c != Null OR Last_Email_Received_Time__c != Null';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Contact> scope){

                for(Contact e :scope){
                    ProcessRecord(e.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
           Contact l = [Select Id,Total_Events_Conducted__c,First_Email_Received_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c,First_Email_Received_after_recent_inquir__c,Total_Emails_received_after_recent_inqui__c,First_Email_Sent_after_recent_inquiry__c,Total_Emails_sent_after_recent_inquiry__c,Last_Email_Sent_Time__c,Last_Email_Received_Time__c from Contact where Id = :rId];
           if (l != Null)
           {
               l.Total_Events_Conducted__c = Null;
               l.First_Email_Received_Time__c = Null;
               l.Total_Emails_Received__c = Null;
               l.Total_Emails_Sent__c = Null;
               l.First_Email_Received_after_recent_inquir__c = Null;
               l.Total_Emails_received_after_recent_inqui__c = Null;
               l.First_Email_Sent_after_recent_inquiry__c = Null;
               l.Total_Emails_sent_after_recent_inquiry__c = Null;
               l.Last_Email_Sent_Time__c= Null;
               l.Last_Email_Received_Time__c= Null;
               update l;
           }
       }
}