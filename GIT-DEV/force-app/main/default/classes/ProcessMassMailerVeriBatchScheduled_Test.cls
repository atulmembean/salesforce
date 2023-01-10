@istest
private class ProcessMassMailerVeriBatchScheduled_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessMassMailerVeriBatchScheduled sh1 = new ProcessMassMailerVeriBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test MassMailer Verification Job', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}