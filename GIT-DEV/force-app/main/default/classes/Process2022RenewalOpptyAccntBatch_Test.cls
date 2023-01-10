@IsTest(SeeAllData=true)
public class Process2022RenewalOpptyAccntBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      Process2022RenewalOpptyAccntBatch batch1 = new Process2022RenewalOpptyAccntBatch();
      database.executebatch(batch1,20);
      Test.stopTest();
  }
}