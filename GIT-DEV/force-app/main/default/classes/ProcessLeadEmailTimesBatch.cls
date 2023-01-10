global class ProcessLeadEmailTimesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Lead where Status = \'Prospecting\' AND isConverted  = FALSE order by CreatedDate DESC LIMIT 20';  
            }
            else{
               query = 'Select id from Lead where Status = \'Prospecting\' AND isConverted  = FALSE';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Lead> scope){

                for(Lead ld :scope){
                    ProcessRecord(ld.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            Date dt = system.Today();
            List<Task> tasklst = new List<Task>();           
            Lead l = [Select Id,Total_Marketing_Emails__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id = :rId];
            if (l != Null)
            {
                tasklst = [Select Id,Subject from task where WhoId = :l.Id AND Type = 'Email' order by CreatedDate ASC];
                if (tasklst.Size() == 0)
                {
                    l.Total_Emails_Received__c = 0;
                    l.Total_Emails_Sent__c = 0;
                    try{
                        update l;
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
                    //List<EmailMessage> emall = [Select Id,Incoming,MessageDate from EmailMessage where ActivityId IN :ids];
                    List<EmailMessage> em = [Select Id,Incoming,MessageDate from EmailMessage where ActivityId IN :ids];
                    List<EmailMessage> eminc = [Select Id,Incoming,MessageDate from EmailMessage where ActivityId IN :ids AND Incoming = TRUE order by CreatedDate ASC];
                    List<EmailMessage> emout = [Select Id,Incoming,MessageDate,Subject from EmailMessage where ActivityId IN :ids AND Incoming = FALSE order by CreatedDate ASC];
                     
                    l.Total_Emails_Received__c = 0;
                    l.Total_Emails_Sent__c = 0;
                    if (em.Size() == 0)
                    {
                        l.Total_Emails_Received__c = 0;
                        l.Total_Emails_Sent__c = 0;
                        try{
                            update l;
                        } catch (Exception e)
                        {
                        
                        }  
                    }
                    else 
                    {
                        if (eminc.Size() > 0)
                        {
                             l.Total_Emails_Received__c = eminc.Size(); 
                             l.Last_Received_Email_Time__c = eminc[eminc.Size()-1].MessageDate;  
                        }
                        if (emout.Size() > 0)
                        {
                             l.Total_Emails_Sent__c = emout.Size();  
                             l.First_Email_Sent_Time__c = emout[0].MessageDate;
                             l.Last_Sent_Email_Time__c = emout[emout.Size()-1].MessageDate;
                             integer count = 0;
                             String sub = '';
                             for (EmailMessage e :emout)
                             {
                                  sub = e.Subject;
                                  if (sub.indexOf('MassMailer') != -1)
                                  {
                                      ++count;
                                  }       
                             }
                             if (count > 0)
                                 l.Total_Marketing_Emails__c = count; 
                        }
                        
                        try{
                            update l;
                        } catch (Exception e)
                        {
                        
                        } 
                    }
                }
                
            }
       }
}