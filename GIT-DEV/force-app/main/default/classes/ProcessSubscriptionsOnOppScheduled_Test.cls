@istest
private class ProcessSubscriptionsOnOppScheduled_Test{
@isTest static void test_method_one() {
Test.StartTest();
ProcessSubscriptionsOnOppScheduled sh1 = new ProcessSubscriptionsOnOppScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Process Subscriptions on Oppty', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}