@isTest
private class AccountTriggerTest {
    static Account publicAccount;
    static Account privateAccount;
    static List<Account> newAccs;
    
    @testSetup static void setup(){
        Account acc = new Account(
          Name = 'Test Account',    
          IsActive__c = true,                           
          Type_of_School__c = 'Middle School',                         
          Category__c = 'School',                                     
          Low_Grade__c = '6',                                          
          High_Grade__c = '8',                                        
          Source__c = 'District - Email Blast',                        
          NCES_School_ID__c = '130255000000',                         
          Title_1_School_Wide__c = false,                              
          State_School_ID__c = '4058',                                 
          Title_1_School__c = false,                                  
          Population__c = 1172,                          
          Tuition__c = 0,                                              
          Student_Teacher_Ratio__c = 14,                              
          Charter__c = false,                                          
          Locale_Code__c = 21,                                         
          Magnet__c = false,                                           
          Free_Lunch__c = 0,                                           
          Zip_4_digit__c = '4223',                                    
          Teacher_Count__c = 81,                                       
          Used_before_2013__c = false, 
          Academic_End_Month__c='April',  
          Students__c = 1172,
          BillingState='Karnataka',  
          BillingCountry='India',
          No_of_Students__c = 20,
          recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('District').getRecordTypeId()  
        );
        
        //insert acc;
        District__c district = new District__C(
            Name = 'Test',
            City__c = 'Abbeville',
            Street_Address__c = 'Georgia',
            Country__c = 'United states',
            Zip__c = '123',
            Locale_Code__c = 12345,
            Locale__c = 'City Large',
            Zip_4_digit__c = '1234',
            NCES_District_ID__c = '123TEST'
            );
        insert district;
        acc.District__c = district.id;
        insert acc;
        City_State_Mapping__c cityCsm = new City_State_Mapping__c(
          City__c=' Abbeville',
          State__c='Georgia',  
         // Timezone__c='Central Timezone',
          Type__c='Tax'  
        );
        
        insert cityCsm;
            
        City_State_Mapping__c taxCsm = new City_State_Mapping__c(
          County__c='GWINNETT COUNTY',
          State__c='Georgia',  
          Tax__c=10,
          Type__c='Tax',
          Add_tax_for_county__c=True  
        );
        
        insert taxCsm;
    }
    
    
    static void setupDataForController() {
        newAccs = new List<Account>();
        
        if(AccountService.accRecordTypesByDevName != NULL) {
            publicAccount = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
            newAccs.add(publicAccount);
            privateAccount = TestClassUtility.createAccount('PrivateAcc-2', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PrivateSchool).Id);
            newAccs.add(privateAccount);
            insert newAccs;
        }
    }
    
    static testMethod void accTriggerTest() {
        setupDataForController();
        
        privateAccount.Enroll_1__c = 10;
        privateAccount.Enroll_2__c = 10;
        privateAccount.Enroll_3__c = 10;
        privateAccount.Enroll_4__c = 10;
        privateAccount.Enroll_5__c = 10;
        privateAccount.Enroll_6__c = 10;
        privateAccount.Enroll_7__c = 10;
        privateAccount.Enroll_8__c = 10;
        privateAccount.Enroll_9__c = 10;
        privateAccount.Enroll_10__c = 10;
        privateAccount.Enroll_11__c = 10;
        privateAccount.Enroll_12__c = 10;
        privateAccount.Low_Grade__c = '1';
        privateAccount.High_Grade__c = '12';
        privateAccount.No_of_Students__c = 80;

        publicAccount.No_of_Students__c = 80;
        publicAccount.Students__c = 110;
        publicAccount.Type_of_School__c = Constants.ACC_SCHOOL_TYPE_MIDDLE;
        
        initializeTriggerParams();
        update newAccs;
        
        privateAccount.Low_Grade__c = '5';
        publicAccount.Type_of_School__c = Constants.ACC_SCHOOL_TYPE_OTHERS;
        publicAccount.Low_Grade__c = '1';
        initializeTriggerParams();
        update newAccs;
        
        privateAccount.Low_Grade__c = '12';
        privateAccount.Enroll_12__c = 0;
        publicAccount.High_Grade__c = '12';
        initializeTriggerParams();
        update newAccs;
        
        publicAccount.Low_Grade__c = NULL;
        initializeTriggerParams();
        update publicAccount;
        
        publicAccount.Students__c = 0;
        initializeTriggerParams();
        update publicAccount;
        
        AccountService.getSchoolsByDistrictId(null);
        AccountService.getUnSelectedSchoolsByDistrictId(null, null);
        AccountService.getSchoolsByPrefix(null);
        AccountService.getUnSelectedSchoolsByPrefix(null, null);
        AccountService.getSchoolsByDistrictId(null);
        AccountService.getSchoolsByIds(null);
        AccountService.getSchoolsById(null);
        
        Utility.getRecordTypeId('Account', Constants.RT_Account_PublicSchool);
        Utility.getRecordTypeId('Account', 'hi');
        Utility.getRecordTypesByObject(null);
    }
    
    static void initializeTriggerParams() {
        AccountService.runBeforeTrigger = true;
    }
    
    static testMethod void testAfterTrigger(){
        
        District__c testDist    = new District__c();
        testDist.Name   ='Test District';
        testDist.Pilot_Years__c= '2013';
        testDist.Customer_Years__c='2013';
        testDist.NCES_District_ID__c = '123TEST1';
        insert testDist;
        Account testAcc = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
        testAcc.District__c = testDist.id;
        testAcc.Subscription_Status__c  = 'Customer';
        testAcc.High_Grade__c = '9';
        testAcc.Pilot_Years__c = '2014;2015';        
        testAcc.Subscription_Years__c = '2015';        
        insert testAcc;
        
        testAcc.Pilot_Years__c = '2015;2016';
        testAcc.Subscription_Years__c = '2016';
        
        
               
        AccountService.runAfterTrigger= true;
        update testAcc;
    }
    
    static testmethod void testDistrictRollups(){
        District__c testDist    = new District__c();
        testDist.Name   ='Test District';
        testDist.Pilot_Years__c= '2013';
        testDist.Customer_Years__c='2013';
        testDist.NCES_District_ID__c = '123TEST2';
        insert testDist;
        
        Account testAcc = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
        testAcc.District__c = testDist.id;
        testAcc.Subscription_Status__c  = 'Customer';
        testAcc.High_Grade__c = '9';
        testAcc.Pilot_Years__c = '2014;2015';        
        testAcc.Subscription_Years__c = '2015';        
        insert testAcc;
    }
    
    static testMethod void validateTaxntimezoneUpdate(){
        Test.startTest();
        Account acc = [select County_Name__c,BillingCity from Account LIMIT 1];        
        acc.County_Name__c = 'GWINNETT COUNTY';        
        acc.BillingCity = 'Abbeville';
        acc.Ready_to_Invite_via_Email__c = TRUE;
        update acc;             
        Test.stopTest();
    }
}