@IsTest(SeeAllData=true)
public class ProcessDailyEventTimesBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessDailyEventTimesBatch batch1 = new ProcessDailyEventTimesBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}