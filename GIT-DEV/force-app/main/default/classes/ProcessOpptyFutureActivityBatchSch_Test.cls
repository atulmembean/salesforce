@istest
private class ProcessOpptyFutureActivityBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessOpptyFutureActivityBatchScheduled sh1 = new ProcessOpptyFutureActivityBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Daily Oppty Future Activity Calc', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}