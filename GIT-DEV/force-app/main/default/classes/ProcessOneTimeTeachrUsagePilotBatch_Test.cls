@IsTest(SeeAllData=true)
public class ProcessOneTimeTeachrUsagePilotBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessOneTimeTeacherUsagePilotBatch batch1 = new ProcessOneTimeTeacherUsagePilotBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}