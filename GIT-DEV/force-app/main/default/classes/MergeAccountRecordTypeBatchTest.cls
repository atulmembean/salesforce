@isTest
public class MergeAccountRecordTypeBatchTest {

    @TestSetup
    public static void setupTestData(){
        Id recordTypePublicSchoolPilot=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School - Pilot').recordTypeId;
        Id recordTypePrivateSchoolPilot=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Private School - Pilot').recordTypeId;
        Account objAccount=new Account(name='test 1', recordTypeId=recordTypePublicSchoolPilot);
        Account objAccount1=new Account(name='test 2', recordTypeId=recordTypePrivateSchoolPilot);
        insert objAccount;
        insert objAccount1;
    }
    public static testmethod void testBatch(){
        Database.executeBatch(new MergeAccountRecordTypeBatch());
    }
}