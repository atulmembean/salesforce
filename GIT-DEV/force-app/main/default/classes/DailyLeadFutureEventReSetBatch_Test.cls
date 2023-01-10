@IsTest(SeeAllData=true)
public class DailyLeadFutureEventReSetBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      DailyLeadFutureEventReSetBatch batch1 = new DailyLeadFutureEventReSetBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}