@isTest(seeAllData=true)
public class QuoteLineItemTriggerTest {
    
    public static testmethod void setupTestData(){
        // Instantiate the Pricebook2 record first, setting the Id
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        // Run an update DML on the Pricebook2 record
        // This is the weird workaround that enables IsStandard to become true
        // on the PricebookEntry record
        update standardPricebook;
        
        // Re-Query for the Pricebook2 record, for debugging
        standardPricebook = [SELECT id,IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        
        // This should return true now
        system.assertEquals(true, standardPricebook.IsStandard, 'The Standard Pricebook should now return IsStandard = true');
        
        // Create the Product
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
        
        // Re-Query the PBE
        Account a = new Account(Name = 'Test Account',SubScription_Expiry_Month__c = 'August');
        insert a;
        
        Opportunity o = new Opportunity(Name = 'Test Opp',PriceBook2Id=standardPricebook.Id, StageName = 'Test Stage', CloseDate = Date.today(), AccountId = a.Id);
        insert o;        
        Quote q = new Quote(Name = 'Test Quote', OpportunityId = o.Id, PriceBook2Id = standardPricebook.Id);
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
        objInvoice.Opportunity__c=o.id;
        objInvoice.Status__c='Draft';
        insert objInvoice;
        QuoteLineItem qli = new QuoteLineItem(QuoteId = q.Id,Product2Id = testProduct.Id, PriceBookEntryId = testPbe.Id, Quantity = 1, UnitPrice = 100);
        insert qli;
        qli.quantity=2;
        update qli;
       delete objInvoice; 
        delete qli;
    }
}