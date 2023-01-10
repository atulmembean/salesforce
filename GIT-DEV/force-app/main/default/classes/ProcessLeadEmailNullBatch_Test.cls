@IsTest(SeeAllData=true)
public class ProcessLeadEmailNullBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessLeadEmailNullBatch batch1 = new ProcessLeadEmailNullBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}