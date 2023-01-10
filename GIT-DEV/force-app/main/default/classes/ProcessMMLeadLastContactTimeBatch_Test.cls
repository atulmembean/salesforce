@IsTest(SeeAllData=true)
public class ProcessMMLeadLastContactTimeBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      Lead l = [Select Id,Process_Massmailer__c from Lead order by CreatedDate DESC limit 1];
      l.Process_Massmailer__c = TRUE;
      update l;
      ProcessMMLeadLastContactTimeBatch batch1 = new ProcessMMLeadLastContactTimeBatch();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
}