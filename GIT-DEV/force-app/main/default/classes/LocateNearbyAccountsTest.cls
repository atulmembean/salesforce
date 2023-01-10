@isTest
public class LocateNearbyAccountsTest {
    public static Testmethod void setupData(){
       /* Account districtAcc=new Account();
        districtAcc = TestClassUtility.createAccount('Grouped-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_District).Id);
        insert districtAcc;
        string disId=districtAcc.Id;
        string districtId;
        String finaldistrictId= disId.subString(0, 15); */
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.IsActive__c=true;
        acc.Subscription_Status__c='Expired';
        acc.Academic_End_Month__c='April';
       // acc.District__c = finaldistrictId;
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'ABC';
		insert con;
        
        PageReference pageRef = Page.LeadInlinePage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(ld.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LeadInlinePageController testAccPlan = new LeadInlinePageController(sc);
       // testAccPlan.selectedItem='pPrior_Customerr';
       /// testAccPlan.selectedRecordType='All';
        testAccPlan.getschoolDetails();
        
        PageReference pageRef2 = Page.ContactInlinePage;
        Test.setCurrentPage(pageRef2);
        pageRef2.getParameters().put('Id', String.valueOf(con.Id));
        ApexPages.StandardController sc2 = new ApexPages.StandardController(acc);
        LeadInlinePageController testAccPlan2 = new LeadInlinePageController(sc2);
       // testAccPlan.selectedItem='pPrior_Customerr';
       /// testAccPlan.selectedRecordType='All';
        testAccPlan2.getschoolDetails();

    }

    public static Testmethod void testData(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.IsActive__c=true;
        acc.Subscription_Status__c='Expired';
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'ABC';
		insert con;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedItem='pPrior_Customerr';
        testAccPlan.selectedRecordType='All';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();
        
        pageRef.getParameters().put('Id', String.valueOf(ld.Id));
        ApexPages.StandardController sc2 = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan2 = new LocateNearbyAccounts(sc2);
        testAccPlan2.selectedItem='pPrior_Customerr';
        testAccPlan2.selectedRecordType='All';
        testAccPlan2.getschoolDetails();
        testAccPlan2.goBack();
        testAccPlan2.getTotalPages();
        testAccPlan2.getDisablePrevious();
        testAccPlan2.getDisableNext();
        testAccPlan2.Beginning();
        
        pageRef.getParameters().put('Id', String.valueOf(con.Id));
        ApexPages.StandardController sc3 = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan3 = new LocateNearbyAccounts(sc3);
        testAccPlan3.selectedItem='pPrior_Customerr';
        testAccPlan3.selectedRecordType='All';
        testAccPlan3.getschoolDetails();
        testAccPlan3.goBack();
        testAccPlan3.getTotalPages();
        testAccPlan3.getDisablePrevious();
        testAccPlan3.getDisableNext();
        testAccPlan3.Beginning();

    }
    public static Testmethod void testData1(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.Pilot_Status__c='Started';
        acc.IsActive__c=true;
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedItem='PPilot_Schoolss';
        testAccPlan.selectedRecordType='All';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    
    public static Testmethod void testData2(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        //acc.IsActive__c=true;
        acc.Subscription_Status__c='Expired';
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedItem='pPrior_Customerr';
        testAccPlan.pq='Prior_Customer';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();
        
        testAccPlan.Next();
        testAccPlan.End();
        testAccPlan.getTotal_size();
        testAccPlan.getPageNumber();
        try{
            testAccPlan.Previous();
        }Catch(Exception e){}
    }
     public static Testmethod void testData3(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
         acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedItem='pPilot_Schoolss';
        testAccPlan.selectedRecordType='Private';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData4(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.Academic_End_Month__c='April';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Public';
         testAccPlan.selectedItem='pAlls';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData5(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Private School').getRecordTypeId();
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Private';
         testAccPlan.selectedItem='CCustomerr';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData6(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Private School').getRecordTypeId();
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='All';
        testAccPlan.selectedItem='CCustomerr';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData7(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Public';
         testAccPlan.selectedItem='pNones';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
     public static Testmethod void testData8(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
         acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Public';
         testAccPlan.selectedItem='pPrior_Customerr';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    
    
    public static Testmethod void testData9(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
         acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Public';
        testAccPlan.selectedItem='pPilot_Schoolss';
      //  testAccPlan.selectedItem.add('Prior_Customer');
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData10(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Private';
         testAccPlan.selectedItem='pNones';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData11(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.Academic_End_Month__c='April';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Private';
         testAccPlan.selectedItem='pAlls';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData12(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.Academic_End_Month__c='April';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='All';
         testAccPlan.selectedItem='pAlls';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData13(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
         acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Private';
         testAccPlan.selectedItem='pPrior_Customerr';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
    public static Testmethod void testData14(){
        Account acc=new Account();
        acc.name='Test Account';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.Subscription_Status__c='Customer';
        acc.IsActive__c=true;
         acc.Pilot_Status__c='Started';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Private School').getRecordTypeId();
        acc.Academic_End_Month__c='April';
        insert acc;
        
        Lead ld=new Lead();
        ld.LastName='Test Lead';
        ld.Website='www.google.com';
        ld.School_Account__c=acc.id;
        ld.Role__c='Teacher';
        ld.Status='New';
        ld.Company='Membean';
        insert ld;
        
        PageReference pageRef = Page.LocateNearbyAccounts;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(acc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        LocateNearbyAccounts testAccPlan = new LocateNearbyAccounts(sc);
        testAccPlan.selectedRecordType='Public';
        testAccPlan.selectedItem='CCustomerr';
        testAccPlan.getschoolDetails();
        testAccPlan.goBack();
        testAccPlan.getTotalPages();
        testAccPlan.getDisablePrevious();
        testAccPlan.getDisableNext();
        testAccPlan.Beginning();

    }
 }