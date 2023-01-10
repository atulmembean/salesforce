@IsTest(SeeAllData=true)
public class Process2022RenewalOpptyBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      Process2022RenewalOpptyBatch batch1 = new Process2022RenewalOpptyBatch();
      database.executebatch(batch1,10);
      Test.stopTest();
  }
}