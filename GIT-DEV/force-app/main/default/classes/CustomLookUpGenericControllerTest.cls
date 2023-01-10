@isTest(seeAllData=false)
public class CustomLookUpGenericControllerTest {
    private static Account testaccount;
    private static testMethod void Test1(){
        testaccount = TestClassUtility.createAccount('Publitest', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
        insert testAccount;
        CustomLookUpGenericController.fetchLookUpValues('test','Contact',testaccount.Id);
    }
}