@isTest
public class UpdateAccountSubscriptionAtEndTest {
    public static testMethod void testdata(){
        Account acc=new Account();
        acc.name='Test';
        acc.Subscription_Status__c='Customer';
        acc.Subscription_Years__c='2016';
        acc.Academic_End_Month__c='july';
        insert acc;
        
        Account acc2=new Account();
        acc2.name='Test';
        acc2.Subscription_Status__c='Customer';
        acc2.Subscription_Years__c='2016';
        acc2.Academic_End_Month__c='December';
        insert acc2;
        UpdateAccountSubscriptionAtEnd updatesub=new UpdateAccountSubscriptionAtEnd();
        Database.executeBatch(updatesub);
        //system.schedule('Test Scheduled batch job for updating expired Account', '0 0 0 31 7 ? 2016-2022', new ScheduleBatchUpdateAccountSubscription());
        //system.debug([Select Id, Subscription_Status__c, Subscription_Years__c, Batch_Academic_month__c from Account]);

    }
}