/**********************
Developed by Lattice CRM - March 2020
***********************/

@isTest
public class createRenewalOpptyInvocable_June2021Test {
    static Opportunity sobj ;
    static Invoice__c InvObj;
    static Invoice__c InvObj2;
    static List<Invoice_Line_Item__c> invoiceLineItems;
    static Opportunity sobjChild1 ;
    static Opportunity sobjChild2 ;
    static Quote QObj;
    static Quote QObj2;
    static Split_School_Detail__c ssd;
    static contact c1;
    static Product2 StudentProductObj;
    String ProdName = '';
    
    
    @testsetup static void setup()
    {
               
        Account acc = new Account();
        acc.Name = 'Test School';
        acc.Low_Grade__c = 'K';
        acc.High_Grade__c = 'T';
        acc.Subscription_Expiry_Month__c = 'August';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('District').getRecordTypeId();
        acc.Subscription_Years__c = '2019;2020';
        insert acc;
                        
        Contact c = new Contact();
        c.FirstName = 'Shantanu';
        c.LastName = 'Kumar';
        c.AccountId = acc.Id;
        
        insert c;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunitiy';
        opp.Type = 'Regular';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today();
        opp.Subscription_Start_Year__c = '2019';
        opp.Subscription_End_Year__c = '2020';
        opp.AccountId = acc.Id;
        opp.Teacher__c = c.Id;
        
        insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opportunitiy Child';
        opp1.Type = 'Regular';
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        opp1.StageName = 'Prospecting';
        opp1.CloseDate = Date.today();
        opp1.Subscription_Start_Year__c = '2019';
        opp1.Subscription_End_Year__c = '2020';
        opp1.AccountId = acc.Id;
        opp1.Teacher__c = c.Id;
        opp1.Parent_Opportunity__c = opp.Id;
        insert opp1;
           
        Product2 StudentProductObj = new Product2(
          Name = 'Students 101-300',
          Family = 'Students',        
          IsActive = true
            
        );
        
        insert StudentProductObj;
        
        Product2 AnnualProductObj = new Product2(
          Name = 'Annual Discount',
          Family = 'Students',        
          IsActive = true
            
        );
        
        insert AnnualProductObj;        
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = StudentProductObj.Id, UnitPrice = 13, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        
        standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = AnnualProductObj.Id, UnitPrice = 1, IsActive = true, UseStandardPrice = false); 
        insert standardPrice;
        
        Pricebook2 pbook = new Pricebook2(
          Name = 'Public',
          IsActive = true  
        );
        
        insert pbook;
        
        Quote qu = new Quote();
        qu.Name = 'Test Quote';
        qu.OpportunityId = opp.Id;
        qu.Status = 'Sent';
        qu.Subscription_Start_Year__c = '2020';
        qu.Subscription_End_Year__c = '2021';
        qu.Pricebook2Id = pbook.Id;
        
        insert qu;
        
        PricebookEntry studentpbEntry = new PricebookEntry(
          Product2ID = StudentProductObj.id,  
          IsActive = true,                 
          //Pricebook2Id = [select Pricebook2Id from Quote where Name= 'Test Quote'].Pricebook2Id,
          Pricebook2Id = [select Pricebook2Id from Quote where Id= :qu.Id].Pricebook2Id,  
          UnitPrice = 12.00,
          UseStandardPrice = false              
        );
        
        insert studentpbEntry;
        
        PricebookEntry annualpbEntry = new PricebookEntry(
          Product2ID = AnnualProductObj.id,  
          IsActive = true,                 
          //Pricebook2Id = [select Pricebook2Id from Quote where Name= 'Test Quote'].Pricebook2Id, 
          Pricebook2Id = [select Pricebook2Id from Quote where Id= :qu.Id].Pricebook2Id, 
          UnitPrice = 1.00,
          UseStandardPrice = false              
        );
        
        insert annualpbEntry;
               
