@istest
private class ProcessMembeanUserBatchScheduled_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessMembeanUserBatchScheduled sh1 = new ProcessMembeanUserBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process membean User Update', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}