@istest
private class ProcessMassMailerLeadUpdateBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessMassMailerLeadUpdateBatchSch sh1 = new ProcessMassMailerLeadUpdateBatchSch();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process MassMailer Lead', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}