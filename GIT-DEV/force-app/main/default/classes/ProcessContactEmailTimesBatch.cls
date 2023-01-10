global class ProcessContactEmailTimesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date d = Date.newInstance(2022, 8, 25);
            
            if(Test.isRunningTest()){
               query = 'Select Id from task where Type = \'Email\' AND CreatedDate > :d AND WhoId != Null order by CreatedDate ASC LIMIT 20';  
            }
            else{
               query = 'Select Id from task where Type = \'Email\' AND CreatedDate > :d AND WhoId != Null order by CreatedDate ASC';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<task> scope){

                for(task t :scope){
                    ProcessRecord(t.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            Date dt = Date.newInstance(2022, 8, 25);
            Task t1= [Select Id, WhoId from Task where Id = :rId];
            String chr = t1.WhoId;
            chr = chr.left(3);
            if (t1 != Null && chr == '003')
            {
                List<Task> tasklst = new List<Task>();           
                Contact c = [Select Id,First_Email_Sent_Time__c,Last_Email_Received_Time__c,Last_Email_Sent_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Contact where Id = :t1.WhoId];
                if (c != Null)
                {
                    tasklst = [Select Id from task where WhoId = :t1.WhoId AND Type = 'Email' AND CreatedDate > :dt order by CreatedDate ASC];
                    if (tasklst.Size() == 0)
                    {
                        c.Total_Emails_Received__c = 0;
                        c.Total_Emails_Sent__c = 0;
                        try{
                            update c;
                        } catch (Exception e)
                        {
                        
                        } 
                    }
                    else
                    {
                        Set<Id> ids =  New Set<Id>();
                        for (Task t : tasklst)
                        {
                            ids.add(t.Id);
                        }
                        List<EmailMessage> em = [Select Id,Incoming,MessageDate from EmailMessage where ActivityId IN :ids];
                        List<EmailMessage> eminc = [Select Id,Incoming,MessageDate from EmailMessage where ActivityId IN :ids AND Incoming = TRUE order by CreatedDate ASC];
                        List<EmailMessage> emout = [Select Id,Incoming,MessageDate from EmailMessage where ActivityId IN :ids AND Incoming = FALSE order by CreatedDate ASC];
                        c.Total_Emails_Received__c = 0;
                        c.Total_Emails_Sent__c = 0;
                        if (em.Size() == 0)
                        {
                            c.Total_Emails_Received__c = 0;
                            c.Total_Emails_Sent__c = 0;
                            try{
                                update c;
                            } catch (Exception e)
                            {
                            
                            }  
                        }
                        else 
                        {
                            if (eminc.Size() > 0)
                            {
                                 c.Total_Emails_Received__c = eminc.Size(); 
                                 c.Last_Email_Received_Time__c = eminc[eminc.Size()-1].MessageDate;  
                            }
                            if (emout.Size() > 0)
                            {
                                 c.Total_Emails_Sent__c = emout.Size();  
                                 c.First_Email_Sent_Time__c = emout[0].MessageDate;
                                 c.Last_Email_Sent_Time__c = emout[emout.Size()-1].MessageDate;
                            }
                            
                            try{
                                update c;
                            } catch (Exception e)
                            {
                            
                            } 
                        }
                    }
                    
                }
            }
       }
}