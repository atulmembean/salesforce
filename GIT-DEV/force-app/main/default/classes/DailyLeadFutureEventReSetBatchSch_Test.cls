@istest
private class DailyLeadFutureEventReSetBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
DailyLeadFutureEventReSetBatchSch sh1 = new DailyLeadFutureEventReSetBatchSch();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}