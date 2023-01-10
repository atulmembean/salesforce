@IsTest(SeeAllData=true)
public class DedupncLeadstoContactsBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      DedupncLeadstoContactsBatch batch1 = new DedupncLeadstoContactsBatch();
      database.executebatch(batch1, 10);
      Test.stopTest();
  }
}