@IsTest(SeeAllData=true)
public class ProcessOpptyFutureActivityBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessOpptyFutureActivityBatch batch1 = new ProcessOpptyFutureActivityBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}