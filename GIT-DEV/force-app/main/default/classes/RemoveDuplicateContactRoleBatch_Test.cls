@istest(SeeAllData=TRUE)
private class RemoveDuplicateContactRoleBatch_Test
{
@isTest static void test_method_one()
{
    Test.StartTest();
    Id batchJobId = Database.executeBatch(new RemoveDuplicateContactRoleBatch());    
    test.StopTest();
}
}