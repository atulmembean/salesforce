@isTest(seeAllData=false)

public class LCC_JSMQueryResultServiceTest {
    static Account publicAccount;
    static Account publicAccount1;
    static Account districtAccount;
    static Opportunity regularOpportunity;
    static Opportunity regularOpportunity1;
    static Opportunity regularOpportunity2;
    static Opportunity groupedOpportunity;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
    static string queryString;
    static void setupDataForController() {
        newAccs = new List<Account>();
        newOpps = new List<Opportunity>();
        if(AccountService.accRecordTypesByDevName != NULL) {
            
            publicAccount = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
            // publicAccount.BillingCountry='United States';
            newAccs.add(publicAccount);
            insert newAccs;
        }
        queryString = 'Select id,name from Account limit 10';
    }
     static testMethod void testLCC_JSMQueryResultService() {
        setupDataForController();
        LCC_JSMQueryResultService.executeQuery(queryString);
        LCC_JSMQueryResultService.executeQueryOneObject(queryString);
        LCC_JSMQueryResultService.getUserInfo();
		LCC_JSMQueryResultService.getProfileInfo();
		LCC_JSMQueryResultService.getSiteInfo();
		//LCC_JSMQueryResultService.executeQuery(null);
		//LCC_JSMQueryResultService.executeQueryOneObject(null);

     }
}