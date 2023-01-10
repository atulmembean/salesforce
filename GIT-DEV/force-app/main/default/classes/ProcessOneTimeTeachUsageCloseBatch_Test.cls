@IsTest(SeeAllData=true)
public class ProcessOneTimeTeachUsageCloseBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessOneTimeTeacherUsageCloseBatch batch1 = new ProcessOneTimeTeacherUsageCloseBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}