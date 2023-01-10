@IsTest(SeeAllData=true)
public class Process2022RenewalOppPayBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      Process2022RenewalOppPayBatch batch1 = new Process2022RenewalOppPayBatch();
      database.executebatch(batch1,5);
      Test.stopTest();
  }
}