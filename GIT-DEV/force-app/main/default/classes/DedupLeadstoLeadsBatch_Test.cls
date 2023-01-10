@IsTest(SeeAllData=true)
public class DedupLeadstoLeadsBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      DedupLeadstoLeadsBatch batch1 = new DedupLeadstoLeadsBatch();
      database.executebatch(batch1, 10);
      Test.stopTest();
  }
}