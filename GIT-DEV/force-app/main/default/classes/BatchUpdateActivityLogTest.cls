@isTest(seeAllData = TRUE)
public class BatchUpdateActivityLogTest {
    
    static testMethod void validateUpdateActivityLog(){
        BatchUpdateActivityLog bual = new BatchUpdateActivityLog();
        Test.startTest();
        Database.executeBatch(bual,10);
        Test.stopTest();
    }
    
}