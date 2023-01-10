@IsTest(SeeAllData=true)
public class ProcessLeadEmailTimesBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessLeadEmailTimesBatch batch1 = new ProcessLeadEmailTimesBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}