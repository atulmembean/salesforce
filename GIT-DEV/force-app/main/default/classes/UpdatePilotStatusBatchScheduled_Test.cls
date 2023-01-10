@istest
private class UpdatePilotStatusBatchScheduled_Test{
@isTest static void test_method_one() {
Test.StartTest();
UpdatePilotStatusBatchScheduled sh1 = new UpdatePilotStatusBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process Update Pilot Status on Account', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}