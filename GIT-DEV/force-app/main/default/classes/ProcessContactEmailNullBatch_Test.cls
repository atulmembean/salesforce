@IsTest(SeeAllData=true)
public class ProcessContactEmailNullBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessContactEmailNullBatch batch1 = new ProcessContactEmailNullBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}