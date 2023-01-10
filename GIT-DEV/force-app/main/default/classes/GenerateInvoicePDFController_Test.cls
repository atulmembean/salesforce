@isTest(SeeAllData=TRUE)
public class GenerateInvoicePDFController_Test {
    static testMethod void SingleYr() {
        PageReference pageRef = Page.GenerateInvoicePDF;
        Test.setCurrentPage(pageRef);
        Invoice__c InvObj = [Select Id from Invoice__c where Quote__r.No_Years__c = 1 and Quote__r.Status = 'Accepted' AND Quote__r.Total_Discounts__c < 0 order by CreatedDate DESC LIMIT 1];
        ApexPages.currentPage().getParameters().put('id',InvObj.id);
        Test.startTest();
         GenerateInvoicePDFController genPDF = new GenerateInvoicePDFController();
         GenerateInvoicePDFController.saveInvoicePdf(InvObj.id);
         GenerateInvoicePDFController.saveInvoicePdfLightning(InvObj.id);
         GenerateInvoicePDFController.getInvoiceValues();
        Test.stopTest();
    }
    static testMethod void MultiYr() {
        PageReference pageRef = Page.GenerateInvoicePDF;
        Test.setCurrentPage(pageRef);
        Invoice__c InvObj = [Select Id from Invoice__c where Quote__r.No_Years__c > 1 and Quote__r.Status = 'Accepted' AND Quote__r.Total_Discounts__c < 0 order by CreatedDate DESC LIMIT 1];
        ApexPages.currentPage().getParameters().put('id',InvObj.id);
        Test.startTest();
         GenerateInvoicePDFController genPDF = new GenerateInvoicePDFController();
         GenerateInvoicePDFController.saveInvoicePdf(InvObj.id);
         GenerateInvoicePDFController.saveInvoicePdfLightning(InvObj.id);
         GenerateInvoicePDFController.getInvoiceValues();
        Test.stopTest();
    }
}