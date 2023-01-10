@isTest(seeAllData=true)
public class ProductFamilyUpdateTest{
 public static testmethod void Productdata(){
  
  Account a = new Account(Name = 'Test Account');
        insert a;

        Opportunity o = new Opportunity(Name = 'Test Opp', StageName = 'Test Stage', CloseDate = Date.today(), AccountId = a.Id);
        insert o;
        Pricebook2 pb=[select id from Pricebook2 where isStandard=true];
        //Pricebook2 pb =new Pricebook2(Name='Standard Price Book 2009',Description ='Price Book 2009 Products',IsActive = true);
        //insert pb;
        Product2 p = new Product2(Name = 'Test Product',Family='Student', isActive = true);
        insert p;

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p.Id, UnitPrice = 1, isActive = true);
        insert pbe;

        Quote q = new Quote(Name = 'Test Quote', OpportunityId = o.Id, PriceBook2Id = pb.Id);
        insert q;

        QuoteLineItem qli = new QuoteLineItem(QuoteId = q.Id, PriceBookEntryId = pbe.Id, Quantity = 1, UnitPrice = 100);
        insert qli;
 
 }

}