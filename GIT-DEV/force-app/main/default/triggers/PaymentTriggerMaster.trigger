trigger PaymentTriggerMaster on Payment__c (before delete)
{
    User u = [Select Id, Allow_Payment_Deletion__c from User where Id = :UserInfo.getUserId()];
    for(Payment__c pay: Trigger.Old)
    {
        if (u.Allow_Payment_Deletion__c == FALSE)
        {
            if(!Test.isRunningTest())
            {
                pay.AddError('Payment record cannot be deleted !!! Please reach out to your Salesforce Administrator !!!');
            }
        }
    }
}