@isTest(SEEALLDATA=TRUE)
public class processAccntSchoolCodeChangeInv_Test
{
    static testMethod void TestMethodOne()
    {
        Opportunity o = [Select Id, AccountID from Opportunity where StageName = 'Close Won' AND Account.School_ID__c != Null ORDER by CreatedDate DESC LIMIT 1];
        Account a = [Select Id,School_ID__c from Account where Id = :o.AccountId];
        processAccntSchoolCodeChangeInvocable.ProcessRequest request = new processAccntSchoolCodeChangeInvocable.ProcessRequest();
        request.accntId = a.Id;
        Test.startTest();
        List<processAccntSchoolCodeChangeInvocable.ProcessRequest> requests = New List<processAccntSchoolCodeChangeInvocable.ProcessRequest>();
        requests.add(request);
        //processAccntSchoolCodeChangeInvocable.ProcessRecord(requests);
        processAccntSchoolCodeChangeInvocable.processMembeanExpiry(requests);
        Test.stopTest();
          
    }
}