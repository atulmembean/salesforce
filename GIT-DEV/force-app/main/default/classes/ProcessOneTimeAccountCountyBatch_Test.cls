@IsTest(SeeAllData=true)
public class ProcessOneTimeAccountCountyBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessOneTimeAccountCountyBatch batch1 = new ProcessOneTimeAccountCountyBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}