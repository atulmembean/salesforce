@IsTest(SeeAllData=true)
public class UpdatePaypalInvoice_Test
{
    static testMethod void TestMethodone()
    {
      Test.startTest();
      List<Invoice__c> inv = [Select Id from Invoice__c where Paypal_Invoice_Id__c != '' AND Paypal_status__c != 'Paid' ORDER BY CreatedDate DESC LIMIT 1]; 
      if (inv.Size() > 0)
      {
          UpdatePaypalInvoice.updatePaypalInv(inv[0].Id);
      }
      Test.StopTest();
    }
}