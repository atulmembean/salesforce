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
private class SplitSchoolDetailsControllerTest {
    
    static Opportunity sobj ;
    static Opportunity sobjChild1 ;
    static Opportunity sobjChild2 ;
    static Quote QObj;
    static Split_School_Detail__c ssd;
    static contact c1;
    static Product2 StudentProductObj;
    static Invoice__c InvObj;
    static List<Invoice_Line_Item__c> invoiceLineItems;
    @testSetup 
    static void setupDataForController(){
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
          Tuition__c = 0,                                              
          Student_Teacher_Ratio__c = 14,                               
          Charter__c = false,                                          
          Locale_Code__c = 21,                                         
          Magnet__c = false,                                           
          Free_Lunch__c = 0,                                           
          Zip_4_digit__c = '4223',                                    
          Teacher_Count__c = 81,                                       
          Used_before_2013__c = false,                                 
          Students__c = 1172,
          Academic_End_Month__c = 'July',
          Subscription_Expiry_Month__c='August'
        );
        insert AccountObj;
        system.debug('@@AccountObj'+AccountObj);
        Account AccountObjChild1 = new Account(
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
          Tuition__c = 0,                                              
          Student_Teacher_Ratio__c = 14,                               
          Charter__c = false,                                          
          Locale_Code__c = 21,                                         
          Magnet__c = false,                                           
          Free_Lunch__c = 0,                                           
          Zip_4_digit__c = '4223',                                    
          Teacher_Count__c = 81,                                       
          Used_before_2013__c = false,                                 
          Students__c = 1172,
          Academic_End_Month__c = 'July'
        );
        insert AccountObjChild1;
        system.debug('@@AccountObjChild1'+AccountObjChild1);
        Account AccountObjChild2 = new Account(
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
          Tuition__c = 0,                                              
          Student_Teacher_Ratio__c = 14,                               
          Charter__c = false,                                          
          Locale_Code__c = 21,                                         
          Magnet__c = false,                                           
          Free_Lunch__c = 0,                                           
          Zip_4_digit__c = '4223',                                    
          Teacher_Count__c = 81,                                       
          Used_before_2013__c = false,                                 
          Students__c = 1172,
          Academic_End_Month__c = 'July'
        );
        insert AccountObjChild2;
        system.debug('@@AccountObjChild2'+AccountObjChild2);
        c1= new contact();
        c1.LastName='ABC test';
        c1.AccountId=AccountObj.id;
        insert c1;
        system.debug('@@c1'+c1);
        sobj = new Opportunity(
          Name = 'AgencyBangalore-1',                     
          CloseDate = System.today().addDays(20),            
          StageName = 'Prospecting',                             
          Probability = 10,
          AccountID = AccountObj.id,                                   
          Pilot_End_Date__c = System.today().addDays(15),
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+2),   
          No_of_Teachers__c = 50,                       
          No_of_Students__c = 100,
          Teacher__c =c1.Id
        );
        insert sobj;
        system.debug('@@sobj'+sobj);
        sobjChild1 = new Opportunity(
          Name = 'Child1',
          CloseDate = System.today().addDays(20),
          StageName = 'Prospecting', 
          AccountID = AccountObjChild1.id, 
          Parent_Opportunity__c = sobj.id,                            
          Probability = 10, 
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+1),
          No_of_Teachers__c = 25,                       
          No_of_Students__c = 50,
          Teacher__c =c1.Id,
          Student_Pay__c = TRUE
        );
        insert sobjChild1;
        system.debug('@@sobjChild1'+sobjChild1);
        sobjChild2 = new Opportunity(
          Name = 'Child2',
          CloseDate = System.today().addDays(20),
          StageName = 'Prospecting',
          AccountID = AccountObjChild2.id,
          Parent_Opportunity__c = sobj.id,                            
          Probability = 10,
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()+1),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+2),     
          No_of_Teachers__c = 25,                       
          No_of_Students__c = 50,
          Teacher__c =c1.Id
        );
        insert sobjChild2;
        system.debug('@@sobjChild2'+sobjChild2);
        
        Pricebook2 sobjPricebook1 = new Pricebook2(
          Name = 'Private_1',
          IsActive = true  
        );
        insert sobjPricebook1;
        system.debug('@@sobjPricebook1'+sobjPricebook1);
        
        Pricebook2 sobjPricebook2 = new Pricebook2(
          Name = 'Public',
          IsActive = true  
        );
        insert sobjPricebook2;
        system.debug('@@sobjPricebook2'+sobjPricebook2);
        
        Pricebook2 standardPriceBookobj = new Pricebook2(
          Name = 'Standard Price Book',
          IsActive = true             
        );
        
        insert standardPriceBookobj;
        system.debug('@@standardPriceBookobj'+standardPriceBookobj);
        StudentProductObj = new Product2(
          Name = 'Students 101-300',
          Family = 'Students',        
          IsActive = true           
        );
        insert StudentProductObj;
        system.debug('@@StudentProductObj'+StudentProductObj);
        Product2 TeachersProductObj = new Product2(
          Name = 'Teachers',
          Family = 'Teachers',        
          IsActive = true           
        );
        insert TeachersProductObj;
        system.debug('@@TeachersProductObj'+TeachersProductObj);
        
        PricebookEntry StatndardPBEsobj1 = new PricebookEntry(
          Product2ID = StudentProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = Test.getStandardPricebookId(),  
          UnitPrice = 15.00
        );
        insert StatndardPBEsobj1;
        system.debug('@@StatndardPBEsobj1'+StatndardPBEsobj1);
        
        PricebookEntry StatndardPBEsobj2 = new PricebookEntry(
          Product2ID = TeachersProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = Test.getStandardPricebookId(),  
          UnitPrice = 15.00
        );
        insert StatndardPBEsobj2;
        system.debug('@@StatndardPBEsobj2'+StatndardPBEsobj2);
        
        PricebookEntry sobjPBE1 = new PricebookEntry(
          Product2ID = StudentProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = sobjPricebook1.id, 
          UnitPrice = 20.00,               
          UseStandardPrice = false       
        );
        insert sobjPBE1;
        system.debug('@@sobjPBE1'+sobjPBE1);
        
        PricebookEntry sobjPBE2 = new PricebookEntry(
          Product2ID = TeachersProductObj.id,  
          IsActive = true,                 
          Pricebook2Id = sobjPricebook2.id, 
          UnitPrice = 20.00,               
          UseStandardPrice = false      
        );
        insert sobjPBE2;
        system.debug('@@sobjPBE2'+sobjPBE2);
        
        QObj = new Quote(
          Name = 'Grouped_two',           
          OpportunityId = sobj.id,  
          Status = 'Draft' 
          //Pricebook2Id = Test.getStandardPricebookId()             
        );
        insert QObj;
          ssd=new Split_School_Detail__c(Name='Test',Quote_Name__c=QObj.id,Opportunity_Name__c=sobjChild2.id
        );
        insert ssd;
        QuoteLineItem QLIobj1 = new QuoteLineItem(
            Product2Id = StudentProductObj.id,
            PricebookEntryId = StatndardPBEsobj1.id,
            //  PricebookEntryId = Test.getStandardPricebookId(),
            QuoteId = QObj.id,             
            UnitPrice = 13.00,             
            Quantity = 50              
        );
        //insert QLIobj1;
        QuoteLineItem QLIobj2 = new QuoteLineItem(
          Product2ID = TeachersProductObj.id, 
          PricebookEntryId = StatndardPBEsobj2.id, 
          QuoteId = QObj.id,             
          UnitPrice = 13.00,             
          Quantity = 20              
        );
       // insert QLIobj2; 
        /*Quote QObj1 = new Quote(
          Name = 'Grouped_one',           
          OpportunityId = sobj.id,  
          Status = 'Draft',
          //Subscription_Start_Year__c = '2020',
          //Subscription_End_Year__c = '2021',
          Pricebook2Id = Test.getStandardPricebookId()             
        );
        insert QObj1;*/
        
       /* QuoteLineItem QLIobj11 = new QuoteLineItem(
          Product2Id = StudentProductObj.id, 
          PricebookEntryId =  StatndardPBEsobj1.id,
          QuoteId = QObj1.id,             
          UnitPrice = 13.00,             
          Quantity = 30              
        );*/
        //insert QLIobj11;
        /*QuoteLineItem QLIobj22 = new QuoteLineItem(
          Product2Id = TeachersProductObj.id,  
          PricebookEntryId = StatndardPBEsobj2.id ,
          QuoteId = QObj1.id,             
          UnitPrice = 13.00,             
          Quantity = 10              
        );*/
        //insert QLIobj22;
        
        /*Updating any Quote to accepted and then Rejected */
        QObj.status = 'Accepted';
       // update QObj;  //commented this for there was a flow error.
       
      // List<Invoice__c> invLst = new List<Invoice__c>();
         InvObj = new Invoice__c();
       // InvObj.Name='INV-123';
        InvObj.Contact__c=c1.id;
        InvObj.Date__c=system.today();
        InvObj.P_O_Number__c='58568';
        InvObj.Quote__c=QObj.id;
        InvObj.Payment_Terms__c='Net-30';
       // invLst.add(InvObj);
        insert InvObj;
        
       // List<Invoice_Line_Item__c> invLItemLst = new List<Invoice_Line_Item__c>();
        Invoice_Line_Item__c Inv1 = new Invoice_Line_Item__c();
        Inv1.Amount__c=2000;
        Inv1.Invoice__c=InvObj.id;
        Inv1.Quantity__c=16;
        //invLItemLst.add(Inv1);
        insert Inv1;
        
        invoiceLineItems = new List<Invoice_Line_Item__c>();
		invoiceLineItems.add(Inv1);
         
    }
    static testMethod void myUnitTestForGroupedMultiyearRecordType() {
        setupDataForController();
        sobj.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        //sobj.stageName = 'Won';
        update sobj;
        PageReference pageRef = Page.SplitSchoolDetails_v1;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',QObj.id);
        List<Split_School_Detail__c> ssdList = new List<Split_School_Detail__c>();
        ssdList.add(ssd);
        //oppList.add(sobjChild2);
        Test.startTest();
            SplitSchoolDetailsController_v1 splitSchoolDetailsObj = new SplitSchoolDetailsController_v1();
            SplitSchoolDetailsController_v1.getParentOpp();
            SplitSchoolDetailsController_v1.getChildOpps();
            SplitSchoolDetailsController_v1.getMapVAlues();
            SplitSchoolDetailsController_v1.getQuoteRecords();
            SplitSchoolDetailsController_v1.SaveSplitSchoolRecords(ssdList);
        	SplitSchoolDetailsController_v1.Left('AmericanSchool',0);
        	SplitSchoolDetailsController_v1.Left('AmericanSchool',3);
        	SplitSchoolDetailsController_v1.Left('AmericanSchool',15);
            SplitSchoolDetailsController_v1.sendQuoteDetails(QObj.id);
        Test.stopTest();
    }
    static testMethod void myUnitTestForGenerateInvoice() {
        string allInvoiceRecords;
        setupDataForController();
        sobj.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        sobj.stageName = 'Won';
        update sobj;
        sobjChild2.Subscription_Start_Year__c = String.valueOf(System.Today().Year());
        sobjChild2.Subscription_End_Year__c = String.valueOf(System.Today().Year()+1);
        PageReference pageRef = Page.GenerateInvoice;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',QObj.id);
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(sobjChild1);
        oppList.add(sobjChild2);
        Test.startTest();
            SplitSchoolDetailsController_v1 splitSchoolDetailsObj = new SplitSchoolDetailsController_v1();
            SplitSchoolDetailsController_v1.getParentOpp();
            SplitSchoolDetailsController_v1.getChildOpps();
			SplitSchoolDetailsController_v1.getQuoteLineValues();
			SplitSchoolDetailsController_v1.getQuoteInvoiceValues();
			SplitSchoolDetailsController_v1.getQuoteInvoiceLineValues();
       	    string sdate = '2018-6-7';
       	    string net30 = 'Net-30';
        	string street='950 4th St Sw';
            string description1 = 'Each student is given a unique account.';
        	string description2 = 'Each teacher gets a special account to manage classes,\r\nissue assessments, and track progress through\r\ndetailed analytics.'; //For covering the catch statement
        	//string data = '[{"AllLineItems":[{"Quantity__c":30,"Amount__c":180,"Product__c":"01t36000002ZnTlAAK","Unit_Price__c":6},{"Quantity__c":20,"Amount__c":1000,"Product__c":"01t36000002ZnTqAAK","Unit_Price__c":50}],"InvoiceItem":{"Name":"Inv123","Quote__c":"0Q05C0000005b3tSAA","Date__c":"'+sdate+'","Subscription_Start_Date__c":"'+sdate+'","Subscription_Month__c":24,"Payment_Terms__c":"'+net30+'","P_O_Number__c":"6786787687","Contact__c":"0035C00000DwGRBQA3","Due_Date__c":"'+sdate+'"}}]';
        //To cover the catch statement
        string data2 = '[{"AllLineItems":[{"Quantity__c":30,"Amount__c":180,"Product__c":"01t36000002ZnTlAAK","Unit_Price__c":6,"Description__c":"'+description2+'"},{"Quantity__c":20,"Amount__c":1000,"Product__c":"01t36000002ZnTqAAK","Unit_Price__c":50,"Description__c":"'+description2+'"}],"InvoiceItem":{Quote__c":"0Q05C0000005b3tSAA","Date__c":"'+sdate+'","Subscription_Start_Date__c":"'+sdate+'","Subscription_Month__c":24,"Payment_Terms__c":"'+net30+'","P_O_Number__c":"6786787687","Contact__c":"0035C00000DwGRBQA3","Due_Date__c":"'+sdate+'","No_of_Years__c":1}}]';        
        //To cover the Method of createallinvoices
		//string data ='[{"AllLineItems":[{"Quantity__c":20,"Amount__c":-200,"Product__c":"01t360000033sLhAAI","Unit_Price__c":10,"Description__c":"'+description1+'"},{"Quantity__c":10,"Amount__c":10,"Product__c":"01t360000033tIFAAY","Unit_Price__c":1,"Description__c":"'+description1+'"},{"Quantity__c":100,"Amount__c":1000,"Product__c":"01t36000002ZnTRAA0","Unit_Price__c":10,"Description__c":"'+description1+'"},{"Quantity__c":50,"Amount__c":2500,"Product__c":"01t36000002ZnTqAAK","Unit_Price__c":50,"Description__c":"'+description1+'"}],"InvoiceItem":{"Quote__c":"0Q05C0000005cYnSAI","Date__c":"'+sdate+'","Subscription_Start_Date__c":"'+sdate+'","Subscription_Month__c":12,"Payment_Terms__c":"'+net30+'","P_O_Number__c":"74982","Contact__c":"0035C00000F7i3KQAR","Due_Date__c":"'+sdate+'","No_of_Years__c":1}}]';
       string data = '[{"AllLineItems":[{"Quantity__c":300,"Amount__c":5700,"Product__c":"01t36000002ZnTCAA0","Unit_Price__c":19,"Description__c":"'+description1+'"},{"Quantity__c":10,"Amount__c":10,"Product__c":"01t360000033tIFAAY","Unit_Price__c":1,"Description__c":"'+description1+'"},{"Quantity__c":100,"Amount__c":5000,"Product__c":"01t36000002ZnTqAAK","Unit_Price__c":50,"Description__c":"'+description1+'"},{"Quantity__c":1,"Amount__c":-1,"Product__c":"01t360000033tI0AAI","Unit_Price__c":-1,"Description__c":"'+description1+'"}],"InvoiceItem":{"Quote__c":"0Q05C0000005ccGSAQ","Date__c":"'+sdate+'","Subscription_Start_Date__c":"'+sdate+'","Subscription_Month__c":12,"Payment_Terms__c":"'+net30+'","P_O_Number__c":"7898","Contact__c":"0035C00000A1RH0QAN","Due_Date__c":"'+sdate+'","No_of_Years__c":1,"Account_of_Contact__c":"0015C00000J6tH5QAJ","Billing_Country__c":"United States","Billing_City__c":"Moultrie","Billing_State_Province__c":"Georgia","Billing_Street__c":"'+street+'","Billing_Zip_Postal_Code__c":"31768"}}]';

        //For return null in getinvoicelineItems
        string data3 = '[{"AllLineItems":[],"InvoiceItem":{Quote__c":"0Q05C0000005b3tSAA","Date__c":"'+sdate+'","Subscription_Start_Date__c":"'+sdate+'","Subscription_Month__c":24,"Payment_Terms__c":"'+net30+'","P_O_Number__c":"687686869","Contact__c":"0035C00000DwGRBQA3","Due_Date__c":"'+sdate+'","No_of_Years__c":1}}]';
			SplitSchoolDetailsController_v1.createAllInvoices(data,true); //To cover the method createallinvoices
			SplitSchoolDetailsController_v1.createAllInvoices(data2,true); //To cover the catch statement.
			SplitSchoolDetailsController_v1.createAllInvoices(data3,true); //To cover the catch statement.
        Test.stopTest();
    }
  
    @isTest
    public static void myUnitTest(){
        SplitSchoolDetailsController_v1.myWrap wrapper= new SplitSchoolDetailsController_v1.myWrap();
    }
 
}