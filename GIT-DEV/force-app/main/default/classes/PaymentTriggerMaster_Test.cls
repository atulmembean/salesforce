@isTest(SeeAllData=TRUE)
public class PaymentTriggerMaster_Test{
public static testmethod void deletepay()
{
    Test.startTest();
    Payment__c p = [Select Id from Payment__c LIMIT 1];
    delete p;
    Test.stopTest();
}
}