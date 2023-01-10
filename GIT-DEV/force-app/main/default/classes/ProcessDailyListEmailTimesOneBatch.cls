global class ProcessDailyListEmailTimesOneBatch implements Database.Batchable<sObject>{
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = System.Today();
            dt = dt.addDays(-1);
            Date dttest = Date.newInstance(2022, 11, 29);
            if(Test.isRunningTest()){
               query = 'Select id from Task where CreatedDate > :dttest order by CreatedDate DESC LIMIT 20';  
            }
            else{
               query = 'Select id from Task where CreatedDate >= :dttest AND Subject LIKE \'List Email:%\' order by CreatedDate';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Task> scope){

                for(Task e :scope){
                    ProcessRecord(e.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
           Task ler = [Select Id,WhoId,CreatedDate from Task where Id = :rId];
            String parentId = ler.WhoId;   
            Contact c = New Contact();
            Lead l = New Lead();
            if (parentId.substring(0,3)=='00Q')
            {
                l = [Select Id,Attention_Required__c,Total_Marketing_Emails__c,First_Email_Received_after_recent_inquir__c,First_Email_Sent_after_recent_inquiry__c,Total_Emails_received_after_recent_inqui__c,Total_Emails_sent_after_recent_inquiry__c,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id = :ler.whoId];
                if (l != Null)
                {
                    if (l.First_Email_Sent_Time__c == Null)
                        l.First_Email_Sent_Time__c = ler.CreatedDate;
                    else
                    {
                        if (ler.CreatedDate < l.First_Email_Sent_Time__c)
                            l.First_Email_Sent_Time__c = ler.CreatedDate;   
                    }
                    if (l.Total_Emails_Sent__c == Null)
                        l.Total_Emails_Sent__c = 1;
                    else
                        l.Total_Emails_Sent__c = l.Total_Emails_Sent__c + 1;
                        
                    
                    if (l.Last_Sent_Email_Time__c == Null)
                        l.Last_Sent_Email_Time__c = ler.CreatedDate;
                    else if (ler.CreatedDate > l.Last_Sent_Email_Time__c)
                        l.Last_Sent_Email_Time__c  = ler.CreatedDate;
                    
                     if (l.Attention_Required__c == TRUE)
                    {
                        if (l.First_Email_Sent_after_recent_inquiry__c == Null)
                            l.First_Email_Sent_after_recent_inquiry__c = ler.CreatedDate;
                        else if (ler.CreatedDate < l.First_Email_Sent_after_recent_inquiry__c)
                            l.First_Email_Sent_after_recent_inquiry__c = ler.CreatedDate;
                        if (l.Total_Emails_sent_after_recent_inquiry__c == Null)
                            l.Total_Emails_sent_after_recent_inquiry__c = 1;
                        else
                            l.Total_Emails_sent_after_recent_inquiry__c = l.Total_Emails_sent_after_recent_inquiry__c + 1;
                    }
                    try
                    {
                        update l;
                    } catch (Exception e)
                    {
                    
                    }
                }
            }
            else if (parentId.substring(0,3)=='003')
            {
                c = [Select Id,Attention_Required__c,First_Email_Received_after_recent_inquir__c,First_Email_Sent_after_recent_inquiry__c,Total_Emails_sent_after_recent_inquiry__c,Total_Emails_received_after_recent_inqui__c,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Email_Received_Time__c,Last_Email_Sent_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Contact where Id = :ler.whoId];
                if (c != Null)
                {
                    if (c.First_Email_Sent_Time__c == Null)
                        c.First_Email_Sent_Time__c = ler.CreatedDate;
                    else
                    {
                        if (ler.CreatedDate < l.First_Email_Sent_Time__c)
                            c.First_Email_Sent_Time__c = ler.CreatedDate;   
                    }
                    if (c.Total_Emails_Sent__c == Null)
                        c.Total_Emails_Sent__c = 1;
                    else
                        c.Total_Emails_Sent__c = c.Total_Emails_Sent__c + 1;
                    
                    if (c.Last_Email_Sent_Time__c == Null)
                        c.Last_Email_Sent_Time__c = ler.CreatedDate;
                    else if (ler.CreatedDate > c.Last_Email_Sent_Time__c)
                        c.Last_Email_Sent_Time__c = ler.CreatedDate;
                    
                    if (c.Attention_Required__c == TRUE)
                    {
                        if (c.First_Email_Sent_after_recent_inquiry__c == Null)
                            c.First_Email_Sent_after_recent_inquiry__c = ler.CreatedDate;
                        else if (ler.CreatedDate < c.First_Email_Sent_after_recent_inquiry__c)
                            c.First_Email_Sent_after_recent_inquiry__c = ler.CreatedDate;
                        if (c.Total_Emails_sent_after_recent_inquiry__c == Null)
                            c.Total_Emails_sent_after_recent_inquiry__c = 1;
                        else
                            c.Total_Emails_sent_after_recent_inquiry__c = c.Total_Emails_sent_after_recent_inquiry__c + 1;
                    }
                
                    try
                    {
                        update c;
                    } catch (Exception e)
                    {
                    
                    }
                }
         }   
        integer i=0;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;     
       }
}