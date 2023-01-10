@istest
private class ProcessPaymentRenewalOpptyBatchSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessPaymentRenewalOpptyBatchScheduled sh1 = new ProcessPaymentRenewalOpptyBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Renewal Oppty', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}