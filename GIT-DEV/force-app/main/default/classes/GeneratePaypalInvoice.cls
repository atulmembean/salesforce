global class GeneratePaypalInvoice {

    public static String invoice_Id { get; set; }
    public static String inv { get; set; }
    public static String invLineItms { get; set; }

    public GeneratePaypalInvoice(){
        invoice_Id = ApexPages.currentPage().getParameters().get('id');
        
        
    }
    
    @AuraEnabled
    public static string getInvoiceStatus(String invId){
        
        String paypalUrl =  [select Paypal_Invoice__c from Invoice__c where Id =:invId].Paypal_Invoice__c;
        system.debug('@@@ paypalUrl '+paypalUrl);
        system.debug('### invId '+invId);
        if(!String.isBlank(paypalUrl)){
            return 'Exists';
        }
        
        return 'Success';
        
    }

    @RemoteAction
    global static List<Object> getInvoiceDetails(String id){
        
        List<Object> obj = new List<Object>();
        Product2 p = [Select Id from Product2 where Name = 'Membean Subscriptions' and isActive =  TRUE LIMIT 1];
        
        invoice_Id = id;
        Invoice__c invoices = [select Name,Grand_Total__c,Contact__r.Phone,Due_Date__c,Date__c,Contact__r.Name,Contact__r.Email,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,P_O_Number__c,Invoice_Amount__c from Invoice__c where Id =:invoice_Id];
            
        //List<Invoice_Line_Item__c> invoiceLineItms = [select Id,Name,Product__r.Family,Description_Line_Item__c,Quantity__c,Unit_Price__c from Invoice_Line_Item__c where Invoice__c =:invoices.Id];
        //List<Invoice_Line_Item__c> invoiceLineItms = New List<Invoice_Line_Item__c>();
        
        Invoice_Line_Item__c ili =  New Invoice_Line_Item__c();
        ili.Invoice__c = invoice_Id;
        ili.Quantity__c = 1;
        ili.Unit_Price__c = invoices.Grand_Total__c;
        ili.Amount__c = invoices.Grand_Total__c;
        ili.Product__c = p.Id;
        insert ili;
        System.debug('ili::: ' + ili);
        system.debug('invoices.Grand_Total__c::: ' + invoices.Grand_Total__c);
        system.debug('invoice_Id::: ' + invoice_Id);
        List<Invoice_Line_Item__c> invoiceLineItms = [select Id,Name,Product__r.Family,Description_Line_Item__c,Quantity__c,Unit_Price__c from Invoice_Line_Item__c where Invoice__c =:invoices.Id AND Product__c = :p.Id];
        
        delete ili;
        
        inv = JSON.serialize(invoices);
        invLineItms = JSON.serialize(invoiceLineItms);
        
        obj.add(invoices);
        obj.add(invoiceLineItms);
        system.debug('@@@  getInvoiceDetails  '+obj);
        return obj;
        
    }
    
    @RemoteAction
    global static String createPaypalInvoice(String invoiceDetails,String invoiceId){
       system.debug('@@ inside createPaypalInvoice invoiceDetails '+invoiceDetails+'    invoiceId '+invoiceId);
       StaticResource sr = [SELECT Id,Body,SystemModStamp FROM StaticResource WHERE Name = 'paypal_oauth_token'LIMIT 1]; 
       String msg = 'Success';
        
       Http http = new Http();
        
       HttpRequest authReq = new HttpRequest();       
       authReq.setEndpoint('https://api.paypal.com/v1/oauth2/token');
       authReq.setMethod('POST');
       authReq.setHeader('Content-Type','application/x-www-form-urlencoded');
       authReq.setHeader('Authorization',sr.Body.toString());
       authReq.setBody('grant_type=client_credentials'); 
                
 
       HttpResponse authRes = New HttpResponse();
       HttpResponse response = New HttpResponse();
       HttpResponse invResponse = New HttpResponse();
       HttpResponse sendResponse = New HttpResponse();
       
       if (Test.isRunningTest())
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorJSON());
            authRes = http.send(authReq);
        }
        else
        {
            system.debug('authReq::: ' + authReq);
            authRes = http.send(authReq);
        }
        system.debug('@@@  authRes  '+authRes.getStatusCode());
       if(authRes.getStatusCode() == 200){
       
       Map<String, Object> authResults = (Map<String, Object>) JSON.deserializeUntyped(authRes.getBody());
                             
       String authToken = 'Bearer '+(String)authResults.get('access_token'); 
       
       HttpRequest req = new HttpRequest();       
       req.setEndpoint('https://api.paypal.com/v2/invoicing/invoices');
       req.setMethod('POST');
       req.setHeader('Content-Type','application/json');
       req.setHeader('Authorization',authToken);
       req.setBody(invoiceDetails); 
       system.debug('Invoicedetails::: ' + InvoiceDetails);
           
       if (Test.isRunningTest())
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorJSON201());
            response = http.send(req);
        }
        else
        {
            response = http.send(req);
        }  
        system.debug('@@@@ invoices response  '+response.getBody()); 
        system.debug('@@@@   getStatusCode'+response.getStatusCode() );   
       if(response.getStatusCode() == 201){
           
           Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());               
           String url = (String)results.get('href');
       
           HttpRequest invReq = new HttpRequest();
           invReq.setEndpoint(url);
           invReq.setMethod('GET');
           invReq.setHeader('Content-Type','application/json');
           invReq.setHeader('Authorization',authToken);
           
                       
           if (Test.isRunningTest())
            {
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorJSONDetail());
                invResponse = http.send(invReq);
            }
            else
            {
                invResponse = http.send(invReq);
            } 
           system.debug('invreq::: ' + invReq);
           
           Map<String, Object> invoice = (Map<String, Object>) JSON.deserializeUntyped(invResponse.getBody());
           Map<String, Object> details = (Map<String, Object>) invoice.get('detail');
           Map<String, Object> invoiceUrls = (Map<String, Object>) details.get('metadata');
           
           
           List<Object> linkUrls = (List<Object>) invoice.get('links');
           system.debug('linkURLs::: ' + linkUrls);
           Map<String, Object> urlObj = (Map<String, Object>) linkUrls[1];  
                    
          
           String recpUrl = (String) invoiceUrls.get('recipient_view_url');
           String invrUrl = (String) invoiceUrls.get('invoicer_view_url');
           system.debug('linkUrls[1]::: ' + linkUrls[1]);
           system.debug('(String)urlObj.get(href):::' + (String)urlObj.get('href'));
           HttpRequest sendReq = new HttpRequest();
           sendReq.setEndpoint((String)urlObj.get('href'));
           sendReq.setMethod('POST');
           sendReq.setHeader('Content-Type','application/json');
           sendReq.setHeader('Authorization',authToken);
              
           if (Test.isRunningTest())
            {
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorJSON());
                sendResponse = http.send(sendReq);
            }
            else
            {
                sendResponse = http.send(sendReq);
            } 
            system.debug('sendreq::: ' + sendReq);
            system.debug('sendResponse::: ' + sendResponse);                             
           if((sendResponse.getStatusCode() == 200) && !Test.isRunningTest()){
               
               Invoice__c inv = new Invoice__c();
               inv.Id = invoiceId;
               inv.Paypal_status__c = 'Sent';
               inv.Paypal_Invoice__c = recpUrl;
               inv.paypal_send_url__c = (String)urlObj.get('href');
               inv.Paypal_Invoice_Id__c = (String)invoice.get('id');
               
               update inv;
               
               return recpUrl;
                             
           }
           else
               msg = 'Paypal Invoice generation Failed: '+sendResponse.getBody();
           }
           else
               msg = 'Paypal Invoice generation Failed: '+response.getBody();
           
       }
       else
           msg = 'Paypal Invoice generation Failed: '+authRes.getBody();
        
       return msg;
        
    }

}