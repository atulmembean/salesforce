@IsTest(SeeAllData=true)
public class Process2022RenewalOppBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      Process2022RenewalOppBatch batch1 = new Process2022RenewalOppBatch();
      database.executebatch(batch1,5);
      Test.stopTest();
  }
}