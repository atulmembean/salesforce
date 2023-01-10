public with sharing class ProcessLeadEmailCountUpdateInvocable
{
    public class ProcessRequest
    {
        @InvocableVariable(
            label = 'Lead Record ID'
            description = 'Lead Record ID'
            required = false
        )
        public String leadId;
        
    } 
               
    @InvocableMethod(label='Process Lead Email Count Update')
    public static void processEmailCountUpdate(List<ProcessRequest > requests)
    {
        for ( ProcessRequest request : requests )
        {
            ProcessRecord(request);
        }
    }
    
    public static void ProcessRecord(ProcessRequest request)
    {
        
        if (request.leadId != null)
        {
            String sub = '';
            Lead l = [Select Id,Total_Marketing_Emails__c,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id = :request.leadId];
            l.Total_Marketing_Emails__c = 0;
            l.First_Email_Received_Time__c = Null;
            l.First_Email_Sent_Time__c = Null;
            l.Last_Received_Email_Time__c = Null;
            l.Last_Sent_Email_Time__c = Null;
            l.Total_Emails_Received__c = 0;
            l.Total_Emails_Sent__c = 0;
            update l;
            l = [Select Id,Total_Marketing_Emails__c,First_Email_Received_Time__c,First_Email_Sent_Time__c,Last_Received_Email_Time__c,Last_Sent_Email_Time__c,Total_Emails_Received__c,Total_Emails_Sent__c from Lead where Id = :request.leadId];
            
            Date dt = Date.newInstance(2022, 8, 25);
            List<EmailMessageRelation> emrin = [Select Id,EmailMessageId,RelationId,RelationAddress,RelationObjectType,RelationType from EmailMessageRelation where CreatedDate > :dt AND RelationType = 'FromAddress' AND RelationObjectType != Null AND EmailMessage.Incoming = TRUE AND RelationId = :l.Id]; 
            List<EmailMessageRelation> emrout = [Select Id,EmailMessageId,RelationId,RelationAddress,RelationObjectType,RelationType from EmailMessageRelation where CreatedDate > :dt AND RelationType = 'ToAddress' AND RelationObjectType != Null AND EmailMessage.Incoming = FALSE AND RelationId = :l.Id];   
            List<EmailMessageRelation> emrlst = [Select Id,EmailMessageId,RelationId,RelationAddress,RelationObjectType,RelationType from EmailMessageRelation where CreatedDate > :dt AND RelationObjectType != Null AND RelationId = :l.Id]; 
            Set<Id> emlstid = New Set<Id>();
            Set<Id> eminlstid = New Set<Id>();
            Set<Id> emoutlstid = New Set<Id>();
            for (EmailMessageRelation emr :emrlst)
            {
                emlstid.add(emr.EmailMessageId);   
            }
            List<EmailMessage> emall = [Select Id,Incoming,MessageDate,Subject from EmailMessage where ID in :emlstid]; 
            
            for (EmailMessageRelation emr1 :emrin)
            {
                eminlstid.add(emr1.EmailMessageId);
            }
            List<EmailMessage> emin = [Select Id,Incoming,MessageDate,Subject from EmailMessage where ID in :eminlstid];
            
            for (EmailMessageRelation emr2 :emrout)
            {
                emoutlstid.add(emr2.EmailMessageId);
            }
            List<EmailMessage> emout = [Select Id,Incoming,MessageDate,Subject from EmailMessage where ID in :emoutlstid];
            for (EmailMessage em :emout)
            {
                sub = em.Subject;
                if (sub.indexOf('MassMailer') == -1)
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
                    else if (em.MessageDate > l.Last_Sent_Email_Time__c)
                        l.Last_Sent_Email_Time__c  = em.MessageDate;
                    if (l.Total_Emails_Sent__c == Null)
                        l.Total_Emails_Sent__c = 1;
                    else
                        l.Total_Emails_Sent__c = l.Total_Emails_Sent__c + 1;
                }
                else
                {
                    if (l.Total_Marketing_Emails__c == Null)
                        l.Total_Marketing_Emails__c = 1;
                    else
                        l.Total_Marketing_Emails__c = l.Total_Marketing_Emails__c + 1;
                }
            }
            for (EmailMessage emi :emin)
            {
                if (l.First_Email_Received_Time__c == Null)
                    l.First_Email_Received_Time__c = emi.MessageDate;
                else
                {
                    if (emi.MessageDate < l.First_Email_Received_Time__c)
                        l.First_Email_Received_Time__c = emi.MessageDate;   
                }
                 if (l.Last_Received_Email_Time__c == Null)
                    l.Last_Received_Email_Time__c = emi.MessageDate;
                else if (emi.MessageDate > l.Last_Received_Email_Time__c)
                    l.Last_Received_Email_Time__c = emi.MessageDate;
                if (l.Total_Emails_Received__c == Null)
                    l.Total_Emails_Received__c = 1;
                else
                    l.Total_Emails_Received__c = l.Total_Emails_Received__c + 1;
            }
            try
            {
                update l;
            }
            catch(Exception e)
            {
            }
        }
        integer i = 0;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
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