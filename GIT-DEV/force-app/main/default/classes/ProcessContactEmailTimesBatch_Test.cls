@IsTest(SeeAllData=true)
public class ProcessContactEmailTimesBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessContactEmailTimesBatch batch1 = new ProcessContactEmailTimesBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}