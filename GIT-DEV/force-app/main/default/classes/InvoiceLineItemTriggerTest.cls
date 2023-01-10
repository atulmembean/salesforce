@isTest(seeAllData=true)
public class InvoiceLineItemTriggerTest {

    static testMethod void validateInvoiceLineItemTrigger(){
        Invoice_Line_Item__c invli = [select Id from Invoice_Line_Item__c where Invoice__r.Paypal_Invoice_Id__c = NULL Limit 1];
        
        Test.startTest();
        update invli;
        Test.stopTest();
    }
}