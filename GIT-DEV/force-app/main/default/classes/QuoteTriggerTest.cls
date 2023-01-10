/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class QuoteTriggerTest {
    
    public static list<Quote> quoteListAll = new List<quote>();
    @testSetup 
     static void setupDataForQuoteAndTask(){
        initializeTriggerParams();
        Account AccountObj = new Account(
          Name = 'Test Account',    
          IsActive__c = true,                           
          Type_of_School__c = 'Middle School',                         
          Category__c = 'School',                                     
          Low_Grade__c = '6',                                          
          High_Grade__c = '8',                                        
          Source__c = 'District - Email Blast',                        
          NCES_School_ID__c = '130255000000',                         
          Title_1_School_Wide__c = false,                              
          State_School_ID__c = '4058',                                 
          Title_1_School__c = false,                                  
          Population__c = 1172,                                       
          County_Name__c = 'GWINNETT COUNTY',                          
          Tuition__c =100,                                              
          Student_Teacher_Ratio__c = 14,                              
          Charter__c = false,                                          
          Locale_Code__c = 21,                                         
          Magnet__c = false,                                           
          Free_Lunch__c = 0,                                           
          Zip_4_digit__c = '4223',                                    
          Teacher_Count__c = 81,                                       
          Used_before_2013__c = false, 
          Academic_End_Month__c='April',  
          Students__c = 1172,
          BillingCountry='United States',
          No_of_Students__c = 20,
          recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Private School').getRecordTypeId(),
          Tax__c=10  
        );
        initializeTriggerParams();
        insert AccountObj;
        
        Contact con=new Contact();
        con.lastname='dddd';
        con.AccountId=AccountObj.Id;
        initializeTriggerParams();
        insert con;
        
        Pricebook2 sobjPricebook1 = new Pricebook2(
          Name = 'Private_1',
          IsActive = true  
        );
        initializeTriggerParams();
        insert sobjPricebook1;
        
        Opportunity ParentOppObj = new Opportunity(
          Name = 'Grouped-',                   
          StageName = 'Promising',                     
          AccountID = AccountObj.id, 
          pricebook2Id = sobjPricebook1.id,          
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+2),     
          CloseDate = System.today().addDays(20),   
          Amount = 25000,        
          Probability = 100,                     
          No_of_Students__c = 0,                 
          No_of_Teachers__c = 10,
          Teacher__c=con.id,
          recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId()                
        );
        initializeTriggerParams();
        insert ParentOppObj;
        Opportunity sobj1 = new Opportunity(
          Name = 'Grouped- - BANKS COUNTY ELEMENTARY SCHOOL - 2025-26',
          StageName = 'Interested', 
          AccountID = AccountObj.id,                                  
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()), 
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+1),                             
          CloseDate = System.today().addDays(20),                          
          Parent_Opportunity__c = ParentOppObj.id,                     
          No_of_Students__c = 0,                                         
          No_of_Teachers__c = 0,                                         
          Probability = 100,
          Teacher__c=con.id,
          recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId()                           
        );
        initializeTriggerParams();
        insert sobj1;
        Opportunity sobj2 = new Opportunity(
          Name = 'Grouped- - BANKS COUNTY ELEMENTARY SCHOOL - 2026-27',
          StageName = 'Interested', 
          AccountID = AccountObj.id,                                  
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()+1),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+2),                             
          CloseDate = System.today().addDays(20),                         
          Parent_Opportunity__c = ParentOppObj.id,                     
          No_of_Students__c = 0,                                         
          No_of_Teachers__c = 0,                                         
          Probability = 100,
          Teacher__c=con.id,
          recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId()                            
        );
        initializeTriggerParams();
        insert sobj2;
        Opportunity sobj3 = new Opportunity(
          Name = 'Grouped- - BANKS COUNTY HIGH SCHOOL - 2025-26',
          StageName = 'Interested',
          AccountID = AccountObj.id,                                   
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+1),                             
          CloseDate = System.today().addDays(20),                           
          Parent_Opportunity__c = ParentOppObj.id,                     
          No_of_Students__c = 0,                                         
          No_of_Teachers__c = 0,                                         
          Probability = 100,
          Teacher__c=con.id,
          recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId()                           
        );
        initializeTriggerParams();
        
        Pricebook2 sobjPricebook2 = new Pricebook2(
          Name = 'Public',
          IsActive = true  
        );
        initializeTriggerParams();
        insert sobjPricebook2;
         
        Opportunity sobj4 = new Opportunity(
          Name = 'Grouped- - BANKS COUNTY HIGH SCHOOL - 2026-27',
          StageName = 'Interested', 
          AccountID = AccountObj.id,                                  
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()+1),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+2),                             
          CloseDate = System.today().addDays(20),                          
          Parent_Opportunity__c = ParentOppObj.id,                     
          No_of_Students__c = 0,                                         
          No_of_Teachers__c = 0,                                         
          Probability = 100,
          Teacher__c=con.id,
          recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId(),
          pricebook2Id = sobjPricebook2.Id  
        );
        initializeTriggerParams();
        insert sobj4;
        
        Pricebook2 customPriceBookobj = new Pricebook2(
          Name = 'Custom Price Book',
          IsActive = true             
        );
        initializeTriggerParams();
        insert customPriceBookobj;
         
        Pricebook2 customPriceBookobjTeacher = new Pricebook2(
          Name = 'Custom Price Book for teachers',
          IsActive = true             
        );
        initializeTriggerParams();
        insert customPriceBookobjTeacher; 
         
        Product2 StudentProductObj = new Product2(
          Name = 'Students 101-300',
           Family='Student Subscriptions',
          //Family = 'Students',        
          IsActive = true
            
        );
        initializeTriggerParams();
        insert StudentProductObj;
        
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = StudentProductObj.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false); 
        
        insert standardPrice;
         
        Product2 TeachersProductObj = new Product2(
          Name = 'Teachers',
          Family = 'Teachers',        
          IsActive = true           
        );
        initializeTriggerParams();
        insert TeachersProductObj;
         
        standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = TeachersProductObj.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false); 
        
        insert standardPrice;
         
        Product2 TaxProductObj = new Product2(
          Name = 'Tax',
          Family = 'TAX',        
          IsActive = true           
        );
        initializeTriggerParams();
        insert TaxProductObj; 
         
        standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = TaxProductObj.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);  
        insert standardPrice;        
         
        PricebookEntry CustomPBEsobj2 = new PricebookEntry(
          Product2ID = TeachersProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = customPriceBookobjTeacher.Id,  
          UnitPrice = 15.00,
          UseStandardPrice = false  
        );
        initializeTriggerParams();
        insert CustomPBEsobj2;
        
        PricebookEntry sobjPBE1 = new PricebookEntry(
          Product2ID = StudentProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = sobjPricebook1.id, 
          UnitPrice = 20.00,               
          UseStandardPrice = false       
        );
        initializeTriggerParams();
        insert sobjPBE1;
        
        PricebookEntry sobjPBE2 = new PricebookEntry(
          Product2ID = TeachersProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = sobjPricebook2.id, 
          UnitPrice = 20.00,               
          UseStandardPrice = false      
        );
        initializeTriggerParams();
        insert sobjPBE2;
        
        Quote QObj = new Quote(
          Name = 'Grouped_two',           
          OpportunityId = ParentOppObj.id,  
          Status = 'Draft' ,
          Pricebook2Id = customPriceBookobj.Id             
        );

        initializeTriggerParams();
        insert QObj;
             
         
        quoteListAll.add(QObj);   
        
        Id pbId = [select Pricebook2Id from Quote where Name= 'Grouped_two'].Pricebook2Id;
         
         
        PricebookEntry CustomPBEsobj1 = new PricebookEntry(
          Product2ID = StudentProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = pbId,  
          UnitPrice = 15.00,
          UseStandardPrice = false              
        );
        initializeTriggerParams();
        insert CustomPBEsobj1; 
         
        PricebookEntry TaxPBEsobj = new PricebookEntry(
          Product2ID = TaxProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = pbId,  
          UnitPrice = 15.00,
          UseStandardPrice = false  
        );
        initializeTriggerParams();
        insert TaxPBEsobj;  
                          
        Quote QObj1 = new Quote(
          Name = 'Grouped_one',           
          OpportunityId = ParentOppObj.id,  
          Status = 'Draft', 
          Pricebook2Id = sobjPricebook2.Id             
        );
        initializeTriggerParams();
        insert QObj1;
        //added
        Quote QObj2 = new Quote(
          Name = 'Grouped_one',           
          OpportunityId = ParentOppObj.id,  
          Status = 'Draft', 
          Pricebook2Id = sobjPricebook2.Id             
        );
        initializeTriggerParams();
        //insert QObj2;              
         
        quoteListAll.add(QObj1);
        quoteListAll.add(QObj2);

         //upsert quoteListAll;   
        QuoteTriggerHandler q = new QuoteTriggerHandler();

         //added ends
        Split_School_Detail__c ssd=new Split_School_Detail__c(Name='Test',Quote_Name__c=QObj1.id,Opportunity_Name__c=sobj4.id
        );
        initializeTriggerParams();
        insert ssd;
         
        
        List<Id> qid =  new List<Id>();
        List<Id> oppIds=  new List<Id>();
        qid.add(QObj1.id);
        qid.add(QObj2.id);
        oppIds.add(ParentOppObj.id);       
    }
    static void initializeTriggerParams() {
        OpportunityService.runAfterTriggerCount = 0;
        OpportunityService.runAfterTrigger = true;
        OpportunityService.runBeforeTrigger=true;
  
    }
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        initializeTriggerParams();
    }
     
     
    static testMethod void validateDiscountAmount(){

        QuoteTriggerHandler q = new QuoteTriggerHandler();

        Test.startTest();
        q.discountAmount(quoteListAll);
        Test.stopTest();
    }
    
    static testMethod void validateUpdateAllOtherQuotesWhenAnyQuoteIsAccepted(){
        
        Test.startTest();
        List<Quote> quo = [select Id,status from Quote where Name = 'Grouped_one'];
        
        List<Id> qid =  new List<Id>();
        List<Id> oppIds=  new List<Id>();
        QuoteTriggerHandler q = new QuoteTriggerHandler();
        
        for(Quote qu:quo){
            qid.add(qu.Id);
            
        }
        Id oppId = [select Id from Opportunity where StageName = 'Promising'].Id;
        oppIds.add(oppId);
        q.updateAllOtherQuotesWhenAnyQuoteIsAccepted(qid,oppIds);
        QuoteTriggerHandler.UpdateOppOnQuoteAccept(new Set<Id>{qId.get(0)});
        Test.stopTest();
    }
    
    static testMethod void validateUpdateSchoolDetails(){

        Test.startTest();
        Quote Qobj = [select Id,status from Quote where Name = 'Grouped_two'];
        Qobj.status = 'Accepted';
        List<Quote> Qo = [select Id,status from Quote where Name = 'Grouped_one'];
        
        Qo[0].status = 'Accepted';
        //Qo[1].status = 'Presented';
        
        update Qo;
        update Qobj;
        Qobj.status = 'Rejected';
        Qobj.recordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Rejected').getRecordTypeId();
        update Qobj;
        Test.stopTest();
    } 
    
    static testMethod void validateActivityLogUpdate(){
        
        List<String> statusList = new List<String>{'Accepted'};
        
 
        Test.startTest();
        Quote qu = [select id,Grand_Total_Yrs__c,Teacher_Rate__c,Student_Rate__c,Subscription_End_Year__c,Teacher_Count__c,Count_Quantity__c,Subscription_Start_Year__c,Status,OpportunityId,GrandTotal,RecordTypeId,Pricebook2Id from Quote where Status Not IN:statusList and Name = 'Grouped_two' order by createdDate limit 1];        
        
        PricebookEntry pbe = [select Id,Product2ID,Pricebook2Id from PricebookEntry where Pricebook2Id =:qu.Pricebook2Id limit 1];
        
        QuoteLineItem QLIobj1 = new QuoteLineItem(
          Product2Id = pbe.Product2ID,  
          PricebookEntryId = pbe.id,
          QuoteId = qu.id,             
          UnitPrice = 13.00,             
          Quantity = 50              
        );
        
        insert QLIobj1;   
         Product2 StudentProductObj = new Product2(
          Name = 'Students 101-300',
           Family='Student Subscriptions',
          //Family = 'Students',        
          IsActive = true
            
        );
        insert StudentProductObj;
         PricebookEntry pbe2=new PricebookEntry();
        pbe2.Pricebook2Id=Test.getStandardPricebookId();
        pbe2.Product2Id=StudentProductObj.Id;
        pbe2.unitPrice=200;
        pbe2.isActive=true;
        insert pbe2;
        
        PricebookEntry pbe1=new PricebookEntry();
        pbe1.Pricebook2Id=pbe.PriceBook2Id;
        pbe1.Product2Id=StudentProductObj.Id;
        pbe1.unitPrice=200;
        pbe1.isActive=true;
        insert pbe1;
        
        QuoteLineItem QLIobj2 = new QuoteLineItem(
          Product2Id = StudentProductObj.Id,  
          PricebookEntryId = pbe1.id,
          QuoteId = qu.id,             
          UnitPrice = 13.00,             
          Quantity = 50              
        );
        insert QLIobj2;
        
        qu.Status = 'Presented';
        //qu.Count_Quantity__c=10;
        update qu;
          qu.status=Constants.QUOTE_STATUS_ACCEPTED;
        qu.recordTypeId=Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Constants.QUOTE_RECORDTYPE_NAME_REJECTED).getRecordTypeId();
        update qu;
        qu.status='Rejected';
       // update qu;
        Test.stopTest();
    }
    public static testMethod void testMethod1(){
        Test.startTest();
        Quote qu = [select id,Grand_Total_Yrs__c,Teacher_Rate__c,Student_Rate__c,Subscription_End_Year__c,Teacher_Count__c,Count_Quantity__c,Subscription_Start_Year__c,Status,OpportunityId,GrandTotal,RecordTypeId,Pricebook2Id from Quote where  Name = 'Grouped_two' order by createdDate limit 1];        
        	qu.status='Accepted';
        	update qu;
        	qu.status='Rejected';
        	update qu;
        Test.stopTest();
    }
    
    static testMethod void validateQuoteAmountChange(){
        Test.startTest();
        Quote qu = [select id,Grand_Total_Yrs__c,Teacher_Rate__c,Student_Rate__c,Subscription_End_Year__c,Teacher_Count__c,Count_Quantity__c,Subscription_Start_Year__c,Status,OpportunityId,GrandTotal,RecordTypeId,Pricebook2Id from Quote where Name = 'Grouped_two' order by createdDate limit 1];        
        
        List<PricebookEntry> pbe = [select Id,Product2ID,Pricebook2Id from PricebookEntry where Pricebook2Id =:qu.Pricebook2Id];
        
        QuoteLineItem QLIobj1 = new QuoteLineItem(
          Product2Id = pbe[0].Product2ID,  
          PricebookEntryId = pbe[0].id,
          QuoteId = qu.id,             
          UnitPrice = 13.00,             
          Quantity = 50              
        );
        
        insert QLIobj1;
        
        QuoteLineItem QLIobj2 = new QuoteLineItem(
          Product2Id = pbe[1].Product2ID,  
          PricebookEntryId = pbe[1].id,
          QuoteId = qu.id,             
          UnitPrice = 13.00,             
          Quantity = 50              
        );
        
        insert QLIobj2;
        
        Test.stopTest(); 
    }
    
}