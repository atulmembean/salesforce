/**
* Class Type        : VF Page Controller for SplitSchoolDetails_V1 and GenerateInvoice
* Class Name        : SplitSchoolDetailsController_v1
* Version           : 39.0
* Test Class        : SplitSchoolDetailsControllerTest
* Modified By       : Pooja K
* Modified Date     : 20/08/2018(dd/mm/yyyy)
* Description       : Controller for VF Page SplitSchoolDetails_V1. It takes care of Spliting the Grouped Opps as split school details.
                      Also Controller for the Genrate invoice page. We create single or multiple invoices as required on the quote.
**/

global class SplitSchoolDetailsController_v1{
    
    //Variable Declaration
   // public date dat{get;set;}
     
    public id Quoteid { get; set; }
    public static ID oppId ;
    public static Opportunity parentOppRecord ;
    public static Map<Id,Split_School_Detail__c> splitMap;
    public static Quote quoteRecords;
    public static Quote quoteDetails;
    public static List<quotelineItem> quoteline;
    public static List<Invoice__c> quoteInvoices;
    public static List<Invoice_Line_Item__c> invoiceLineItems;
    public static string payTerms{get;set;}
    public SplitSchoolDetailsController_v1(){
        
        Quoteid=ApexPages.currentPage().getParameters().get('id');
        system.debug('quoteid************'+Quoteid);
        Quote quoteObj = [select id,name,OpportunityId from Quote where id=:Quoteid];
        oppId = quoteObj.OpportunityId;
        parentOppRecord = [select name,Account.Name,No_of_Students__c, No_of_Teachers__c,RecordTypeId,Parent_Opportunity__c,Subscription_End_Year__c,Subscription_Start_Year__c
                           from opportunity where id = :oppId];
        quoteRecords=[select id,Teacher_Count__c,Count_Quantity__c,opportunity.Teacher__c,No_Years__c,opportunity.AccountId,opportunity.Account.Billingcountry,opportunity.Account.BillingStreet,opportunity.Account.BillingPostalCode,opportunity.Account.BillingCity,opportunity.Account.BillingState,No_of_students__c,No_of_Teachers__c,Opportunity.Student_Pay__c from Quote where id=:Quoteid];
        //Adding child Opportunity details to Split school object if record doesnt exists.
        splitMap=new Map<Id,Split_School_Detail__c>();
        quoteline = new List<quotelineItem>();
        quoteInvoices = new List<Invoice__c>();
        invoiceLineItems = new List<Invoice_Line_Item__c>();
        Set<Id> setIds=new Set<id>();
        for(opportunity ids:[select id, name,Account.Name, No_of_Students__c, No_of_Teachers__c,AccountID ,Subscription_Start_Year__c,Subscription_End_Year__c
                             from opportunity where Parent_Opportunity__c = :oppId]){
                                 setIds.add(ids.id);             
                             }
        for(Split_School_Detail__c s:[select id,Name,No_of_Students__c,No_of_Teachers__c,Opportunity_Name__c,Quote_Name__c,School_Name__c from Split_School_Detail__c where Quote_Name__c  =:Quoteid]){
            splitMap.put(s.Opportunity_Name__c,s); 
        }
        system.debug('splitmap'+splitMap);
        for(Opportunity opp:[select id, name,Account.Name, No_of_Students__c, No_of_Teachers__c,AccountID ,Subscription_Start_Year__c,Subscription_End_Year__c
                             from opportunity where Parent_Opportunity__c = :oppId order by Account.Name]){
                                 
                                 Split_School_Detail__c  s;
                                 if(!splitMap.containsKey(opp.id)){
                                     s=new Split_School_Detail__c(Opportunity_Name__c=opp.id,Quote_Name__c=quoteobj.id,Name=opp.Account.Name,No_of_Teachers__c=opp.No_of_Teachers__c,No_of_Students__c=opp.No_of_Students__c,School_Name__c=opp.AccountId);
                                     splitMap.put(opp.id,s);
                                 }else{
                                     //s=splitMap.get(opp.id);
                                 }
                                 
                             }  
        system.debug('Quoteid%%%%'+Quoteid);
        
        for(quotelineItem q:[select Discount, Id, LineNumber,Product2.Name,Product2.Id,Product2.Description, CreatedDate, QuoteId, PricebookEntryId, Quantity, UnitPrice, Description, Quote_PDF_Description__c,Product2Id, ListPrice, Subtotal, TotalPrice, Item__c, Product_family__c, Quote_Product_Family__c from quotelineItem where QuoteID =:Quoteid]){
            quoteline.add(q);
            system.debug('quoteline-----Inside for loop'+quoteline);
        }
        system.debug('quoteline'+quoteline);
        for(Invoice__c invoice:[SELECT Id, Name, CreatedDate, Quote__c, Contact__c, Split_School_Detail__c,Payment_Terms__c,Subscription_Start_Date__c,Subscription_Month__c,P_O_Number__c,Date__c,No_of_Years__c,Billing_City__c,Billing_Country__c,Billing_State_Province__c,Billing_Street__c,Billing_Zip_Postal_Code__c,Account_of_Contact__c FROM Invoice__c where Quote__c =:Quoteid]){
            quoteInvoices.add(invoice);
        }system.debug('quoteInvoices are ##'+quoteInvoices);
        for(Invoice_Line_Item__c inLineItem:[SELECT Id, Name, CreatedDate, Invoice__c, Quote_Line_Item__c, Product__c, Quantity__c, Unit_Price__c,Amount__c FROM Invoice_Line_Item__c where Invoice__c in:quoteInvoices]){
            invoiceLineItems.add(inLineItem);
        }system.debug('invoiceLineItems are @@@'+invoiceLineItems);
        
        //payTerms='';
        payTerms= JSON.serialize(Utility.getPicklistValues(Utility.INVOICE_OBJ, Utility.PAYMENT_TERMS));
    }
    
    
    global static String getQuoteLineValues(){
        return JSON.serialize(quoteline);
    }
    global static String getQuoteInvoiceValues(){
        return JSON.serialize(quoteInvoices);
    }
    global static String getQuoteInvoiceLineValues(){
        return JSON.serialize(invoiceLineItems);
    } 
    
    global static String getMapVAlues(){
        return JSON.serialize(splitMap.values());
    } 
    
    global static string getParentOpp(){
        return JSON.serialize(parentOppRecord );
    }
    
    global static string getChildOpps(){
        
        return JSON.serialize([select id, name,Account.Name, No_of_Students__c, No_of_Teachers__c,AccountID ,Subscription_Start_Year__c,Subscription_End_Year__c
                               from opportunity where Parent_Opportunity__c = :oppId]);
    }
    global static string getQuoteRecords(){
        return JSON.serialize(quoteRecords);
    }
    
    //Method added for the lightning component GenerateInvoiceComponent to get the Quote details
    @AuraEnabled
    public static Quote sendQuoteDetails(Id quoteId){
        quoteDetails=[select id,Teacher_Count__c,Status,Invoice_Count__c,Count_Quantity__c,opportunity.Teacher__c,No_Years__c,Opportunity.Student_Pay__c from Quote where id=:quoteId ];
        return quoteDetails;
    }
   
    public static String Left(String s, Integer i) {
        if (s == null || s == '' || i <=0 ) {
            return '';
        } else if (i >= s.length()) {
            return s;
        } else {
            //return s.subString(s.length() - i, s.length()); //Right Operator
            system.debug(s.length());
            return s.subString(0, i);   //Left operator, Which shortens the string from left to right to thespecified index
        }
    } 
    
    @RemoteAction
    global Static String SaveSplitSchoolRecords(List<Split_School_Detail__c> listOfschoolrecords){
        
        String Message='';
        try{
            system.debug('listOfschoolrecords####'+listOfschoolrecords);
            for(Split_School_Detail__c s : listOfschoolrecords){
                s.Name=Left(s.Name,80);
            }
            system.debug('listOfschoolrecords'+listOfschoolrecords);
            upsert listOfschoolrecords;
            Message='Sucess';
        }Catch(Exception e){
            Message='failure';
            system.debug('exception' +e);
            system.debug('exception Mes' +e.getMessage());
            system.debug('exception Line' +e.getLineNumber());
        }
        return Message;                                                                     
    }
    
    @RemoteAction
      global static List<Invoice__c> createAllInvoices(String AllInvoiceRecords,boolean isSplit){
        try{
            system.debug('#####################@@@@@@@@@@@@@@');
            system.debug(AllInvoiceRecords);
            List<Invoice__c> invo = new List<Invoice__c>();
            List<Invoice_Line_Item__c> INLineItem = new List<Invoice_Line_Item__c>();
            List<myWrap> wrprList   = new List<myWrap>();
            List<String> invIds = new List<String>{};
            
            List<myWrap> fieldWrapper = (List<myWrap> ) System.JSON.deserialize(AllInvoiceRecords, List<myWrap>.class);
            system.debug('fieldWrapper $$$$$'+fieldWrapper);
            for(myWrap wrap:fieldWrapper){
                System.debug('@@@@'+wrap);
                System.debug('@@@@'+wrap.InvoiceItem);
                invo.add(wrap.InvoiceItem);
            }
            if(! invo.isEmpty()){
                system.debug('final invoice is'+invo);
                insert invo; 
            }
            system.debug('invoice'+invo);
            for(Integer i=0;i<invo.size();i++){
                INLineItem.addAll(getNewInvoiceLineItems(fieldWrapper[i].AllLineItems,invo[i].Id));
                invIds.add(invo[i].Id);
            }
            if(! INLineItem.isEmpty()){
                insert INLineItem; 
            }
            System.debug('@@@@@@@@'+INLineItem);
            
            List<Invoice__c> invoiceNames = [select Name,Contact__r.Name,Contact__r.Email,Contact__r.Phone,Account__c,Accountname_relatedlist__c,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Country__c,Billing_Zip_Postal_Code__c from Invoice__c where Id IN:invIds];                          
            return invoiceNames;
        }catch(Exception e){
            system.debug('exception' +e);
            system.debug('exception Mes' +e.getMessage());
            system.debug('exception Line' +e.getLineNumber());
            return null;
        }
    }
    public static List<Invoice_Line_Item__c> getNewInvoiceLineItems(List<Invoice_Line_Item__c> allInvoices,String invoiceId){
        system.debug('allInvoices %%'+allInvoices);
        List<Invoice_Line_Item__c> InvoiceList = new List<Invoice_Line_Item__c>();
        Invoice_Line_Item__c tempRec;
        for(Invoice_Line_Item__c invLIRec:allInvoices){
            tempRec = new Invoice_Line_Item__c();
            tempRec.Amount__c=invLIRec.Amount__c;
            tempRec.Quantity__c = invLIRec.Quantity__c;
            temprec.Invoice__c = invoiceId;
            temprec.Product__c = invLIRec.Product__c;
            temprec.Unit_Price__c=invLIRec.Unit_Price__c;
            temprec.Description__c=invLIRec.Description__c;
            temprec.Quote_Line_Item__c=invLIRec.Quote_Line_Item__c;
         /* temprec.Total_Amount__c=invLIRec.Total_Amount__c; */
            InvoiceList.add(temprec);
        }
        if(! InvoiceList.isEmpty())
        return InvoiceList;
        else{
            return null;
        }
    }
    global class myWrap{
        public Invoice__c InvoiceItem;
        public List<Invoice_Line_Item__c> AllLineItems;
        public myWrap(){
            this.InvoiceItem=new Invoice__c();
            this.AllLineItems=new List<Invoice_Line_Item__c>();
        }
    }
    
    /*@RemoteAction
    global static String generatePaypalInvoice(String invoiceDetails,String invId){
        
       Http h = new Http(); 
        
       HttpRequest authReq = new HttpRequest();
       authReq.setEndpoint('https://api.sandbox.paypal.com/v1/oauth2/token');
       authReq.setMethod('POST');
       authReq.setHeader('Content-Type','application/x-www-form-urlencoded');
       authReq.setHeader('Authorization','Basic QVdiNnlLQmE2ampST2syb25YRm5VanhZcjdIaEVFMTJYc1BfOFlSd0xjQmsyOVdHOC02MUpFdDF4VzF3dFFOUS02dEhDZEloRUFPRU5hYVk6RUhYcHgwQXpneVVPZV8ySTBBeGVERXdGczVMZE43OXkxVUs4SzVCU0M1TkdlU3pXZVpzUDFLcmpCZHMwdHNpdEZQZjd1YkFhVkcyQ2R0akE=');
       authReq.setBody('grant_type=client_credentials'); 
                
       HttpResponse authRes = h.send(authReq);
               
       if(authRes.getStatusCode() == 200){
       
       Map<String, Object> authResults = (Map<String, Object>) JSON.deserializeUntyped(authRes.getBody());
                             
       String authToken = 'Bearer '+(String)authResults.get('access_token'); 
       
       HttpRequest req = new HttpRequest();
       req.setEndpoint('https://api.sandbox.paypal.com/v2/invoicing/invoices');
       req.setMethod('POST');
       req.setHeader('Content-Type','application/json');
       req.setHeader('Authorization',authToken);
       req.setBody(invoiceDetails); 
           
         
       HttpResponse response = h.send(req);
           
       system.debug(response.getStatusCode());
       system.debug(response);
           
           
       if(response.getStatusCode() == 201){
           
           Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());               
           String url = (String)results.get('href');
       
           HttpRequest invReq = new HttpRequest();
           invReq.setEndpoint(url);
           invReq.setMethod('GET');
           invReq.setHeader('Content-Type','application/json');
           invReq.setHeader('Authorization',authToken);
                       
           HttpResponse invResponse = h.send(invReq);
           
           Map<String, Object> invoice = (Map<String, Object>) JSON.deserializeUntyped(invResponse.getBody());
           Map<String, Object> details = (Map<String, Object>) invoice.get('detail');
           Map<String, Object> invoiceUrls = (Map<String, Object>) details.get('metadata');
           
           
           List<Object> linkUrls = (List<Object>) invoice.get('links');
           
           Map<String, Object> urlObj = (Map<String, Object>) linkUrls[1];           
           
           String recpUrl = (String) invoiceUrls.get('recipient_view_url');
           String invrUrl = (String) invoiceUrls.get('invoicer_view_url');
                      
           
           Invoice__c inv = new Invoice__c();
           inv.Id = invId;
           inv.Paypal_status__c = 'Draft';
           inv.Paypal_Invoice__c = recpUrl;
           inv.paypal_send_url__c = (String)urlObj.get('href');
           inv.Paypal_Invoice_Id__c = (String)invoice.get('id');
           
           update inv;
           
           return recpUrl;
           
       }
           
       }
        
       return 'success'; 
    }*/
    
}