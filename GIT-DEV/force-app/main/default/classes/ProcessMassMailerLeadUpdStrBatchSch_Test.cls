@istest
private class ProcessMassMailerLeadUpdStrBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessMassMailerLeadUpdateStrBatchSch sh1 = new ProcessMassMailerLeadUpdateStrBatchSch ();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process MassMailer Lead Str', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}