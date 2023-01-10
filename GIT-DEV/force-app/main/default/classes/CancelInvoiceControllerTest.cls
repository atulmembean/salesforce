@isTest(SeeAllData=TRUE)
public class CancelInvoiceControllerTest {
        
    public static testmethod void testMethod1(){
        Test.StartTest();
        Invoice__c inv = [Select Id,Quote__c from Invoice__c where Paypal_Invoice_Id__c != Null AND Status__c ='Overdue' AND Balance_Due__c > 0 Order by CreatedDate DESC LIMIT 1];
        CancelInvoiceController.cancelQuoteInvoice(inv.id);
        Test.StopTest();
    }
    
     public static testmethod void testMethod2(){
        Test.StartTest();
        Invoice__c inv = [Select Id,Quote__c from Invoice__c where Paypal_Invoice_Id__c != Null AND Status__c = 'Closed' AND Balance_Due__c = 0 Order by CreatedDate DESC LIMIT 1];
        CancelInvoiceController.cancelQuoteInvoice(inv.id);
        Test.StopTest();
    }
}