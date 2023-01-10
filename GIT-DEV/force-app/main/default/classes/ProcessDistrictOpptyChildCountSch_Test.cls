@istest
private class ProcessDistrictOpptyChildCountSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessDistrictOpptyChildCountScheduled sh1 = new ProcessDistrictOpptyChildCountScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process child oppty count', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}