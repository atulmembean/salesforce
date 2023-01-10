@isTest(seeAllData=false)
public class CustomerSuccessTriggerHandlerTest {
 static Account publicAccount;
    static Account publicAccount1;
    static Account districtAccount;
    static Opportunity regularOpportunity;
    static Opportunity regularOpportunity1;
    static Opportunity groupedOpportunity;
    static Customer_Success__c cus;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
    
    //@testSetup 
    static void setupDataForController() {
        newAccs = new List<Account>();
        newOpps = new List<Opportunity>();
        if(AccountService.accRecordTypesByDevName != NULL) {
            
          publicAccount = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
           // publicAccount.BillingCountry='United States';
            newAccs.add(publicAccount);
            publicAccount1 = TestClassUtility.createAccount('PublicAcc-2', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
            newAccs.add(publicAccount1);
            districtAccount = TestClassUtility.createAccount('Grouped-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_District).Id);
            newAccs.add(districtAccount);
            insert newAccs;
        }
        Contract CC = New Contract();
        cc.AccountId=publicAccount.Id;
        cc.Subscription_Start_Year__c='2017';
        cc.Subscription_End_Year__c='2018';
        insert cc;
        Contact con=new Contact();
        con.lastname='dddd';
        con.AccountId=publicAccount.Id;
        insert con;
        Contact con2=new Contact();
        con2.lastname='dddd2';
        con2.AccountId=districtAccount.Id;
        insert con2;
       // regularOpportunity = TestClassUtility.createOpportunity('PublicOpp-1', publicAccount.Id, 'Estimate', '2016', '2017');
       regularOpportunity = new Opportunity(
        Name = 'PublicOpp-1',
        AccountId = publicAccount.Id,
        StageName = 'Estimate',
        Subscription_Start_Year__c = '2016',
        Subscription_End_Year__c = '2017',
        CloseDate = Date.today(),
        Teacher__c=con.Id,
        No_of_Students__c = 10,
        No_of_Teachers__c = 5,
        Amount = 1000,
        Subscription__c=cc.id
       );
        
        newOpps.add(regularOpportunity);
		
       // groupedOpportunity = TestClassUtility.createOpportunity('GroupedOpp-1', districtAccount.Id, 'Pilot', '2016', '2017');
        groupedOpportunity = new opportunity(
        Name = 'objName',
        AccountId = districtAccount.Id,
        StageName = 'Pilot',
        Subscription_Start_Year__c = '2016',
        Subscription_End_Year__c = '2017',
        CloseDate = Date.today(),
        Teacher__c=con2.Id
       );
        newOpps.add(groupedOpportunity);
        insert newOpps;
        
        GroupedOpportunityAddSchoolsController.save(groupedOpportunity, new List<Account> {publicAccount});
        
         cus = new Customer_Success__c();
         cus.Name='CustomerSuccessName';
         cus.Account__c=publicAccount.id;
         cus.Usage_Related_Discussion__c= 'UsageRelatedDiscussion';
         cus.Growth_Related_Discussion__c= 'GrowthRelatedDiscussion';
         cus.Comments__c = 'Comments';
         cus.Status__c='Open';
         cus.Opportunity__c= regularOpportunity.id;
         cus.User_Rating__c='10';
        insert cus;
        
        cus.Status__c='Cancelled';
        update cus;
    }
    
    public static testMethod void Test1(){
        setupDataForController();
    }
}