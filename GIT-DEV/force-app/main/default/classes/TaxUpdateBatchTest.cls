@istest
public class TaxUpdateBatchTest {
    static testMethod void setup(){
         Account acc = new Account(
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
          Tuition__c = 100,                                              
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
          BillingState='Georgia',
          BillingCountry='United States',
          Tax__c=15,
          No_of_Students__c = 20,
          recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Private School').getRecordTypeId()  
        );
        
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
           
        Product2 StudentProductObj = new Product2(
          Name = 'Students 101-300',
          Family = 'Students',        
          IsActive = true
            
        );
        
        insert StudentProductObj;
        
        Product2 TaxProductObj = new Product2(
          Name = 'Tax',
          Family = 'TAX',        
          IsActive = true
            
        );
        
        insert TaxProductObj;        
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = StudentProductObj.Id, UnitPrice = 13, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        
        standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = TaxProductObj.Id, UnitPrice = 1, IsActive = true, UseStandardPrice = false); 
        insert standardPrice;
        
        Pricebook2 pbook = new Pricebook2(
          Name = 'Public',
          IsActive = true  
        );
        
        insert pbook;
        
        Quote qu = new Quote();
        qu.Name = 'Test Quote';
        qu.OpportunityId = opp.Id;
        qu.Status = 'Draft';
        qu.Subscription_Start_Year__c = '2020';
        qu.Subscription_End_Year__c = '2021';
        qu.Pricebook2Id = pbook.Id;
        
        insert qu;
        
        PricebookEntry studentpbEntry = new PricebookEntry(
          Product2ID = StudentProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = [select Pricebook2Id from Quote order by CreatedDate DESC LIMIT 1].Pricebook2Id,  
          UnitPrice = 12.00,
          UseStandardPrice = false              
        );
        
        insert studentpbEntry;
        
        PricebookEntry taxpbEntry = new PricebookEntry(
          Product2ID = TaxProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = [select Pricebook2Id from Quote order by CreatedDate DESC LIMIT 1].Pricebook2Id,  
          UnitPrice = 1.00,
          UseStandardPrice = false              
        );
        
        insert taxpbEntry;
        
        List<QuoteLineItem> qlis = new List<QuoteLineItem>();
        Quote quo = [select id,Grand_Total_Yrs__c,Teacher_Rate__c,Student_Rate__c,Subscription_End_Year__c,Teacher_Count__c,Count_Quantity__c,Subscription_Start_Year__c,Status,OpportunityId,GrandTotal,RecordTypeId,Pricebook2Id from Quote order by CreatedDate DESC LIMIT 1];                
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
            
        }
        
        insert qlis;
        
        
        City_State_Mapping__c csm = new City_State_Mapping__c();
          csm.County__c='GWINNETT COUNTY';
          csm.State__c='Georgia'; 
          csm.Tax__c=10;
          csm.Type__c='Tax';
        csm.Add_tax_for_county__c= true;
        
        
        
        insert csm;
    
    Test.startTest();
     List<City_State_Mapping__c> city_stateList = new List<City_State_Mapping__c>();
    city_stateList.add(csm );
    TaxUpdateBatch batchObj = new TaxUpdateBatch('Georgia' );
    database.executebatch(batchObj);  
        Test.stopTest();    
    }


}