        Invoice__c inv = new Invoice__c();
        inv.Subscription_Month__c = 6;
        inv.Subscription_Expiry_Month__c = 'August';
        inv.Date__c = Date.today();
        inv.Due_Date__c = Date.today().addDays(30);
        inv.Subscription_Start_Date__c = Date.today();
        inv.Quote__c = qu.Id;
        inv.Accountname_relatedlist__c = acc.Id;
        inv.Account_of_Contact__c = acc.Id;
        inv.Account__c = acc.id;
        inv.Contact__c = c.Id;
        inv.STatus__c = 'Sent';
        insert inv;
        
        
        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        Quote quo = [select id,Grand_Total_Yrs__c,Teacher_Rate__c,Student_Rate__c,Subscription_End_Year__c,Teacher_Count__c,Count_Quantity__c,Subscription_Start_Year__c,Status,OpportunityId,GrandTotal,RecordTypeId,Pricebook2Id from Quote where Id = :qu.Id];                
        String Id = quo.Pricebook2Id;
        List<PricebookEntry> pbe = [select Id,Product2ID,Pricebook2Id,Product2.Name from PricebookEntry where Pricebook2Id =:Id];   
        
        for(PricebookEntry p:pbe){
            
            qlis.add(new QuoteLineItem(
                Product2Id = p.Product2ID,  
                PricebookEntryId = p.Id,
                QuoteId = quo.id,             
                UnitPrice = 13.00,             
                Quantity = 50              
            ));
            
            if(p.Product2.Name.CONTAINS('Annual')){
                qlis[qlis.size()-1].Commitment_Duration__c = '3';
            }
        }
        
        insert qlis;
        quo.Status = 'Accepted';
        update quo;
        
    }
    
    @isTest
    static void testmethodGroupedOpptyPayment(){
        Test.startTest();
                
        InvObj = [Select Id,Quote__c,Quote__r.Name,Quote__r.Opportunity.AccountId,Quote__r.Opportunity.Account.RecordType.Name from Invoice__c where Status__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'January';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;

        Test.stopTest();
    }
    
    
    @isTest
    static void testmethodJan(){
        Test.startTest();
                
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'January';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;

        Test.stopTest();
    }
    
    @isTest
    static void testmethodFeb(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];        
       
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'February';
        update AccountObj;
        
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
                
        Test.stopTest();
    }
    
    @isTest
    static void testmethodMar(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];        
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'March';
        update AccountObj;
        
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
                 
        Test.stopTest();
    }
    
    @isTest
    static void testmethodApr(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'April';
        update AccountObj;
        
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
                 
        Test.stopTest();
    }
    
    @isTest
    static void testmethodMay(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c = 'May';
        update AccountObj;
        
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
                
        Test.stopTest();
        
    }
    
    @isTest
    static void testmethodJune(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c = 'June';
        update AccountObj;
        
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;                     
        
        Test.stopTest();
    }
    
    
    @isTest
    static void testmethodJul(){
        Test.startTest();
                
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'July';
        update AccountObj;

        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
                 
        Test.stopTest();
    }
    
    @isTest
    static void testmethodAug(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c = 'August';
        update AccountObj;
        
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    
    @isTest
    static void testmethodSep(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'September';
        update AccountObj;

        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
         
        Test.stopTest();
    }
    
    @isTest
    static void testmethodOct(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'October';
        update AccountObj;

        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
         
        Test.stopTest();
    }
    
    @isTest
    static void testmethodNov(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'November';
        update AccountObj;

        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
         
        Test.stopTest();
    }
    
    @isTest
    static void testmethodDec(){
        Test.startTest();
        
        InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c = 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];
        List<QuoteLineItem> qlilst = [Select Id, Commitment_Duration__c,Product2.Name from QuoteLineItem where QuoteId = :InvObj.Quote__c];        
        
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'December';
        update AccountObj;

        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
                 
        Test.stopTest();
    }
    
    /*@isTest (SEEALLDATA=TRUE)
    static void testmethodCommitmentOppty(){
        Test.startTest();
        
        QuoteLineItem qli = [Select Id, QuoteId,Commitment_Duration__c from QuoteLineItem where Product2.Name LIKE '%Annual%' AND Quote.Status IN ('Sent','Draft') Order by CreatedDate DESC LIMIT 1];
        Quote q = [Select Id, OpportunityId from Quote where Id = :qli.QuoteId LIMIT 1];
                
        Opportunity o = [Select Id, zDiscountAnnual__c,Commitment_Duration__c,Teacher__c from Opportunity where Id = :q.OpportunityId LIMIT 1];
        OpportunityContactRole ocr = New OpportunityContactRole();
        ocr.ContactId = o.Teacher__c;
        ocr.OpportunityId =  o.Id;
        ocr.Role = 'Decision Maker';
        insert ocr;
        
        q.Status = 'Accepted';
        update q;
         
        Test.stopTest();
    }*/
    
    
    
}