@IsTest(SeeAllData=true)
public class ProcessPaymentRenewalOpptyBatch_Test
{
  static testMethod void TestMethod1()
  {
      Test.startTest();
      Payment__c p =  [Select Id,Create_Renewal_Oppty__c from Payment__c order by CreatedDate DESC LIMIT 1];
      p.Create_Renewal_Oppty__c = TRUE;
      update p;
      ProcessPaymentRenewalOpptyBatch batch1 = new ProcessPaymentRenewalOpptyBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
  static testMethod void TestMethod2()
  {
      Test.startTest();
      Payment__c p =  [Select Id,Create_Renewal_Oppty__c,Invoice__r.Quote__c from Payment__c order by CreatedDate DESC LIMIT 1];
      p.Create_Renewal_Oppty__c = TRUE;
      update p;
      Quote q = [Select Id,Renewal_Oppty_Created__c from Quote where ID  = :p.Invoice__r.Quote__c];
      q.Renewal_Oppty_Created__c = TRUE;
      update q;
      ProcessPaymentRenewalOpptyBatch batch1 = new ProcessPaymentRenewalOpptyBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
  static testMethod void TestMethod3()
  {
      Test.startTest();
      Payment__c p =  [Select Id,Create_Renewal_Oppty__c,Invoice__r.Quote__c,Invoice__c from Payment__c where invoice__r.Quote__r.Opportunity.Account.RecordType.Name != 'Tutoring' order by CreatedDate DESC LIMIT 1];
      p.Create_Renewal_Oppty__c = TRUE;
      update p;
      Invoice__c i = [Select Id,Renewal_Oppty_Created__c from Invoice__c where ID  = :p.Invoice__c];
      i.Renewal_Oppty_Created__c = FALSE;
      update i;
      Quote q = [Select Id,Renewal_Oppty_Created__c from Quote where ID  = :p.Invoice__r.Quote__c];
      q.Renewal_Oppty_Created__c = FALSE;
      update q;
      ProcessPaymentRenewalOpptyBatch batch1 = new ProcessPaymentRenewalOpptyBatch();
      database.executebatch(batch1, 5);
      Test.stopTest();
  }
  static testMethod void TestMethodPaypal()
  {
      Test.startTest();
      Payment__c p =  [Select Id,Create_Renewal_Oppty__c,Invoice__r.Quote__c,Invoice__c from Payment__c where Invoice__r.Paypal_Status__c = 'Sent' order by CreatedDate DESC LIMIT 2];
      if (p != Null)
      {
          p.Create_Renewal_Oppty__c = TRUE;
          update p;
          Quote q = [Select Id,Renewal_Oppty_Created__c from Quote where ID  = :p.Invoice__r.Quote__c];
          q.Renewal_Oppty_Created__c = FALSE;
          Invoice__c i = [Select Id,Renewal_Oppty_Created__c from Invoice__c where ID  = :p.Invoice__c];
          i.Renewal_Oppty_Created__c = FALSE;
          update i;
          ProcessPaymentRenewalOpptyBatch batch1 = new ProcessPaymentRenewalOpptyBatch();
          database.executebatch(batch1, 5);
      }
      Test.stopTest();
  }
}