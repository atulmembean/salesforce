@isTest(SeeAllData=false)
public class UpdateLeadAddresstoAccountAddressTest {
	
	private static testMethod void myUnitTest(){
		//Create a Account
		Account acc= new Account(Name='Testing',BillingCountry='US',BillingState='Kentucky',BillingStreet='ABC',BillingPostalCode='889998'); 
		// create a Lead
		Lead lead=new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Prospecting',School_Account__c=acc.id);
		insert lead;                

		lead=  [SELECT Id,Status, FirstName,LastName,Company,LeadSource,City,Country,State,StateCode,Street,PostalCode,School_Account__r.BillingCity,School_Account__r.BillingCountry,School_Account__r.BillingState,School_Account__r.BillingStreet,School_Account__r.BillingPostalCode FROM Lead WHERE Id = :lead.Id and status='Prospecting'];
		//System.assertEquals('Prospecting', lead.Status);
		lead.City = lead.School_Account__r.BillingCity;
		lead.Country = lead.School_Account__r.BillingCountry;
		lead.StateCode = lead.School_Account__r.BillingState;
		lead.Street = lead.School_Account__r.BillingStreet;
        lead.PostalCode = lead.School_Account__r.BillingPostalCode; 
       	update lead;
        
        Test.startTest();
            UpdateLeadAddresstoAccountAddress obj = new UpdateLeadAddresstoAccountAddress();
            DataBase.executeBatch(obj);
        Test.stopTest();

	}

}