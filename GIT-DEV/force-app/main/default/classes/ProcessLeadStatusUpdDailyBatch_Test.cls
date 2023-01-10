@IsTest(SeeAllData=true)
public class ProcessLeadStatusUpdDailyBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessLeadStatusUpdDailyBatch batch1 = new ProcessLeadStatusUpdDailyBatch();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
}