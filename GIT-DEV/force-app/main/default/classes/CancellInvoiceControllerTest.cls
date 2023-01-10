@isTest
public class CancellInvoiceControllerTest {
    @testSetup
    public static void   setupTestData(){
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
        objOpportunity.Amount = 100;
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
        
        insert testPbe;
        Invoice__c objInvoice=new Invoice__c();
        objInvoice.Quote__C=objQuote.Id;
        objInvoice.Opportunity__c=objOpportunity.id;
        objInvoice.Status__c='Draft';
        insert objInvoice;
        QuoteLineItem qli = new QuoteLineItem(QuoteId = q.Id,Product2Id = testProduct.Id, PriceBookEntryId = testPbe.Id, Quantity = 1, UnitPrice = 100);
        insert qli;
    }
    public static testmethod void testMethod1(){
        Quote objQuote=[select id from quote where name='Test Quote'];
        CancelInvoiceController.cancelQuoteInvoice(objQuote.id);
    }
}