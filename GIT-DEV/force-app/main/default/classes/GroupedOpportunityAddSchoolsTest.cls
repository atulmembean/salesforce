@isTest
private class GroupedOpportunityAddSchoolsTest {
    
    static Account publicAccount;
    static Account publicAccount1;
    static Account districtAccount;
    static Account agencyAccount;
    static Opportunity districtOpportunity;
    static Opportunity agencyOpportunity;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
    static District__c gaDistrict;
    
    //@testSetup 
    static void setupDataForController() {
        newAccs = new List<Account>();
        newOpps = new List<Opportunity>();
        if(AccountService.accRecordTypesByDevName != NULL) {
            gaDistrict = new District__c();
            insert gaDistrict;
            
        	publicAccount = TestClassUtility.createAccount('PublicAcc-0', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
            publicAccount.District__c = gaDistrict.Id;
            newAccs.add(publicAccount);
            publicAccount1 = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
            publicAccount1.District__c = gaDistrict.Id;
            newAccs.add(publicAccount1);
            districtAccount = TestClassUtility.createAccount('Grouped-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_District).Id);
            districtAccount.District__c = gaDistrict.Id;
            newAccs.add(districtAccount);
            agencyAccount = TestClassUtility.createAccount('Agency-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_Agency).Id);
            newAccs.add(agencyAccount);
            insert newAccs;
        }
        
        districtOpportunity = TestClassUtility.createOpportunity('DistrictOpp-1', districtAccount.Id, 'Pilot', '2016', '2017');
        newOpps.add(districtOpportunity);
        agencyOpportunity = TestClassUtility.createOpportunity('AgencyOpp-1', agencyAccount.Id, 'Pilot', '2016', '2017');
        newOpps.add(agencyOpportunity);
        insert newOpps;
    }
    
	static testMethod void groupedOpportunityTest() {
        setupDataForController();
        
        GroupedOpportunityAddSchoolsController gascDefault = new GroupedOpportunityAddSchoolsController();
        GroupedOpportunityAddSchoolsController.getCurrentOpp(null);
        GroupedOpportunityAddSchoolsController.getSection(null);
        GroupedOpportunityAddSchoolsController.getShowDistrictSection(null);
        GroupedOpportunityAddSchoolsController.getShowAgencySection(null);
        GroupedOpportunityAddSchoolsController.getDistrictId(null);
        GroupedOpportunityAddSchoolsController.getLinkedChildOpps(null);
        GroupedOpportunityAddSchoolsController.getLinkedSchoolIds(null);
        
        
        ApexPages.currentPage().getParameters().put('id', districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController gasc = new GroupedOpportunityAddSchoolsController(null);
        GroupedOpportunityAddSchoolsController.getCurrentOpp(districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getSection(districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getShowDistrictSection(districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getShowAgencySection(districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getDistrictId(districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getLinkedChildOpps(districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getLinkedSchoolIds(districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getLinkedSchools(new List<Id> {publicAccount.Id});
        GroupedOpportunityAddSchoolsController.getNonLinkedSchoolsByDistrictId(gaDistrict.Id, districtOpportunity.Id);
        GroupedOpportunityAddSchoolsController.searchSchoolsByDistrictId(gaDistrict.Id);
        
        GroupedOpportunityAddSchoolsController.save(districtOpportunity, new List<Account> {publicAccount});
        districtOpportunity.Subscription_End_Year__c = '2018';
        update districtOpportunity;
        GroupedOpportunityAddSchoolsController.save(districtOpportunity, new List<Account> {publicAccount1});
        
        GroupedOpportunityAddSchoolsController.getSection(agencyOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getShowAgencySection(agencyOpportunity.Id);
        GroupedOpportunityAddSchoolsController.getNonLinkedSchoolsByPrefix('Pub', null);
        GroupedOpportunityAddSchoolsController.getNonLinkedSchoolsByPrefix('Pub', new List<Id> {publicAccount.Id});
        GroupedOpportunityAddSchoolsController.searchSchoolsByPrefix('Pub');
    }
}