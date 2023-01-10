@istest
private class ProcessDailyEmailTimesBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessDailyEmailTimesBatchSch sh1 = new ProcessDailyEmailTimesBatchSch();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}