public class TestClassUtility {
    public static Account createAccount(String objName, Id recordTypeId) {
        Account obj = new Account();
        obj.Name = objName;
        obj.RecordTypeId = recordTypeId;
        obj.Academic_End_Month__c='July';
        return obj;
    }
    
    public static Opportunity createOpportunity(String objName, Id accId, String stageName, String subStartYear, String subEndYear) {
        Opportunity obj = new Opportunity();
        obj.Name = objName;
        obj.AccountId = accId;
        obj.StageName = stageName;
        obj.Subscription_Start_Year__c = subStartYear;
        obj.Subscription_End_Year__c = subEndYear;
        obj.CloseDate = Date.today();
        return obj;
    }

}