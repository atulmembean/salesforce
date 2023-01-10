@isTest
public class Test_Registration_Clr {

    static testmethod void testLeadCreationPositiveTesting1(){
        
        Test.startTest();
        
        initializeData();
        
        Registration_Clr obj  = new Registration_Clr();
        Registration_Clr.getCities('California');
        Registration_Clr.getSchools('California', 'San Francisco');
        Lead dummyLead  = new Lead(LastName='Test Lead',company='Test',Email='test@test.com');
        Registration_Clr.createLead(dummyLead);
        Utility.getRecordTypeId('Account','Public School');
        Utility.getRecordTypesByObject('Account');
        
        List<Lead> newLeads  = new List<Lead>();
        newLeads.add(dummyLead);
        Utility.getRecordIds(newLeads);
        
        System.assertEquals(1, ([Select id from Lead where LastName='Test Lead']).size());
        Test.stopTest();
    }
    
     static testmethod void testLeadCreationPositiveTesting2(){
        
        Test.startTest();
        
        initializeData();
        
        Registration_Clr obj  = new Registration_Clr();
        Registration_Clr.getCities('California');
        Registration_Clr.getSchools('California', 'San Francisco');
        Lead dummyLead  = new Lead(LastName='Test Lead',company='Test',Email='test@test.com',Hear_About_Us__c='test');
        insert dummyLead;
         
        Lead siteLead  = new Lead(LastName='Test Lead',company='Test',Email='test@test.com',Hear_About_Us__c='test');
        Registration_Clr.createLead(siteLead);
        Utility.getRecordTypeId('Account','Public School');
        Utility.getRecordTypesByObject('Account');
        
        List<Lead> newLeads  = new List<Lead>();
        newLeads.add(dummyLead);
        Utility.getRecordIds(newLeads);
        
        System.assertEquals(1, ([Select id from Lead where LastName='Test Lead']).size());
        Test.stopTest();
    }
    
      static testmethod void testLeadCreationPositiveTesting3(){
        
        Test.startTest();
        
        initializeData();
        
        Registration_Clr obj  = new Registration_Clr();
        Registration_Clr.getCities('California');
        Registration_Clr.getSchools('California', 'San Francisco');
        Lead dummyLead  = new Lead(LastName='Test Lead',company='Test',Email='test@test.com',Hear_About_Us__c='test');
        insert dummyLead;
         
        Lead siteLead  = new Lead(LastName='Test Lead',company='Test',Email='test@test.com');
        Registration_Clr.createLead(siteLead);
        Utility.getRecordTypeId('Account','Public School');
        Utility.getRecordTypesByObject('Account');
        
        List<Lead> newLeads  = new List<Lead>();
        newLeads.add(dummyLead);
        Utility.getRecordIds(newLeads);
        
        System.assertEquals(1, ([Select id from Lead where LastName='Test Lead']).size());
        Test.stopTest();
    }
    
    static testmethod void testLeadCreationNegativeTesting(){
        
        Test.startTest();
        
        initializeData();
        
        Registration_Clr obj  = new Registration_Clr();
        Registration_Clr.getCities('New York');
        Registration_Clr.getSchools('California', 'San Francisco');
        Lead dummyLead  = new Lead(LastName='Test Lead',Email='test@test.com');
        Registration_Clr.createLead(dummyLead);
        
        Registration_Clr.getSchools(null, null);
        Utility.getRecordTypeId('Account','Public');
        Utility.getRecordTypesByObject('Accounts');
      
        System.assertEquals(0, ([Select id from Lead where LastName='Test Lead']).size());
        Test.stopTest();
    }
    static void initializeData(){
        
      Account dummyAcc      = new Account();
        dummyAcc.Name        = 'Test Account';
        dummyAcc.RecordTypeId    = Utility.getObjectRecordTypeId(Utility.ACCOUNT_OBJ,Utility.PUBLIC_SCHOOL);
      dummyAcc.BillingCity     = 'San Francisco';
        dummyAcc.BillingState     ='California';
        dummyAcc.Academic_End_Month__c = 'July';
        insert dummyAcc;
        
        City_State_Mapping__c dummyMap  = new City_State_Mapping__c();
        dummyMap.City__c        = 'San Francisco';
        dummyMap.State__c        = 'California';
        dummyMap.State_Code__c      = 'CA';
        insert dummyMap;
        
        Conference_Name_for_Teacher_Registration__c conf = new Conference_Name_for_Teacher_Registration__c();
        conf.Name  = 'Conference 1';
        insert conf;
    }
}