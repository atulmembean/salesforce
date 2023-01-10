trigger TaskTrigger on Task (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    integer i=0;
    system.debug(Trigger.new);
    TaskTriggerHandler taskTriggerHandlerObj =  new TaskTriggerHandler(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);
    taskTriggerHandlerObj.run();
   if(trigger.isInsert&& trigger.isBefore || trigger.isUpdate && trigger.isBefore){
        TaskTriggerHandler obj=new TaskTriggerHandler();
        obj.taskTypeUpdate(trigger.New);
        TaskTriggerHandler.updateTaskField(Trigger.New);
        List<Task> tlst = New List<Task>();
        for (Task t :Trigger.New)
        {
            if (t.Subject.indexOf('MassMailer') == -1)
                tlst.add(t);    
        }
        if (tlst.Size()>0)
            TaskTriggerHandler.updateLeadStatus(tlst);
    }
    
    
    /**For task types Count : Creation of custom rollup for capture count of child opportunitiessk types of Call ,Email and Task**/
     if (Trigger.isInsert && OpportunityService.runAfterOnce()){
        if(trigger.isAfter){
            TaskTriggerHandler.ChildAccCustomRollup(Trigger.new);
            
           /* Set<id> leadIds = new Set<id>();
            List<Lead> LeadList = new List<Lead>();
            List<Lead> LeadToUpdate = new List<Lead>();
            Set<Id> taskIds = New Set<Id>();
            Set<Id> contactIds =  New Set<Id>();
            Set<Id> contaskIds =  New Set<Id>();
            Set<Id> emailmsgIds =  New Set<Id>();
    
            for (Task item : Trigger.New){
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
            LeadList = [select id,name,Status from Lead where id in:leadIds];
            List<EmailMessage> emsglst = [Select Id,ActivityId,Incoming,FromAddress, ToAddress, FromName, Subject FROM EmailMessage where ActivityId IN :taskIds];
            List<Task> tasklst = [Select Id,whoId,Type FROM Task where Id IN :taskIds];
            List<Lead> leadlst = [Select Id,First_Email_Sent_after_recent_inquiry__c,First_Email_Received_after_recent_inquir__c,Total_Emails_sent_after_recent_inquiry__c,Total_Emails_received_after_recent_inqui__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id in :leadIds];
            List<Lead> leadupdlst = New List<Lead>();
            for (Task t :Trigger.New){
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
        }
        
        
        tasklst = [Select Id,whoId,Type FROM Task where Id IN :contaskIds];
        List<Contact> conlst = [Select Id,First_Email_Received_after_recent_inquir__c,First_Email_Sent_after_recent_inquiry__c,Total_Emails_sent_after_recent_inquiry__c,Total_Emails_received_after_recent_inqui__c,First_Email_Sent_Time__c,Last_Email_Received_Time__c,Last_Email_Sent_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Contact where Id in :contactIds];
        List<Contact> conupdlst = New List<Contact>();
        for (Task t1 :tasklst) {   
        for (Contact l :conlst){
            if (l.Id == t1.whoId){
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
                        
                        break;
                    }
                }
                conupdlst.add(l);
                break;
            }
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
        } */ 
        
        
    }          
    }
    if ((Trigger.isUpdate || Trigger.isDelete) && OpportunityService.runAfterOnce()){
        if(trigger.isAfter){
            TaskTriggerHandler.ChildAccCustomRollup(Trigger.old);
        }
    }
    /**********Ends here*************/
       
}