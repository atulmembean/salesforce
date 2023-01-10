global class PaypalPayStatusBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
      
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            if(Test.isRunningTest()){
               query = 'select Id,Name,Paypal_status__c,Date__c,Due_Date__c,Grand_Total__c,Paypal_Invoice_Id__c from Invoice__c order by createdDate DESC LIMIT 1';
            }
            else{
               query = 'select Id,Name,Paypal_status__c,Date__c,Due_Date__c,Grand_Total__c,Paypal_Invoice_Id__c from Invoice__c where ((Paypal_status__c = \'Sent\') OR (Paypal_Invoice_Id__c != Null AND Paypal_Status__c = \'Draft\'))';
            }
            
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Invoice__c>scope){
           
            StaticResource sr = [SELECT Id,Body,SystemModStamp FROM StaticResource WHERE Name = 'paypal_oauth_token'LIMIT 1];
           
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
                sendReq.setEndpoint('https://api.paypal.com/v1/invoicing/search');
                sendReq.setMethod('POST');
                sendReq.setHeader('Content-Type','application/json');
                sendReq.setHeader('Authorization',authToken);
                
                
                HttpRequest receiptReq = new HttpRequest();                
                receiptReq.setMethod('GET');
                receiptReq.setHeader('Content-Type','application/json');
                receiptReq.setHeader('Authorization',authToken);
                
                for(Invoice__c sc:scope){
                    if((sc.Paypal_status__c == 'Sent') || (Test.isRunningTest())){
                        receiptReq.setEndpoint('https://api.paypal.com/v1/sales/transactions/'+sc.Paypal_Invoice_Id__c+'/receipt');
                        ProcessRecord(sendReq,receiptReq,sc);
                    }
                    
                }
                
            }

       }
        
       global void finish(Database.BatchableContext BC){
            messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
            AsyncApexJob a = [SELECT Id,
                             Status,
                             NumberOfErrors,
                             JobItemsProcessed,
                             TotalJobItems,
                             CompletedDate,
                             ExtendedStatus,
                             ApexClass.name,
                             CreatedBy.Email,
                             CreatedBy.Name
                      FROM AsyncApexJob 
                      WHERE Id =:BC.getJobId()];
            String[] ToAddresses = new String[] {};
    
            String[] ToEmails = new String[]{};
            ToEmails.add('ganesh@membean.com');       
            List<String> FinalToAddresses = new list<String>();
            FinalToAddresses.addAll(ToEmails);
            mail.setToAddresses(FinalToAddresses);
         
            mail.setSubject('Processing of Paypal pay status update Batch Job Complete -- '+a.ApexClass.name);
            mail.setUseSignature(false);

            string td1='"border:1px solid green; width=200px;"';
            string td2='"width=200px; border:1px solid green; background-color:red; color:white; font-weight:bold;"';
            string tdHead='"border:1px solid green; width=200px; color:white; background-color:green; font-weight:bold;"';
            string ExtendedStatus='';
            if(a.ExtendedStatus!=null)
                ExtendedStatus=a.ExtendedStatus;
            string tdErrors=td1;
            if(a.NumberOfErrors>0)
                tdErrors=td2;
            string htmlBody = '<div style="border:2px solid green; border-radius:15px;"><p>Hi,</p><p><span style="color:brown; font-weight:bolder;">Salesforce</span> completed processing <b>Paypal payment status update via a Batch Job</b>.</p>'
            +'<p>Results:</p>'
            +'<center><table style="border:3px solid green; border-collapse:collapse;">'
            +'<tr><td style='+tdHead+'>Class Name</td><td style='+tdHead+'>'+a.ApexClass.name+'</td></tr>'
            +'<tr><td style='+td1+'>Completed Date</td><td style='+td1+'>'+a.CompletedDate+'</td></tr>'
            +'<tr><td style='+td1+'>Status</td><td style='+td1+'>'+a.Status+'</td></tr>'
            +'<tr><td style='+td1+'>Job Items Processed</td><td style='+td1+'>'+a.JobItemsProcessed+' / '+a.TotalJobItems+'</td></tr>'
            +'<tr><td style='+td1+'>NumberOfErrors</td><td style='+tdErrors+'>'+a.NumberOfErrors+'</td></tr>'
            +'<tr><td style='+td1+'>Extended Status</td><td style='+td1+'>'+ExtendedStatus+'</td></tr>'
            +'<tr><td style='+tdHead+'>Created By</td><td style='+tdHead+'>'+a.CreatedBy.Name+'</td></tr>'
            +'</table></center>'
            +'<p><b>Have a Nice Day !!!</b></p><p><span style="font-family:"Courier New", Courier, monospace; color:green; font-weight:bold; font-size:larger;">Team Salesforce</span></p></div>';
        
            mail.setHtmlBody(htmlBody);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            mails.add(mail);
            Messaging.sendEmail(mails);
                   
       }
    
       global void ProcessRecord(HttpRequest req,HttpRequest recReq,Invoice__c inv){

                Http h = new Http();                                 
                req.setBody('{"start_invoice_date": "'+DateTime.newInstance(inv.Date__c.year(), inv.Date__c.month(), inv.Date__c.day()-2).format('YYYY-MM-dd')+' PST","end_invoice_date": "'+DateTime.newInstance(inv.Due_Date__c.year(), inv.Due_Date__c.month(), inv.Due_Date__c.day()).format('YYYY-MM-dd')+' PST","page": 0,"page_size": 100,"total_count_required": true,"status": ["PAID","MARKED_AS_PAID"],"number":"'+inv.Name+'"}');                           
                
                HttpResponse sendResponse = h.send(req);
                system.debug('sendResponse.getStatusCode()::: ' + sendResponse.getStatusCode());
                if(sendResponse.getStatusCode() == 200){
                          
                system.debug('sendresponse.getbody::: ' + JSON.deserializeUntyped(sendResponse.getBody()));
                Map<String, Object> invoiceList = (Map<String, Object>) JSON.deserializeUntyped(sendResponse.getBody());
                system.debug('InvoiceList::: ' + invoiceList);
                
                List<Object> invoices = (List<Object>) invoiceList.get('invoices');
                
                if(invoices.size()>0){
                  
                    
                  HttpResponse receiptResponse = h.send(recReq);
                  system.debug('receiptResponse.getStatusCode()::: ' + receiptResponse.getStatusCode());  
                  if(receiptResponse.getStatusCode() == 200){
                      
                        Map<String, Object> receipt = (Map<String, Object>) JSON.deserializeUntyped(receiptResponse.getBody());
                        Map<String, Object> payDetails = (Map<String, Object>) receipt.get('receipt_payment');
                                                                                            
                        Date payDate = Date.valueOf(DateTime.newinstance(Long.valueOf((String)payDetails.get('payment_time'))*1000).format('YYYY-MM-dd'));
                        system.debug('payDetails.get(payment_status):::' + payDetails.get('payment_status'));
                        if(!Test.isRunningTest() && (payDetails.get('payment_status') == 'COMPLETE')){
                             inv.Paypal_status__c = 'Paid'; 
                             update inv;
                            
                             Payment__c payment = new Payment__c();
                             payment.Amount__c = inv.Grand_Total__c;
                             payment.Invoice__c = inv.Id;
                             payment.Payment_Mode__c = 'Paypal';
                             payment.Reference_Number__c = (String)payDetails.get('transaction_id');
                             payment.Payment_Date__c = payDate;
                             payment.Status__c = 'Paid';
                              
                                  
                             insert payment;                        
                        
                        } 
                   
                  }
                    
                }
                    
                }
       }
}