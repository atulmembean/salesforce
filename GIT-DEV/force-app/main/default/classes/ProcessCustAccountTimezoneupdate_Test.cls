@IsTest(SeeAllData=true)
public class ProcessCustAccountTimezoneupdate_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      ProcessCustAccountTimezoneupdate batch1 = new ProcessCustAccountTimezoneupdate();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}