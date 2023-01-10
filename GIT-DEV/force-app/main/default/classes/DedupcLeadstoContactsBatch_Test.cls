@IsTest(SeeAllData=true)
public class DedupcLeadstoContactsBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      DedupcLeadstoContactsBatch batch1 = new DedupcLeadstoContactsBatch();
      database.executebatch(batch1, 10);
      Test.stopTest();
  }
}