@IsTest(SeeAllData=true)
public class ProcessMassMailerLeadUpdateStrBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessMassMailerLeadUpdateStrBatch batch1 = new ProcessMassMailerLeadUpdateStrBatch();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
}