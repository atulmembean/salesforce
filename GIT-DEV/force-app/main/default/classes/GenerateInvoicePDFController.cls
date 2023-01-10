/**
* Class Type        : VF Page Controller
* Class Name        : GenerateInvoicePDFController
* Version           : 42.0
* Test Class        : GenerateInvoicePDFControllerTest
* Created Date      : 08/05/2018
* Modified By       : Pooja K
* Modified Date     : 20/08/2018(dd/mm/yyy)
* Description       : Controller for VF Page GenerateInvoicePDF.this page Generates the pdf for an invoice.
**/

global class GenerateInvoicePDFController {
    public id Invoiceid { get; set; }
    public static Invoice__c invObj{get;set;}
    public static List<Invoice_Line_Item__c> invoiceLineItems {get;set;}
    public static List<Invoice_Line_Item__c> invoiceLineItemsMulti {get;set;}
    public static List<Invoice__c> invoiceItems{get;set;}
    public static Decimal invoiceLineItemsTotalAmount {get;set;}
    public static decimal AddInvoiceAmount=0;
    public static decimal InvoiceTotalAmount{get;set;}
    public static decimal InvoiceDiscount{get;set;}
    public static decimal DiscountPercentage{get;set;}
    public static List<String>notesInvoice{get;set;}
    
    //Webservice method for saving the invoice pdf@AuraEnabled
    webservice static void saveInvoicePdf(String invoiceID) // you can pass parameters
    { 
        try{
            //INV-1234 Membean Invoice for <<Account Name>>
            Invoice__C invData = new Invoice__c();
            invData=[select id,Name,Contact__r.AccountId,Contact__r.Account.Name from Invoice__c where id=:invoiceID ];
            system.debug('the invoice id is'+invoiceID);
            PageReference pdf = Page.GenerateInvoicePDF;
            pdf.getParameters().put('id', invoiceID);
            //pdf.getParameters().put('position', '1');
            //pdf.setRedirect(true);
            //  Blob pageContent = pdf.getContent();
            Blob pageContent;
             if(Test.isRunningTest()) {
                 pageContent=blob.valueOf('Unit.Test');
             }else{
                 pageContent=pdf.getContent();
             }
                
            attachment savepdf = new attachment();
            //savepdf.name = 'Invoice.pdf';
            savepdf.name=invData.Name +' '+'Membean Invoice for'+ ' '+invData.Contact__r.Account.Name;
            savepdf.Body = pageContent;
            savepdf.ParentId = invoiceID;
            savepdf.isPrivate = false;
            insert savepdf;
           
        } catch(Exception e){
            system.debug('Exception'+e);
            system.debug('Exception mess'+e.getMessage());
            system.debug('Exception line number'+e.getLineNumber());
        }
    }
   
    
     @AuraEnabled
    public static void saveInvoicePdfLightning(String invoiceID) // you can pass parameters
    { 
        try{
            system.debug('the invoice id is'+invoiceID);
            PageReference pdf = Page.GenerateInvoicePDF;
            pdf.getParameters().put('id', invoiceID);
            //pdf.getParameters().put('position', '1');
            //pdf.setRedirect(true);
            //  Blob pageContent = pdf.getContent();
            Blob pageContent;
             if(Test.isRunningTest()) {
                 pageContent=blob.valueOf('Unit.Test');
             }else{
                 pageContent=pdf.getContent();
             }
                
            attachment savepdf = new attachment();
            savepdf.name = 'Invoice.pdf';
            savepdf.Body = pageContent;
            savepdf.ParentId = invoiceID;
            savepdf.isPrivate = false;
            insert savepdf;
           
        } catch(Exception e){
            system.debug('Exception'+e);
            system.debug('Exception mess'+e.getMessage());
            system.debug('Exception line number'+e.getLineNumber());
        }
    }
    
    // Constructor
    public GenerateInvoicePDFController() {
        try{
            Invoiceid=ApexPages.currentPage().getParameters().get('id');
            system.debug('Invoiceid************'+Invoiceid);
            invObj= new Invoice__c();
            invObj = [select id,name,Account_of_Contact__c,Quote__c,Quote__r.Opportunity.Account.Name,Quote__r.Opportunity.Account.BillingCountry,
                      Quote__r.Opportunity.Account.BillingPostalCode,Quote__r.Opportunity.Account.BillingState,Quote__r.Opportunity.Subscription_End_Year__c,
                      Quote__r.Opportunity.Account.BillingCity,Quote__r.Opportunity.Account.BillingStreet,Quote__r.No_Years__c,
                      Quote__r.Opportunity.Account.RecordType.Name,contact__c,Account__c,Account__r.BillingCountry,Quote__r.Opportunity.Account.Academic_End_Month__c,
                      Account__r.BillingPostalCode,Account__r.BillingState,Account__r.BillingCity,Account__r.BillingStreet,
                      Account__r.Name,Balance_Due__c,Bill_to_different_School__c,Date__c,Invoice_Amount__c,Notes__c,
                      Payment_Made__c,Terms_and_Conditions__c,Due_Date__c,Payment_Terms__c,P_O_Number__c,CreatedById,
                      CreatedBy.Name,CreatedBy.MobilePhone,CreatedBy.Email,Quote__r.Quote_PDF_school_years__c,No_of_Years__c,
                      Quote__r.Total_Discounts__c, Quote__r.Opportunity.Type,Quote__r.Quote_Type__c,Quote__r.Discount__c,Subscription_Expiry_Month__c,
                      Billing_City__c,Billing_Country__c,Billing_State_Province__c,Billing_Street__c,Billing_Zip_Postal_Code__c,Membean_Logo__c,
                      Account_of_Contact__r.Name,Account_of_Contact__r.ShippingStreet, Account_of_Contact__r.ShippingCity,
                      Account_of_Contact__r.ShippingState,Account_of_Contact__r.ShippingPostalCode,
                      Account_of_Contact__r.ShippingCountry,Quote__r.Quote_PDF_Bill_To__c,Quote__r.Quote_PDF_Ship_To__c,Bill_To_Pdf__c,Ship_To_Pdf__c,
                      Account_of_Contact__r.BillingStreet, Account_of_Contact__r.BillingCity,
                      Account_of_Contact__r.BillingState,Account_of_Contact__r.BillingPostalCode,
                      Account_of_Contact__r.BillingCountry
                      from Invoice__c where id=:Invoiceid];
            system.debug('invObj'+invObj);
            /* quoteInvoices = new List<Invoice__c>();
            for(Invoice__c invoice:[SELECT Id, Name, CreatedDate, Quote__c, Contact__c, Split_School_Detail__c FROM Invoice__c where Quote__c =:Quoteid]){
            quoteInvoices.add(invoice);
            }system.debug('quoteInvoices are ##'+quoteInvoices); */
            invoiceLineItems = new List<Invoice_Line_Item__c>();
            invoiceLineItemsMulti = new List<Invoice_Line_Item__c>();
            for(Invoice_Line_Item__c inLineItem:[SELECT Id, Name, CreatedDate,Description_Line_Item__c, Invoice_Pdf_Product__c,Invoice__c,Invoice__r.Quote__r.Quote_Type__c, Quote_Line_Item__c, Product__c,Product__r.Description,Product__r.Name,Product__r.Family, Quantity__c, Unit_Price__c,Amount__c,Description__c FROM Invoice_Line_Item__c where Invoice__c =:Invoiceid and Invoice__r.Quote__r.Quote_Type__c!='Multiyear' order by Product__r.Name]){
                invoiceLineItems.add(inLineItem);
                AddInvoiceAmount+=inLineItem.Amount__c;
                invoiceLineItemsTotalAmount=AddInvoiceAmount;
                system.debug('AddInvoiceAmount single is'+AddInvoiceAmount);
            }system.debug('invoiceLineItems are @@@'+invoiceLineItems); 
            system.debug('invoiceLineItemsTotalAmount is here Single'+invoiceLineItemsTotalAmount);
            for(Invoice_Line_Item__c inLineItem2:[SELECT Id, Name, CreatedDate,Description_Line_Item__c, Invoice_Pdf_Product__c,Invoice__c, Invoice__r.Quote__r.Quote_Type__c,Quote_Line_Item__c, Product__c,Product__r.Description,Product__r.Name,Product__r.Family, Quantity__c, Unit_Price__c,Amount__c,Description__c FROM Invoice_Line_Item__c where Invoice__c =:Invoiceid and (Product__r.name like '%Teachers%' OR Product__r.name like '%Students%' OR Product__r.name like '%Membean Insights%') and Invoice__r.Quote__r.Quote_Type__c='Multiyear' order by Product__r.name ]){
                invoiceLineItemsMulti.add(inLineItem2);
                AddInvoiceAmount+=inLineItem2.Amount__c;
                invoiceLineItemsTotalAmount=AddInvoiceAmount;
                system.debug('AddInvoiceAmount multi is'+AddInvoiceAmount);
            }system.debug('invoiceLineItemsMulti are @@@'+invoiceLineItemsMulti);
            system.debug('invoiceLineItemsTotalAmount is here multi'+invoiceLineItemsTotalAmount);
            //<td > Math.ROUND({!((invoiceLineItemsTotalAmount * invObj.No_of_Years__c)-(invObj.Quote__r.Total_Discounts__c /100 * invoiceLineItemsTotalAmount * invObj.No_of_Years__c))},2)  </td>
            //{!invObj.Quote__r.Total_Discounts__c /100 * invoiceLineItemsTotalAmount * invObj.No_of_Years__c}
          
/*Commented,changed logic*/ //InvoiceTotalAmount=((invoiceLineItemsTotalAmount * invObj.No_of_Years__c)-(invObj.Quote__r.Total_Discounts__c /100 * invoiceLineItemsTotalAmount * invObj.No_of_Years__c)).setScale(2);
           // InvoiceDiscount=(invObj.Quote__r.Total_Discounts__c /100 * invoiceLineItemsTotalAmount * invObj.No_of_Years__c).setScale(2); //Commented here,logic changed
           
            //Discount and Invoice total amount for both single year and multi year is calculated here.
            //08.29.2022 Added
            List<Invoice_Line_Item__c> invLineItemsMultidisc = new List<Invoice_Line_Item__c>();
            invLineItemsMultidisc = [SELECT Id, Name, Invoice__c,Product__c,Product__r.Family,Product__r.Name, Quantity__c, Unit_Price__c,Amount__c FROM Invoice_Line_Item__c where Invoice__c =:Invoiceid and Product__r.name like '%Discount%' order by Product__r.Name];
            // End
            
            if(invObj.Quote__r.Quote_Type__c == 'Multiyear'){
                InvoiceDiscount = 0;
                for (Invoice_Line_Item__c invlinedis :invLineItemsMultidisc){
                    InvoiceDiscount = InvoiceDiscount + (invlinedis.Quantity__c * invlinedis.Unit_Price__c);
                }
                InvoiceDiscount = (math.abs(InvoiceDiscount) * invObj.Quote__r.No_Years__c).setScale(2);
                //InvoiceDiscount=(math.abs(invObj.Quote__r.Total_Discounts__c) * invObj.Quote__r.No_Years__c).setScale(2);//Total discounts field has the amount. multiplied by no of years subscription ot get total discounts.
                system.debug('InvoiceDiscount is'+InvoiceDiscount);
                InvoiceTotalAmount=((invoiceLineItemsTotalAmount * invObj.Quote__r.No_Years__c) - InvoiceDiscount).setScale(2);
                system.debug('invoiceLineItemsTotalAmount is here'+InvoiceTotalAmount);
                system.debug('invObj.Quote__r.No_Years__c is'+invObj.Quote__r.No_Years__c);
                system.debug('InvoiceTotalAmount is here'+InvoiceTotalAmount);
            }else if(invObj.Quote__r.Quote_Type__c != 'Multiyear'){
                InvoiceTotalAmount=invoiceLineItemsTotalAmount;
                system.debug('InvoiceTotalAmount single is here@@'+InvoiceTotalAmount);
            }
            if(invObj.Quote__r.No_Years__c ==3){
                DiscountPercentage=20;
            }else if(invObj.Quote__r.No_Years__c ==2){
                DiscountPercentage=10; 
            }else{
                DiscountPercentage=10;
            }
            List<String> notesInvoiceList = new List<String>();
            notesInvoice= new List<String>();
            system.debug('Invoice notes::::: '+invObj.Notes__c);
            //notesInvoiceList=invObj.Notes__c.split('2.');
            notesInvoiceList=invObj.Notes__c.split('\n');
            system.debug('Splitted Invoice notes::::: '+notesInvoiceList);
            system.debug('Size is'+notesInvoiceList.size());
            for(Integer i=0;i<notesInvoiceList.size();i++){ // String noteLst:notesInvoice){
                system.debug('notesInvoiceList[0]'+notesInvoiceList[0]);
                /*if(i==0){
                    system.debug('entered here'+i);
                    notesInvoice.add(notesInvoiceList[i]);
                }if(i==1){
                    system.debug('entered here'+i);
                    //notesInvoice.add('2.'+''+notesInvoiceList[i]);
                    notesInvoice.add(notesInvoiceList[i]);
                }*/
                
                notesInvoice.add(notesInvoiceList[i]);
                
            }
            system.debug(notesInvoice);
        }catch(Exception e){
            system.debug('exception e'+e);
            system.debug('ex mess'+e.getMessage());
            system.debug('ex mess'+e.getLineNumber());
        }
    }
    global  static Map<String, Object> getInvoiceValues(){
        invoiceItems = new List<Invoice__c>();
        system.debug(JSON.serialize(invObj));
        invObj = (Invoice__c)JSON.deserialize(JSON.serialize(invObj), Invoice__c.class);
        system.debug('invObj'+invObj);
        Map<String, Object> stresult = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(invObj));
        system.debug('stresult'+stresult);
        return stresult;
    }
}