@IsTest(SeeAllData=true)
public class ProcessFutureActivityOpptyBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessFutureActivityOpptyBatch batch1 = new ProcessFutureActivityOpptyBatch();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
}