public with sharing class processAccntSchoolCodeChangeInvocable
{
    public class ProcessRequest
    {
        @InvocableVariable(
            label = 'Account Record ID'
            description = 'Account Record ID'
            required = true
        )
        public String accntId;
        
    } 
               
    @InvocableMethod(label='Process Membean Expiry Date')
    public static void processMembeanExpiry(List<ProcessRequest > requests)
    {
        for ( ProcessRequest request : requests )
        {
            ProcessRecord(request);
        }
    }
    
    public static void ProcessRecord(ProcessRequest request)
    {
        String accId = request.accntId;
        if (accId  != Null)
        {
            List<Opportunity> olst = [Select Id,AccountId,Pilot_End_Date__c,Temporary_Membean_Extension_Date__c,Subscription_Processed__c from Opportunity where AccountId = :accId AND StageName = 'Close Won' Order by Subscription_Start_Year__c DESC LIMIT 1];
            if (olst.Size()>0)
            {
                olst[0].Subscription_Processed__c = TRUE;
                update olst[0];
            }
        }
            
    }
}