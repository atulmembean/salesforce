@isTest(SeeAllData=TRUE)
public class ProcessSubscriptionStatusOnAccountTest {
    public static List<Account> lstAcc = new List<Account>();
    static testMethod void setup(){
        for (integer i=0;i<1;i++){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.Subscription_Status__c = 'Customer';
            acc.Subscription_Expiry_Month__c = 'September';
            //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('District').getRecordTypeId();
            acc.Subscription_Expiry_Date1__c = Date.newInstance(2020, 09, 30);
            acc.Membership_Expires_On__c = Date.newInstance(2020, 09, 16);
            acc.Membean_Expires_On__c = Date.newInstance(2020, 09, 16);
            lstAcc.add(acc);
        }
            insert lstAcc;
        Test.startTest();
        ProcessSubscriptionStatusOnAccount obj = New ProcessSubscriptionStatusOnAccount();
        ProcessSubscriptionStatusOnAccount.execute(null);
        Test.stopTest();
            
        }
}