@isTest(seeAllData=true)
public class UpdateAccountStatusScheduler_Test {
  
    @isTest static void validatePayScheduler(){
        
        Test.StartTest();
        UpdateAccountStatusScheduler sh = new UpdateAccountStatusScheduler();        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Update Account Status Update', sch, sh); 
        Test.stopTest(); 
    }
}