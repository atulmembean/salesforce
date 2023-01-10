@isTest
public class InvoiceRefundControllerTest {
@testSetup
    public static void setupTestData(){
         Account objAccount=new Account();
        objAccount.name='test account';
        objAccount.Academic_End_Month__c='March';
        objAccount.AnnualRevenue=10000;
        objAccount.AnnualRevenue__C=10000;
        objAccount.Subscription_Expiry_Month__c='March';
        objAccount.Subscription_Years__c='2018;2019;2020';
        objAccount.No_of_Students__c=100;
        objAccount.No_of_Teachers__c=100;
        insert objAccount;
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name='test opp';
        objOpportunity.accountId=objAccount.Id;
        objOpportunity.stagename='Open';
        objOpportunity.Subscription_Start_Year__c = '2018';
        objOpportunity.Subscription_End_Year__c = '2020';
        objOpportunity.CloseDate = Date.today();
        objOpportunity.Amount=1000000;
        insert objOpportunity;
        Teachers_membean_usage__c objUsage=new Teachers_membean_usage__c();
        ObjUsage.Opportunity__c=objOpportunity.Id;
        objUsage.Teacher_count__c=100;
        insert objUsage;
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPricebook;
         Product2 testProduct = new Product2(
            Name = 'Test Product', 
            IsActive = true
        );
        insert testProduct;
        
        // Create the PricebookEntry
         PricebookEntry testPbe1 = new PricebookEntry(
            Pricebook2Id =standardPricebook.Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        
        insert testPbe1;
        
        
        
         Quote q = new Quote(Name = 'Test Quote', OpportunityId = objOpportunity.Id, PriceBook2Id = standardPricebook.Id); 
        insert q;
        Quote objQuote=[select id,PriceBook2Id from Quote where id=:q.Id];
        
        PricebookEntry testPbe = new PricebookEntry(
            Pricebook2Id = objQuote.PriceBook2Id,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        
        //insert testPbe;
        QuoteLineItem qli = new QuoteLineItem(QuoteId = q.Id,Product2Id = testProduct.Id, PriceBookEntryId = testPbe1.Id, Quantity = 1, UnitPrice = 100, Refund_Qty__c=1);
        insert qli;
        objQuote.Status='Accepted';
        update objQuote;
        Invoice__c objInvoice=new Invoice__c();
        objInvoice.Quote__C=objQuote.Id;
        objInvoice.Opportunity__c=objOpportunity.id;
        objInvoice.Status__c='Draft';
        insert objInvoice;
        Payment__c objPayment=new Payment__c();
        objPayment.Invoice__c=objInvoice.id;
        objpayment.Amount__c=100;
        objpayment.Payment_Date__c=System.today();
        objPayment.Payment_Mode__c='Check';
        
        insert objPayment;
        
    }
    public static testmethod void testPartialRefund(){
        Test.startTest();
       Quote objQuote=[select id from quote where name='Test Quote' order by createdDate asc limit 1];
        List<Invoice__c>lstInvoice=[select id,name from invoice__c where quote__c=:objQuote.Id];
        List<QuoteLIneItem>lstItem=InvoiceRefundController.fetchLilneItems(lstInvoice.get(0).Id);
        InvoiceRefundController.processPartialRefund(lstInvoice.get(0).Id, lstItem);
        Test.stoptest();
    }
    public static testmethod void testFullRefund(){
        Test.startTest();
        Quote objQuote=[select id from quote where name='Test Quote'  order by createdDate asc limit 1];
        List<Invoice__c>lstInvoice=[select id,name from invoice__c where quote__c=:objQuote.Id];
        InvoiceRefundController.processFullRefund(lstInvoice.get(0).Id);
        //InvoiceRefundControllerTest.setupTestData();
        Test.stopTest();
    }
}