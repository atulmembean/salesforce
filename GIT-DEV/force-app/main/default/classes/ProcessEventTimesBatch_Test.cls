@IsTest(SeeAllData=true)
public class ProcessEventTimesBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessEventTimesBatch batch1 = new ProcessEventTimesBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}