@isTest(seeAllData=false)
public class CustomerSuccessControllerTest {
    static Account publicAccount;
    static Account publicAccount1;
    static Account districtAccount;
    static Opportunity regularOpportunity;
    static Opportunity regularOpportunity1;
    static Opportunity groupedOpportunity;
    static Customer_Success__c cus;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
	static Contact contactid;
    static boolean ismultiselectchange = true;
     
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
        contactid = new contact(LastName='abclk',AccountId=districtAccount.Id);
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
         cus.User_Rating__c='3';
        insert cus;
    }
    
    public static testMethod void Test1(){
        setupDataForController();
        CustomerSuccessController.getOpportunityList();
        CustomerSuccessController.getAllFieldValue(regularOpportunity.id);
        CustomerSuccessController.getAllFieldValue(cus.Id);
        CustomerSuccessController.getAllOpportunityFromAccount(regularOpportunity.id);
        CustomerSuccessController.getAllRelatedOpportunityFromAccount(regularOpportunity.id);
        CustomerSuccessController.getAllRelatedSubscriptionsFromAccount(cus.Id);
        CustomerSuccessController.getAllRelatedSubscriptionsFromAccount(regularOpportunity.id);
        // Code Inserted For Catch
        CustomerSuccessController.getAllFieldValue(null);
        CustomerSuccessController.getAllFieldValue(null);
        CustomerSuccessController.getAllOpportunityFromAccount(null);
        CustomerSuccessController.getAllRelatedOpportunityFromAccount(null);
        CustomerSuccessController.getAllRelatedSubscriptionsFromAccount(null);
        CustomerSuccessController.getAllRelatedSubscriptionsFromAccount(null);
        CustomerSuccessController.getAllCustomerSuccessRecord(null);
        
       // String JSONString = '[{"CustomerSuccessName":"Cust32483","accId":"publicAccount.id","UsageRelatedDiscussion":"Token","GrowthRelatedDiscussion":"UUA3W6Y27MYAMGY","Comments":"true","Status":"0034000000l68v3AAA","oppId":"regularOpportunity.id","UserRating":"10","CallFeedback":"10","Training":"UUA3W6Y27MYAMGY","DueDate":"system.today()","NewFeatureExploration":"0034000000l68v3AAA","NewFeature":"UUA3W6Y27MYAMGY","Testing":"true","Grading":"0034000000l68v3AAA","Activities":"UUA3W6Y27MYAMGY","OtherProponents":"true"}]';
        //JSON.Serialize(JSONString);
        
         CustomerSuccessWrapper cuswrap = new CustomerSuccessWrapper();
        cuswrap.custName='ABC';
        cuswrap.AccName=publicAccount.Id;
        cuswrap.UsageRelatedDiscussion='ABC';
        cuswrap.GrowthRelatedDiscussion='ABC';
        cuswrap.Comments='ABC';
        cuswrap.Status='ABC';
        cuswrap.Opportunity=regularOpportunity.Id;
        cuswrap.UserRating='ABC';
        cuswrap.CallFeedback='abc';
        cuswrap.Training=true;
        cuswrap.DueDate=system.today();
        cuswrap.NewFeatureExploration=true;
        cuswrap.NewFeature='abc';
        cuswrap.Testing='abc';
        cuswrap.Grading='abc';
        cuswrap.Activities='abc';
        cuswrap.OtherProponents='abc';
        cuswrap.issuesandConcerns='abc';
        cuswrap.RiskReasonSelected= '["a","b"]';
        String inputParam = JSON.serialize(cuswrap);
        system.debug('Its a cuswrap tset'+cuswrap);
        CustomerSuccessController.saveCustomerSuccesssRecord(inputParam,contactid.Id,ismultiselectchange);
        CustomerSuccessController.saveCustomerSuccesssRecord('','',ismultiselectchange);
      //  sobject cust = sobject.valuCustomer_Success__c';
        Customer_Success__c cus1 = new Customer_Success__c();
        cus1.get('Name');
        system.debug('@@@@@@@@@'+cus1);
        CustomerSuccessController.getselectOptions(cus1,'Status__c');
        CustomerSuccessController.getAllCustomerSuccessRecord(cus.Id);
       
       
    }
    
    public class CustomerSuccessWrapper{

        public String custName;
        public String AccName;
        public String UsageRelatedDiscussion;
        public String GrowthRelatedDiscussion;
        public String Comments;
        public String Status;
        public String Opportunity;
        public String UserRating;
        public String CallFeedback;
        public Boolean Training;
        public Date DueDate;
        public Boolean NewFeatureExploration;
        public String NewFeature;
        public String Testing;
        public String Grading;
        public String Activities;
        public String OtherProponents;
        public string issuesandConcerns;
        public string RiskReasonSelected;
        
    }
}