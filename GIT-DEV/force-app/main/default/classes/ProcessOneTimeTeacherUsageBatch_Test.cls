@IsTest(SeeAllData=true)
public class ProcessOneTimeTeacherUsageBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessOneTimeTeacherUsageBatch batch1 = new ProcessOneTimeTeacherUsageBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}