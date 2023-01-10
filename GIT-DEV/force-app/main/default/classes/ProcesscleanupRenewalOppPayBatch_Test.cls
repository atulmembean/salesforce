@IsTest(SeeAllData=true)
public class ProcesscleanupRenewalOppPayBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcesscleanupRenewalOppPayBatch batch1 = new ProcesscleanupRenewalOppPayBatch();
      database.executebatch(batch1,5);
      Test.stopTest();
  }
}