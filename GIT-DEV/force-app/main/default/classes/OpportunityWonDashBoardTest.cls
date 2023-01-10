@isTest(Seealldata=false)
public class OpportunityWonDashBoardTest {
   
    
    static Account publicAccount;
    static Account publicAccount1;
    static Account districtAccount;
    static Opportunity regularOpportunity;
    static Opportunity regularOpportunity1;
    static Opportunity regularOpportunity2;
    static Opportunity groupedOpportunity;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
    static List<Opportunity> newOpps1;
    static List<Opportunity> newOpps2;
    
    //@testSetup 
    static void setupDataForController() {
        newAccs = new List<Account>();
        newOpps = new List<Opportunity>();
        newOpps1 = new List<Opportunity>();
        newOpps2 = new List<Opportunity>();
        String thisYear=string.valueof(date.Today().year());
        String NextYear=string.valueof(date.Today().year()+1);
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
        Account a1 = new Account();
        a1.Name = 'ABCD123';
        a1.BillingCountry = 'Australia';
        a1.Academic_End_Month__c = 'November';
        a1.Subscription_Status__c='Customer';
        a1.Subscription_Years__c='2018';
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'ABKKLL123';
        a2.BillingCountry = 'United States';
        a2.Academic_End_Month__c = 'June';
        a2.Subscription_Status__c='Customer';
        a2.Subscription_Years__c='2017';
        insert a2;
        
        Country_Settings__c aus = new Country_Settings__c();
        aus.Academic_Year_End_Month__c = 'December';
        aus.Academic_Year_Start_Month__c = 'January';
        aus.Country__c = 'Australia';
        insert aus; 
        
       /* Country_Settings__c US = new Country_Settings__c();
        US.Academic_Year_End_Month__c = 'June';
        US.Academic_Year_Start_Month__c = 'August';
        US.Country__c = 'Australia';
        insert US;*/
        
        Contract CC = New Contract();
        cc.AccountId=publicAccount.Id;
        //cc.Subscription_Start_Year__c='2017';
        //cc.Subscription_End_Year__c='2018';
        cc.Subscription_Start_Year__c=string.valueof(date.Today().year());
        cc.Subscription_End_Year__c=string.valueof(date.Today().year()+1);
        insert cc;
        
        Contact con1 = new contact();
        con1.LastName='Test';
        con1.AccountId=publicAccount.Id;
        insert con1;
        
        regularOpportunity = TestClassUtility.createOpportunity('PublicOpp-1', publicAccount.Id, 'Estimate', '2016', '2017');
        regularOpportunity.No_of_Students__c = 10;
        regularOpportunity.No_of_Teachers__c = 5;
        regularOpportunity.Amount = 1000;
        regularOpportunity.Subscription__c=cc.id;
        //regularOpportunity.Account.Academic_End_Month__c='July';
        regularOpportunity.StageName='Close Won';
        regularOpportunity.Teacher__c=con1.Id;
        newOpps.add(regularOpportunity);
        

       groupedOpportunity = TestClassUtility.createOpportunity('GroupedOpp-1', districtAccount.Id, 'pilot', '2016', '2017');
       groupedOpportunity.Teacher__c=con1.id;
        newOpps.add(groupedOpportunity);
        insert newOpps;
        
        GroupedOpportunityAddSchoolsController.save(groupedOpportunity, new List<Account> {publicAccount}); 
        
        regularOpportunity1 = TestClassUtility.createOpportunity('PublicOpp-1', publicAccount.Id, 'Estimate', '2016', '2017');
        regularOpportunity1.No_of_Students__c = 10;
        regularOpportunity1.No_of_Teachers__c = 5;
        regularOpportunity1.Amount = 1000;
        regularOpportunity1.Subscription__c=cc.id;
        //regularOpportunity1.Account.Academic_End_Month__c='August';
        regularOpportunity1.StageName='Close Won';
        regularOpportunity1.Teacher__c=con1.id;
        regularOpportunity1.CloseDate= system.Date.today();
        newOpps1.add(regularOpportunity1);
        insert newOpps1;
        
        regularOpportunity2 = TestClassUtility.createOpportunity('PublicOpp-1', publicAccount.Id, 'Estimate', thisYear, NextYear);
        regularOpportunity2.No_of_Students__c = 10;
        regularOpportunity2.No_of_Teachers__c = 5;
        regularOpportunity2.Amount = 1000;
        regularOpportunity2.Subscription__c=cc.id;
        regularOpportunity2.StageName='Close Won';
        regularOpportunity2.Teacher__c=con1.id;
        //regularOpportunity2.Account.Academic_End_Month__c='September';
        regularOpportunity2.CloseDate= system.Date.today();
        newOpps2.add(regularOpportunity2);
        insert newOpps2;
    }
    
     public static testmethod void callControllerTest(){
         OpportunityWonDashBoard c = new OpportunityWonDashBoard();
     }
        public static testmethod void getGaugeDataTest(){
      
            setupDataForController();
         //   OpportunityWonDashBoard.Data d1 = new OpportunityWonDashBoard.Data(100,200);
          OpportunityWonDashBoard.Data d1 = new OpportunityWonDashBoard.Data(100);
            OpportunityWonDashBoard c = new OpportunityWonDashBoard();
            MembeanDashboardForPilots a = new MembeanDashboardForPilots();
            c.getGaugeData();
            c.getGaugeData2();
         
    }
}