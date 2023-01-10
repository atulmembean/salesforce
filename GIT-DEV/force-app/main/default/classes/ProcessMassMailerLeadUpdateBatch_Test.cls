@IsTest(SeeAllData=true)
public class ProcessMassMailerLeadUpdateBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessMassMailerLeadUpdateBatch batch1 = new ProcessMassMailerLeadUpdateBatch();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
}