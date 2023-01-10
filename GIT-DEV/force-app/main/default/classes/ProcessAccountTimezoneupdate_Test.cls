@IsTest(SeeAllData=true)
public class ProcessAccountTimezoneupdate_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessAccountTimezoneupdate batch1 = new ProcessAccountTimezoneupdate();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}