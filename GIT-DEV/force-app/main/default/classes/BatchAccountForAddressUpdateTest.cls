@isTest(seeAllData=false)
public class BatchAccountForAddressUpdateTest {
	  public static Testmethod void setupData(){
        District__c dis = new District__C();
        dis.Name='ABC';
        insert dis;
        
        Account acc=new Account();
        acc.name='Test Account11';
        acc.GeocodeLatitude__latitude__s=37.09024;
        acc.GeocodeLatitude__Longitude__s=-95.712891;
        acc.IsActive__c=true;
        acc.Subscription_Status__c='Customer';
        acc.Academic_End_Month__c='April';
        acc.billingCity='Poland';
        acc.BillingStreet='A Test record';
        acc.District__c=dis.Id;
        acc.RecordTypeId=AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id;
        //acc.RecordType.Name ='Public School';
        insert acc;
        
        acc.BillingStreet='A Test Record';
        Update acc;
            
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.LastName = 'ABC';
		insert con;
}
    static testmethod void testTheBatchClass() {      
        setupData();
        Test.startTest();
        BatchAccountForAddressUpdate uca = new BatchAccountForAddressUpdate();
        ID batchid = Database.executeBatch(uca,200);
       // String jobId = system.schedule('Test Scheduled batch job for updating Account details on fields', '0 0 0 31 7 ? 2016-2022', new Scheduleclassname());
        Test.stopTest();
       
    }
}