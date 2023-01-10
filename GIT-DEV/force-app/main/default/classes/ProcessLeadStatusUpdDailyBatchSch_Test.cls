@istest
private class ProcessLeadStatusUpdDailyBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessLeadStatusUpdDailyBatchScheduled sh1 = new ProcessLeadStatusUpdDailyBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Lead Status Daily', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}