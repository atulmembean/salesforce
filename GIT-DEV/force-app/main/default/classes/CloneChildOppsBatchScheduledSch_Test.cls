@istest
private class CloneChildOppsBatchScheduledSch_Test{
@isTest static void test_method_one() {
Test.StartTest();
CloneChildOppsBatchScheduled sh1 = new CloneChildOppsBatchScheduled();
String sch = '0 0 23 * * ?';
String jobId = system.schedule('Test Clone Child Grouped Oppty', sch, sh1);

CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
System.assertEquals(sch,ct.CronExpression);
 
Test.stopTest();
}
}