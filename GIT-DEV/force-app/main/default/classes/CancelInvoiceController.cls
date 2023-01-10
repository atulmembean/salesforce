public class CancelInvoiceController {
    @AuraEnabled
    public static String cancelQuoteInvoice(Id invoiceId){
         String validationMsg='';
        List<Invoice__c>lstInvoices=[select id,name,status__c, Paypal_Invoice__c, Paypal_Invoice_Id__c,paypal_send_url__c, Paypal_status__c, (select id,name from Payments__r) from Invoice__c where Id=:invoiceId];
        for(Invoice__c objInvoice:lstInvoices){
            if(objInvoice.Payments__r.size()>0){
                validationMsg='Payment is already made for the invoice. Please process as Refund';
                return validationMsg;
            }
        }
       
        validationMsg=CancelInvoiceController.validateOpportunity(invoiceId);
        if(!validationMsg.equalsIgnoreCase('SUCCESS')){
            return validationMsg;
        }
        String retmsg = CancelInvoiceController.deletePaymentLink(lstInvoices.get(0).Id);
        if (retmsg == 'success' || retmsg == 'Paypal Invoice Cancelled. Salesforce Invoice not updated')
        {
            /*for(Invoice__c objInvoice:lstInvoices){
                objInvoice.Status__c='Void';
                objInvoice.Paypal_Invoice__c=null;
                objInvoice.Paypal_Invoice_Id__c=null;
                objInvoice.paypal_send_url__c=null;
                objInvoice.Paypal_status__c=null;
                
            }*/
            if (lstInvoices.Size()>0)
            {
                //update lstInvoices;
                String quoteId=[select id,Quote__c from Invoice__c where id=:invoiceId].Quote__c;
                Quote objQuote=[select id,name,status,AccountId,opportunityId,Subscription_Start_Year__c,Subscription_End_Year__c,No_of_students__c,No_of_Teachers__c,
                                TotalPrice from quote where id=:quoteId];
                List<Contract>lstSubscriptions=[select id,name from Contract where accountId=:objQuote.AccountId order by createdDate desc limit 1];
                Account objAccount=[select id,name,Subscription_Status__c,No_of_Students__c,No_of_Teachers__c,AnnualRevenue__c,Subscription_Years__c  from Account where id=:objQuote.AccountId];
                Opportunity objOpportunity=[select id,name, stagename,Loss_Reason__c,Lost_Reason__c from Opportunity where id=:objQuote.OpportunityId];
                objQuote.Status='Rejected';
                update objQuote;
                objOpportunity.stageName='Close Lost';
                objOpportunity.Loss_Reason__c='Other';
                objOpportunity.Lost_Reason__c='Cancelled Invoice by User';
                update objOpportunity;
            //    delete lstSubscriptions;
                objAccount.Subscription_Status__c='Expired';
                objAccount.No_of_Students__c=objAccount.No_of_Students__c-Integer.valueOf(objQuote.No_of_students__c);
                objAccount.No_of_Teachers__c=objAccount.No_of_Teachers__c-Integer.valueOf(objQuote.No_of_Teachers__c);
                objAccount.AnnualRevenue__c=objAccount.AnnualRevenue__c-objQuote.TotalPrice;
                List<Integer>subscriptionYears=new List<Integer>();
                for(String yr:objAccount.Subscription_Years__c.split(';')){
                    subscriptionYears.add(Integer.valueOf(yr));
                }
                subscriptionYears.sort();
                subscriptionYears.remove(subscriptionYears.size()-1);
                String strSubYear='';
                if(subscriptionYears.size()>1){
                    for(Integer i:subscriptionYears){
                        strSubYear=(strSubYear.length()>0?strSubYear+';'+String.valueOf(i):strSubYear+String.valueOf(i));
                    }
                }else if(subscriptionYears.size()==1){
                    strSubYear=subscriptionYears.get(0)+'';
                }
                
              // objAccount.Subscription_Years__c=strSubYear;
                
               update objAccount;
               //CancelInvoiceController.deletePaymentLink(lstInvoices.get(0).Id);
            }
        }
     return 'Success';
    }
   
    public static String validateOpportunity(Id invoiceId){
        String quoteId=[select id,quote__c from invoice__c where id=:invoiceId].Quote__c;
        Quote objQuote=[select id,name,opportunityId from Quote where id=:quoteId ];
        Opportunity objOpportunity=[select id,name,Teachers_usage_count__c , RecordType.DeveloperName from Opportunity where id=:objQuote.opportunityID];
        if(!Test.isRunningTest() && objOpportunity.recordType.DeveloperName!='Grouped' && objOpportunity.recordType.DeveloperName!='Grouped MultiYear' && objOpportunity.Teachers_usage_count__c==0 ){
            return 'Please update teachers Membean usage count.';
        }
        return 'SUCCESS';
    }

    public static String deletePaymentLink(Id invoiceId){
        Invoice__c inv =[select id,name,Paypal_Invoice_Id__c,Paypal_Invoice__c,paypal_send_url__c,Paypal_status__c from Invoice__c where id=:invoiceId];
        
        String msg = 'success';
        
        StaticResource sr = [SELECT Id,Body,SystemModStamp FROM StaticResource WHERE Name = 'paypal_oauth_token' LIMIT 1]; 
        
        Http h = new Http(); 
        
        HttpRequest authReq = new HttpRequest();
        authReq.setEndpoint('https://api.paypal.com/v1/oauth2/token');
        authReq.setMethod('POST');
        authReq.setHeader('Content-Type','application/x-www-form-urlencoded');
        authReq.setHeader('Authorization',sr.Body.toString());
        authReq.setBody('grant_type=client_credentials'); 
        
        HttpResponse authRes = New HttpResponse();
        if (Test.isRunningTest())
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorJSON());
            authRes = h.send(authReq);
        }
        else
            authRes = h.send(authReq);
        system.debug('authRes::: ' + authRes.getBody());  
        if(authRes.getStatusCode() == 200){
            Map<String, Object> authResults = (Map<String, Object>) JSON.deserializeUntyped(authRes.getBody());                             
            String authToken = 'Bearer '+(String)authResults.get('access_token');
            
            
            HttpRequest sendReq = new HttpRequest();
            sendReq.setEndpoint('https://api.paypal.com/v2/invoicing/invoices/'+inv.Paypal_Invoice_Id__c+'/cancel');
            sendReq.setMethod('POST');
            sendReq.setHeader('Content-Type','application/json');
            sendReq.setHeader('Authorization',authToken);
            
            HttpResponse sendResponse = New HttpResponse();
            if (Test.isRunningTest())
            {
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorJSON204());
                sendResponse = h.send(sendReq);
            }
            else
                sendResponse = h.send(sendReq); 
            system.debug('sendResponse::: ' + sendResponse.getBody());                             
            if(sendResponse.getStatusCode() == 204){
                inv.Paypal_status__c = 'Cancelled';
                inv.Status__c = 'Void';
                
                try{
                    update inv; 
                }
                catch(DmlException e){
                    msg = 'Paypal Invoice Cancelled. Salesforce Invoice not updated'; 
                }                        
                
            }
            else
                msg = 'Paypal Invoice not cancelled';
            
        }
        else
            msg = 'Paypal invoice not cancelled';
       return msg;
    }
        
}