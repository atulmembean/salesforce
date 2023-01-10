@IsTest(SeeAllData=true)
public class ProcessDistrictOpptyChildCount_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      Opportunity o = [Select id,Count_of_Child_Opportunities__c from Opportunity where (Probability > 0 AND Probability < 100) AND Count_of_Child_Opportunities__c > 0 order by CreatedDate DESC LIMIT 1];
      o.Count_of_Child_Opportunities__c = 23;
      update o;
      ProcessDistrictOpptyChildCount batch1 = new ProcessDistrictOpptyChildCount();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
}