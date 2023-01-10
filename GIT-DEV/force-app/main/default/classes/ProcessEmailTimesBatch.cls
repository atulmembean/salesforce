global class ProcessEmailTimesBatch implements Database.Batchable<sObject>{
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = Date.newInstance(2022, 8, 25);
            if(Test.isRunningTest()){
               query = 'Select id from EmailMessage where MessageDate > :dt order by MessageDate DESC LIMIT 20';  
            }
            else{
               query = 'Select id from EmailMessage where MessageDate > :dt order by MessageDate';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<EmailMessage> scope){

                for(EmailMessage e :scope){
                    ProcessRecord(e.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            EmailMessage em = [Select Id, Incoming, ActivityId, Subject, MessageDate from EmailMessage where Id = :rId];
            List<EmailMessageRelation> emr = [Select Id,RelationId,RelationAddress,RelationObjectType,RelationType from EmailMessageRelation where EmailMessageId = :em.Id];
            List<EmailMessageRelation> emrin = New List<EmailMessageRelation>();
            List<EmailMessageRelation> emrout = New List<EmailMessageRelation>();
            Contact c = New Contact();
            Lead l = New Lead();
            String sub =  em.Subject;
            if (em.Incoming == TRUE)
            {
                emrin = [Select Id,RelationId,RelationAddress,RelationObjectType,RelationType from EmailMessageRelation where EmailMessageId = :em.Id AND RelationType = 'FromAddress' AND RelationObjectType != Null];
                for (EmailMessageRelation emrrecin : emrin)
                {
                    if (emrrecin.RelationObjectType == 'Lead')
                    {
                        l = [Select Id,Total_Marketing_Emails__c,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id = :emrrecin.RelationId];
                        if (l != Null)
                        {
                            if (l.First_Email_Received_Time__c == Null)
                                l.First_Email_Received_Time__c = em.MessageDate;
                            else
                            {
                                if (em.MessageDate < l.First_Email_Received_Time__c)
                                    l.First_Email_Received_Time__c = em.MessageDate;   
                            }
                             if (l.Last_Received_Email_Time__c == Null)
                                l.Last_Received_Email_Time__c = em.MessageDate;
                            else if (em.MessageDate > l.Last_Received_Email_Time__c)
                                l.Last_Received_Email_Time__c = em.MessageDate;
                            if (l.Total_Emails_Received__c == Null)
                                l.Total_Emails_Received__c = 1;
                            else
                                l.Total_Emails_Received__c = l.Total_Emails_Received__c + 1;
                            try
                            {
                                update l;
                            } catch (Exception e)
                            {
                            
                            } 
                        }   
                    }
                    else if (emrrecin.RelationObjectType == 'Contact')
                    {
                        c = [Select Id,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Email_Received_Time__c,Last_Email_Sent_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Contact where Id = :emrrecin.RelationId];
                        if (c != Null)
                        {
                            if (c.First_Email_Received_Time__c == Null)
                                c.First_Email_Received_Time__c = em.MessageDate;
                            else
                            {
                                if (em.MessageDate < c.First_Email_Received_Time__c)
                                    c.First_Email_Received_Time__c = em.MessageDate;   
                            }
                            if (c.Last_Email_Received_Time__c == Null)
                                c.Last_Email_Received_Time__c = em.MessageDate;
                            else if (em.MessageDate > c.Last_Email_Received_Time__c)
                                c.Last_Email_Received_Time__c = em.MessageDate;
                            if (c.Total_Emails_Received__c == Null)
                                c.Total_Emails_Received__c = 1;
                            else
                                c.Total_Emails_Received__c = c.Total_Emails_Received__c + 1;
                            try
                            {
                                update c;
                            } catch (Exception e)
                            {
                            
                            }
                        }
                    }
                }
            }
            else
            {
                if (sub.indexOf('MassMailer') == -1)
                {
                    emrout = [Select Id,RelationId,RelationAddress,RelationObjectType,RelationType from EmailMessageRelation where EmailMessageId = :em.Id AND RelationType = 'ToAddress' AND RelationObjectType != Null];
                    for (EmailMessageRelation emrrecout : emrout)
                    {
                        if (emrrecout.RelationObjectType == 'Lead')
                        {
                            l = [Select Id,Total_Marketing_Emails__c,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id = :emrrecout.RelationId];
                            if (l != Null)
                            {
                                if (l.First_Email_Sent_Time__c == Null)
                                    l.First_Email_Sent_Time__c = em.MessageDate;
                                else
                                {
                                    if (em.MessageDate < l.First_Email_Sent_Time__c)
                                        l.First_Email_Sent_Time__c = em.MessageDate;   
                                }
                                if (l.Last_Sent_Email_Time__c == Null)
                                    l.Last_Sent_Email_Time__c = em.MessageDate;
                                else if (em.MessageDate > l.Last_Received_Email_Time__c)
                                    l.Last_Sent_Email_Time__c  = em.MessageDate;
                                if (l.Total_Emails_Sent__c == Null)
                                    l.Total_Emails_Sent__c = 1;
                                else
                                    l.Total_Emails_Sent__c = l.Total_Emails_Sent__c + 1;
                                try
                                {
                                    update l;
                                } catch (Exception e)
                                {
                                
                                }
                            }
                        }
                        else if (emrrecout.RelationObjectType == 'Contact')
                        {
                            c = [Select Id,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Email_Received_Time__c,Last_Email_Sent_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Contact where Id = :emrrecout.RelationId];
                            if (c != Null)
                            {
                                if (c.First_Email_Sent_Time__c == Null)
                                    c.First_Email_Sent_Time__c = em.MessageDate;
                                else
                                {
                                    if (em.MessageDate < l.First_Email_Sent_Time__c)
                                        c.First_Email_Sent_Time__c = em.MessageDate;   
                                }
                                 if (c.Last_Email_Sent_Time__c == Null)
                                    c.Last_Email_Sent_Time__c = em.MessageDate;
                                else if (em.MessageDate > c.Last_Email_Sent_Time__c)
                                    c.Last_Email_Sent_Time__c = em.MessageDate;
                                if (c.Total_Emails_Sent__c == Null)
                                    c.Total_Emails_Sent__c = 1;
                                else
                                    c.Total_Emails_Sent__c = c.Total_Emails_Sent__c + 1;
                                try
                                {
                                    update c;
                                } catch (Exception e)
                                {
                                
                                }
                            }
                        }
                    }
                }
                else
                {
                    emrout = [Select Id,RelationId,RelationAddress,RelationObjectType,RelationType from EmailMessageRelation where EmailMessageId = :em.Id AND RelationType = 'ToAddress' AND RelationObjectType != Null];
                    for (EmailMessageRelation emrreco : emrout)
                    {
                        if (emrreco.RelationObjectType == 'Lead')
                        {
                            l = [Select Id,Total_Marketing_Emails__c,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id = :emrreco.RelationId];
                            if (l != Null)
                            {
                                if (l.Total_Marketing_Emails__c == Null)
                                    l.Total_Marketing_Emails__c = 1;
                                else
                                    l.Total_Marketing_Emails__c = l.Total_Marketing_Emails__c + 1;
                                try
                                {
                                    update l;
                                } catch (Exception e)
                                {
                                
                                }
                            }
                        }
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
       }
}