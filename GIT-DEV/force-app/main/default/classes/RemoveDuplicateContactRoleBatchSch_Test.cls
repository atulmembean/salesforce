@istest
private class RemoveDuplicateContactRoleBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
RemoveDuplicateContactRoleBatchScheduled sh1 = new RemoveDuplicateContactRoleBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Remove Duplicate Contact Roles', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}