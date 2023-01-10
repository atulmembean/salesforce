@isTest
public class GenerateInvoicePDFControllerTest {
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
         c1= new contact();
        c1.LastName='ABC test';
        c1.AccountId=AccountObj.id;
        insert c1;
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
          Teacher__c =c1.Id,
          Funding_Source__c = 'Building fund'
        );
        insert sobj;
         QObj = new Quote(
          Name = 'Grouped_two',           
          OpportunityId = sobj.id,  
          Status = 'Draft',
          Total_Discounts__c=20,
          Subscription_Start_Year__c = String.valueOf(System.Today().Year()),
          Subscription_End_Year__c = String.valueOf(System.Today().Year()+3)
          //Pricebook2Id = Test.getStandardPricebookId()             
        );
        insert QObj;
         QObj.status = 'Accepted';
       //  QObj.Funding_Source__c='Building fund';
      //  update QObj; //commented here
        
         QObj2 = new Quote(
          Name = 'Grouped_two',           
          OpportunityId = sobj.id,  
          Status = 'Draft',
          Total_Discounts__c=20,
          Subscription_Start_Year__c= String.valueOf(System.Today().Year()),
          Subscription_End_Year__c= String.valueOf(System.Today().Year()+2)
          //Pricebook2Id = Test.getStandardPricebookId()             
        );
        insert QObj2;
		
		Product2 p= new Product2();
		p.Name='Students 300-499';
		p.Family='Student Subscriptions';
        p.IsActive=true;
        p.Description='Each student is given a unique account.';
        p.ProductCode='STU301-500';
        insert p;
        
        InvObj = new Invoice__c();
      //  InvObj.Name='INV-123';
        InvObj.Contact__c=c1.id;
        InvObj.Date__c=system.today();
        InvObj.P_O_Number__c='58568';
        InvObj.Quote__c=QObj.id;
        InvObj.Payment_Terms__c='Net-30';
        InvObj.No_of_Years__c=2;
        insert InvObj;
        
        Invoice_Line_Item__c Inv1 = new Invoice_Line_Item__c();
        Inv1.Amount__c=2000;
        Inv1.Invoice__c=InvObj.id;
        Inv1.Quantity__c=16;
        Inv1.Product__c=p.id;
        insert Inv1;

		InvObj.Subscription_Expiry_Month__c='August';
        update InvObj;
        
        invoiceLineItems = new List<Invoice_Line_Item__c>();
		invoiceLineItems.add(Inv1);
        
        InvObj2 = new Invoice__c();
       // InvObj2.Name='INV-123';
        InvObj2.Contact__c=c1.id;
        InvObj2.Date__c=system.today();
        InvObj2.P_O_Number__c='58568';
        InvObj2.Quote__c=QObj2.id;
        InvObj2.Payment_Terms__c='Net-30';
        InvObj2.No_of_Years__c=2;
        insert InvObj2;
        
        Invoice_Line_Item__c Inv2 = new Invoice_Line_Item__c();
        Inv2.Amount__c=2000;
        Inv2.Invoice__c=InvObj2.id;
        Inv2.Quantity__c=16;
        Inv2.Product__c=p.id;
        insert Inv2;
        invoiceLineItems.add(Inv2);
     /*   PageReference pdf = Page.GenerateInvoicePDF;
        pdf.getParameters().put('id', InvObj.id);
      */
      //  Blob pageContent = pdf.getContent();
      /*  Attachment savepdf=new Attachment();    
        savepdf.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        savepdf.body=bodyBlob;
        savepdf.parentId=InvObj.id;
        insert savepdf; 
      
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:InvObj.id];
        System.assertEquals(1, attachments.size());*/
    }
     static testMethod void pdfsave() {
        setupDataForController();
        //sobj.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        //update sobj;
        PageReference pageRef = Page.GenerateInvoicePDF;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',InvObj.id);
        Test.startTest();
         GenerateInvoicePDFController genPDF = new GenerateInvoicePDFController();
         GenerateInvoicePDFController.saveInvoicePdf(InvObj.id);
         GenerateInvoicePDFController.saveInvoicePdfLightning(InvObj.id);
         GenerateInvoicePDFController.getInvoiceValues();
        Test.stopTest();
    }
}