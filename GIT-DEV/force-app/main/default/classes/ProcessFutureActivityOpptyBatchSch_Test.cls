@istest
private class ProcessFutureActivityOpptyBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessFutureActivityOpptyBatchScheduled sh1 = new ProcessFutureActivityOpptyBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process Future Activity Check on Oppty', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}