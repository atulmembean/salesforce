/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

@isTest
private class UpdateAccountAtEndOfAcedemicYearTest {

    @testSetup 
    static void setup() {
    	Country_Settings__c cs1 = new Country_Settings__c(
    	Country__c = 'US',
    	Academic_Year_Start_Month__c = getMonthName(Date.Today().month()),
    	Academic_Year_End_Month__c = getMonthName(Date.Today().month()+1)
    	);
    	insert cs1;
        List<Account> accounts = new List<Account>();
        List<Account> accountsPilot = new List<Account>();
        List<Account> accountsExpired = new List<Account>();
       
        List<Contract> contracts = new List<Contract>();
        List<Opportunity> opportunities = new List<Opportunity>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='New York', billingcountry='United States',Subscription_Status__c = 'Customer',Academic_End_Month__c='July'));
        } insert accounts;
        for (Integer i=0;i<10;i++) {
            accountsPilot.add(new Account(name='AccountNew'+i, 
                billingcity='New York', billingcountry='United States',Subscription_Status__c = 'Pilot',Academic_End_Month__c='July'));
        }insert accountsPilot;
        for (Integer i=0;i<10;i++) {
            accountsExpired.add(new Account(name='AccountTest '+i, 
                billingcity='New York', billingcountry='United States',Subscription_Status__c = 'Expired',Academic_End_Month__c='July'));
        }
        insert accountsExpired;
        // find the account just inserted. add contract for each
        for (Account account : accounts) {
            contracts.add(new Contract(
            Status='Subscribed',
            accountId=account.id, 
            Subscription_Start_Year__c = String.valueOf(System.Today().Year()),
            Subscription_End_Year__c = String.valueOf(System.Today().Year()+1)
            ));
        }
        
        for(Account account : accountsPilot) {
            opportunities.add(new Opportunity(
            StageName='Pilot',
            accountId=account.id, 
            Subscription_Start_Year__c = String.valueOf(System.Today().Year()),
            Subscription_End_Year__c = String.valueOf(System.Today().Year()+1)
            ));
        }
        contracts.add(new Contract(
            Status='Subscribed',
            accountId=accounts[0].id, 
            Subscription_Start_Year__c = String.valueOf(System.Today().Year()+1),
            Subscription_End_Year__c = String.valueOf(System.Today().Year()+2)
            ));
        opportunities.add(new Opportunity(
            StageName='Pilot',
            accountId=accountsPilot[0].id, 
            Subscription_Start_Year__c = String.valueOf(System.Today().Year()+1),
            Subscription_End_Year__c = String.valueOf(System.Today().Year()+2)
            ));
        insert contracts ;    
    }
    static string getMonthName(Integer monthNumber){
    	monthNumber = monthNumber == 13 ? 1 : monthNumber;
    	return (monthNumber == 1 ? 'January' : monthNumber == 2 ? 'February' : monthNumber == 3 ? 'March' : monthNumber == 4 ? 'April' : monthNumber == 5 ? 'May' : monthNumber == 6 ? 'June' : monthNumber == 7 ? 'July' : monthNumber == 8 ? 'August' : monthNumber == 9 ? 'September' : monthNumber == 10 ? 'October' : monthNumber == 11 ? 'November' : monthNumber == 12 ? 'December' :'December'); 
    }

    static testmethod void test() {        
        Test.startTest();
        UpdateAccountAtEndOfAcedemicYear uca = new UpdateAccountAtEndOfAcedemicYear();
        Id batchId = Database.executeBatch(uca);
        String jobId = system.schedule('Test Scheduled batch job for updating expired Account', '0 0 0 31 7 ? 2016-2022', new ScheduleBatchJobs());
        Test.stopTest();
       
    }
    
}