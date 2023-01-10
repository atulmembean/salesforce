@IsTest(SeeAllData=true)
public class ProcessOneTimeSubscriptionsBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessOneTimeSubscriptionsBatch batch1 = new ProcessOneTimeSubscriptionsBatch();
      database.executebatch(batch1,5);
      Test.stopTest();
  }
}