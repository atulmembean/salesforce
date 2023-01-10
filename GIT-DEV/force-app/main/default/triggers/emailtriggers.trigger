trigger emailtriggers on EmailMessage (after insert) {
    Set<Id> taskallIds =  New Set<Id>();
    Set<Id> leadIds =  New Set<Id>();
    Set<Id> taskIds =  New Set<Id>();
    Set<Id> contactIds =  New Set<Id>();
    Set<Id> contaskIds =  New Set<Id>();
    Set<Id> emailmsgIds =  New Set<Id>();
    for (EmailMessage em : trigger.New)
    {
        taskallIds.add(em.ActivityId);
        emailmsgIds.add(em.Id);
    }
    List<Task> tasklstall = [Select Id,WhoId from Task where Id In :taskallIds];
    for (Task item : tasklstall){
        if(item.WhoId != null){
            if(item.WhoId.getSObjectType().getDescribe().getName()=='Lead'){
                leadIds.add(item.whoId);
                taskIds.add(item.Id);
            }
            if(item.WhoId.getSObjectType().getDescribe().getName()=='Contact'){
                contactIds.add(item.whoId);
                contaskIds.add(item.Id);
            }
        }
    }
    
    List<Lead> LeadList = [select id,name,Status from Lead where id in:leadIds];
    List<EmailMessage> emsglst = [Select Id,MessageDate,ActivityId,Incoming,FromAddress, ToAddress, FromName, Subject FROM EmailMessage where Id IN :emailmsgIds];
    List<Task> tasklst = [Select Id,whoId,Type FROM Task where Id IN :taskIds];
    List<Lead> leadlst = [Select Id,First_Email_Sent_after_recent_inquiry__c,First_Email_Received_after_recent_inquir__c,Total_Emails_sent_after_recent_inquiry__c,Total_Emails_received_after_recent_inqui__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id in :leadIds];
    List<Lead> leadupdlst = New List<Lead>();
    for (Task t :tasklstall){
    for (Lead l :leadlst){
        if (l.Id == t.whoId){
            for (EmailMessage em :emsglst){
                if (em.ActivityId == t.Id){
                    if (em.Incoming == TRUE){
                        l.Last_Received_Email_Time__c = em.MessageDate;
                        if (l.Total_Emails_Received__c == Null)
                            l.Total_Emails_Received__c = 1;
                        else
                            l.Total_Emails_Received__c = l.Total_Emails_Received__c+1;
                        
                        if (l.First_Email_Received_after_recent_inquir__c == Null)
                            l.First_Email_Received_after_recent_inquir__c = em.MessageDate;
                        if (l.Total_Emails_received_after_recent_inqui__c == Null)
                            l.Total_Emails_received_after_recent_inqui__c = 1;
                        else
                            l.Total_Emails_received_after_recent_inqui__c = l.Total_Emails_received_after_recent_inqui__c + 1;
                    }
                    else
                    {
                        l.Last_Sent_Email_Time__c = em.MessageDate;
                        if (l.Total_Emails_Sent__c == Null)
                        {
                            l.Total_Emails_Sent__c = 1;
                           
                        }
                        else
                        {
                            l.Total_Emails_Sent__c = l.Total_Emails_Sent__c+1;
                            
                        }
                        if (l.First_Email_Sent_Time__c == Null)
                            l.First_Email_Sent_Time__c = em.MessageDate;
                        if (l.First_Email_Sent_after_recent_inquiry__c == Null)
                        {
                            l.First_Email_Sent_after_recent_inquiry__c = em.MessageDate;
                        }
                        if (l.Total_Emails_sent_after_recent_inquiry__c == Null)
                            l.Total_Emails_sent_after_recent_inquiry__c = 1;
                        else
                            l.Total_Emails_sent_after_recent_inquiry__c = l.Total_Emails_sent_after_recent_inquiry__c + 1;
                    }
                    break;
                }
            }
            leadupdlst.add(l);
            break;
        }
    } 
    if (leadupdlst.size()>0)
    {
        try{
            update leadupdlst;
        }
        catch(Exception e){
            system.debug('Exception is'+e);
            system.debug('Exception mess'+e.getMessage());
            system.debug('Exception line'+e.getLineNumber());
        }
    }
    
    //List<Contact> contactList = [select id,name,Status from Contact where id in :contactIds];
    //List<EmailMessage> emsglst = [Select Id,MessageDate,ActivityId,Incoming,FromAddress, ToAddress, FromName, Subject FROM EmailMessage where Id IN :emailmsgIds];
    tasklst = [Select Id,whoId,Type FROM Task where Id IN :contaskIds];
    List<Contact> conlst = [Select Id,First_Email_Received_after_recent_inquir__c,First_Email_Sent_after_recent_inquiry__c,Total_Emails_sent_after_recent_inquiry__c,Total_Emails_received_after_recent_inqui__c,First_Email_Sent_Time__c,Last_Email_Received_Time__c,Last_Email_Sent_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Contact where Id in :contactIds];
    List<Contact> conupdlst = New List<Contact>();
    for (Task t1 :tasklstall)    {
    for (Contact l :conlst){
        if (l.Id == t.whoId){
            for (EmailMessage em :emsglst){
                if (em.ActivityId == t1.Id){
                    if (em.Incoming == TRUE){
                        l.Last_Email_Received_Time__c = em.MessageDate;
                        if (l.Total_Emails_Received__c == Null)
                            l.Total_Emails_Received__c = 1;
                        else
                            l.Total_Emails_Received__c = l.Total_Emails_Received__c+1;
                        if (l.First_Email_Received_after_recent_inquir__c == Null)
                            l.First_Email_Received_after_recent_inquir__c = em.MessageDate;
                        if (l.Total_Emails_received_after_recent_inqui__c == Null)
                            l.Total_Emails_received_after_recent_inqui__c = 1;
                        else
                            l.Total_Emails_received_after_recent_inqui__c = l.Total_Emails_received_after_recent_inqui__c + 1;
                    }
                    else
                    {
                        l.Last_Email_Sent_Time__c = em.MessageDate;
                        if (l.Total_Emails_Sent__c == Null)
                            l.Total_Emails_Sent__c = 1;
                        else
                            l.Total_Emails_Sent__c = l.Total_Emails_Sent__c+1;
                        if (l.First_Email_Sent_Time__c == Null)
                            l.First_Email_Sent_Time__c = em.MessageDate;
                        if (l.First_Email_Sent_after_recent_inquiry__c == Null)
                            l.First_Email_Sent_after_recent_inquiry__c = em.MessageDate;
                        if (l.Total_Emails_sent_after_recent_inquiry__c == Null)
                            l.Total_Emails_sent_after_recent_inquiry__c = 1;
                        else
                            l.Total_Emails_sent_after_recent_inquiry__c = l.Total_Emails_sent_after_recent_inquiry__c + 1;
                    }
                    break;
                }
            }
            conupdlst.add(l);
            break;
        }
    } 
    if (conupdlst.size()>0)
    {
        try{
            update conupdlst;
        }
        catch(Exception e){
            system.debug('Exception is'+e);
            system.debug('Exception mess'+e.getMessage());
            system.debug('Exception line'+e.getLineNumber());
        }
    }       
    }
}
}