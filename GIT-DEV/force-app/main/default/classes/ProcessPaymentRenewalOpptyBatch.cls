global class ProcessPaymentRenewalOpptyBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Payment__c where Create_Renewal_Oppty__c = TRUE LIMIT 5';  
            }
            else{
               query = 'Select id from Payment__c where Create_Renewal_Oppty__c = TRUE';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Payment__c> scope){

                for(Payment__c p:scope){
                    ProcessRecord(p.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
                   
            Payment__c p = [Select Id,Invoice__r.Quote__r.Opportunity.Account.Recordtype.Name,Amount__c,Invoice__c,Create_Renewal_Oppty__c,Invoice__r.Renewal_Oppty_Created__c,Invoice__r.Quote__r.Renewal_Oppty_Created__c from Payment__c where Id = :rId];
            if (p != Null)
            {
                if (p.Invoice__r.Renewal_Oppty_Created__c == FALSE && p.Invoice__r.Quote__r.Renewal_Oppty_Created__c == FALSE && p.Invoice__r.Quote__r.Opportunity.Account.Recordtype.Name != 'Tutoring')
                {
                    Invoice__c inv = [Select Id,Status__c,Grand_Total__c,Payment_Amount__c from Invoice__c where Id = :p.Invoice__c];
                    if (inv != Null)
                    {
                        if (inv.Payment_Amount__c == inv.Grand_Total__c)
                        {
                            inv.Status__c = 'Closed';
                            inv.Paypal_status__c = 'Paid';
                            /*List<Invoice__c> invlst = [select Id,Name,Contact__r.Phone,Due_Date__c,Date__c,Contact__r.Name,Contact__r.Email,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Paypal_Invoice_Id__c,P_O_Number__c,(select Id,Name,Product__r.Family,Description_Line_Item__c,Quantity__c,Unit_Price__c from Invoice_Line_Items__r) from Invoice__c where Id = :inv.Id];
                            StaticResource sr = [SELECT Id,Body,SystemModStamp FROM StaticResource WHERE Name = 'paypal_oauth_token' LIMIT 1];
                            
                            for (Invoice__c invoice :invlst)
                            {
                                Http h = new Http(); 
                                HttpRequest authReq = new HttpRequest();
                                authReq.setEndpoint('https://api.paypal.com/v1/oauth2/token');
                                authReq.setMethod('POST');
                                authReq.setHeader('Content-Type','application/x-www-form-urlencoded');
                                authReq.setHeader('Authorization',sr.Body.toString());
                                authReq.setBody('grant_type=client_credentials'); 
                                HttpResponse authRes = h.send(authReq);
                                if(authRes.getStatusCode() == 200){
                                    Map<String, Object> authResults = (Map<String, Object>) JSON.deserializeUntyped(authRes.getBody());                             
                                    String authToken = 'Bearer '+(String)authResults.get('access_token');
                                    HttpRequest sendReq = new HttpRequest();
                                    sendReq.setEndpoint('https://api.paypal.com/v2/invoicing/invoices/'+invoice.Paypal_Invoice_Id__c+'/cancel');
                                    sendReq.setMethod('POST');
                                    sendReq.setHeader('Content-Type','application/json');
                                    sendReq.setHeader('Authorization',authToken);
                                    HttpResponse sendResponse = h.send(sendReq); 
                                    inv.Paypal_status__c = 'Paid';                             
                                }
                                
                            }*/
                            update inv;
                        }
                                
                    }
                    createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
                    request.PaymentId = p.Id;
                    createRenewalOpptyInvocable.ProcessRecord(request);
                }
                else
                {
                    Invoice__c inv1 = [Select Id,Status__c,Grand_Total__c,Payment_Amount__c from Invoice__c where Id = :p.Invoice__c];
                    if (inv1 != Null)
                    {
                        if (inv1.Payment_Amount__c == inv1.Grand_Total__c)
                        {
                            inv1.Status__c = 'Closed';
                            inv1.Paypal_status__c = 'Paid';
                            update inv1;
                        }
                    }
                    p.Create_Renewal_Oppty__c = FALSE;
                    update p;
                }
            }
       }
}