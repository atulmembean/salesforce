global class PaypalUpdateHandler implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    public class Unit_amount{
        public string currency_code;
        public Decimal value;        
    }
    
    public class Item{
        public string name;
        public string description;
        public Decimal quantity;
        public Unit_amount unit_amount;
        public string unit_of_measure; 
    }
    
    public List<Invoice__c> invoices = new List<Invoice__c>();
    
    public PaypalUpdateHandler(List<Invoice__c> invList){
        invoices = invList;
    }
    
    global List<Invoice__c> start(Database.BatchableContext bc){
        return invoices;
    }
    
    global void execute(Database.BatchableContext bc,List<Invoice__c> scope){
        
            StaticResource sr = [SELECT Id,Body,SystemModStamp FROM StaticResource WHERE Name = 'paypal_oauth_token' LIMIT 1];
                            
            Http h = new Http();
        
            HttpRequest authReq = new HttpRequest();
            authReq.setEndpoint('https://api.paypal.com/v1/oauth2/token');
            //authReq.setEndpoint('https://api.sandbox.paypal.com/v1/oauth2/token');
            authReq.setMethod('POST');
            authReq.setHeader('Content-Type','application/x-www-form-urlencoded');
            authReq.setHeader('Authorization',sr.Body.toString());
            authReq.setBody('grant_type=client_credentials'); 
                    
            HttpResponse authRes = new HttpResponse();
        
            if (Test.isRunningTest())
            {
                Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorJSON());
                authRes = h.send(authReq);
            }
            else
            {
                authRes = h.send(authReq);
            }
                   
            if(authRes.getStatusCode() == 200){
                Map<String, Object> authResults = (Map<String, Object>) JSON.deserializeUntyped(authRes.getBody());                             
                String authToken = 'Bearer '+(String)authResults.get('access_token');
                                                
                HttpRequest updateReq = new HttpRequest();                
                updateReq.setMethod('PUT');
                updateReq.setHeader('Content-Type','application/json');
                updateReq.setHeader('Authorization',authToken);

        
                for(Invoice__c sc:scope){
                    system.debug(sc.Paypal_Invoice_Id__c);
                    if(!String.isBlank(sc.Paypal_Invoice_Id__c) || Test.isRunningTest()){
                        updateReq.setEndpoint('https://api.paypal.com/v2/invoicing/invoices/'+sc.Paypal_Invoice_Id__c);
                        //updateReq.setEndpoint('https://api.sandbox.paypal.com/v1/oauth2/token'+sc.Paypal_Invoice_Id__c);
                        updatePaypalInvoice(sc,updateReq);
                    }                    
                }
                
            }
    }
    
    global void finish(Database.BatchableContext bc){
        /*messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
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
            ToEmails.add('shantanu0412kumar@gmail.com');       
            List<String> FinalToAddresses = new list<String>();
            FinalToAddresses.addAll(ToEmails);
            mail.setToAddresses(FinalToAddresses);
         
            mail.setSubject('Processing of Paypal Invoice update Batch Job Complete -- '+a.ApexClass.name);
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
            string htmlBody = '<div style="border:2px solid green; border-radius:15px;"><p>Hi,</p><p><span style="color:brown; font-weight:bolder;">Salesforce</span> completed processing <b>Paypal invoice update via a Batch Job</b>.</p>'
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
            Messaging.sendEmail(mails);*/
    }
    
    
    
    global void updatePaypalInvoice(Invoice__c inv,HttpRequest uReq){
        
        List<Object> items = new List<Object>();
        
        for(Invoice_Line_Item__c Ili:inv.Invoice_Line_Items__r){
            
            Unit_amount ua = new Unit_amount();
            ua.currency_code = 'USD';
            ua.value = Ili.Unit_Price__c;
            
            Item itm = new Item();
            itm.name = Ili.Product__r.Family;
            itm.description = Ili.Description_Line_Item__c;
            itm.quantity = Ili.Quantity__c;
            itm.unit_amount = ua;
            itm.unit_of_measure = 'QUANTITY';
                        
            items.add(itm);      
        }
        
        //String phoneDetails = '[]';
                
        /*if(!String.isBlank(inv.Contact__r.Phone)){
            phoneDetails = '['
                +'"country_code": "866",'
                +'"national_number": "'+inv.Contact__r.Phone+'",'
                +'"phone_type": "HOME"'
            +']';
        }*/
        
        String inv_date = DateTime.newInstance(inv.Date__c.year(), inv.Date__c.month(), inv.Date__c.day()).format('YYYY-MM-dd');
        String due_date = DateTime.newInstance(inv.Due_Date__c.year(), inv.Due_Date__c.month(), inv.Due_Date__c.day()).format('YYYY-MM-dd');        
        
        String reference = (!String.isBlank(inv.P_O_Number__c))?'"reference": "'+inv.P_O_Number__c+'",':'';
        
        String data = '{'
                        +'"id": "'+inv.Paypal_Invoice_Id__c+'",'
                                  +'"status": "SENT",'
                                  +'"detail": {'
                                        +'"invoice_number": "'+inv.Name+'",'
                                        +reference                                      
                                        +'"invoice_date": "'+inv_date+'",'
                                        +'"currency_code": "USD",'
                                        +'"note": "Thank you for your business.",'
                                        +'"terms_and_conditions": "This Invoice sets forth the products/services to be provided by Membean, Inc. (\"Membean\") to the entity referenced above (\"Customer\") and is governed by the terms of the clickwrap \"Terms of Service\" located at http://membean.com/agreement (the \"Agreement\"). Your use of the products/services and/or payment of the fees described above constitutes your acceptance of the Agreement.",'
                                        +'"memo": "This is a long contract",'
                                        +'"payment_term": {'
                                        +'    "term_type": "DUE_ON_DATE_SPECIFIED",'
                                        +'    "due_date": "'+due_date+'"'
                                        +'}'
                                  +'},'
                                  +'"invoicer": {'
                                    +'    "name": {'
                                    +'        "given_name": "Membean,",'
                                    +'        "surname": "Inc."'
                                    +'    },'
                                    +'    "address": {'
                                    +'        "address_line_1": "10940 SW Barnes Road",'
                                    +'        "address_line_2": " #233 Portland",'
                                    +'        "admin_area_1": "OR",'
                                    +'        "postal_code": "97225",'
                                    +'        "country_code": "US"'
                                    +'    },'
                                    +'    "email_address": "accts@membean.com",'
                                    //+'    "email_address": "sb-3bucr2625847@business.example.com",'
                                    +'    "phones": ['
                                    +'        {'
                                    +'            "country_code": "1",'
                                    +'            "national_number": "8669306680",'
                                    +'            "phone_type": "MOBILE"'
                                    +'        }'
                                    +'    ],'
                                    +'    "website": "www.membean.com",'
                                    +'    "logo_url": "https://pics.paypal.com/00/s/MjYwWDg5MFhQTkc/p/ZGM4OTZkMDgtZjYyOC00N2EwLTgwZDMtMDNmNjJkMTE3MThi/image_109.PNG"'                                    
                                  +'},'
                                  +'"primary_recipients": ['
                                    +'    {'
                                    +'        "billing_info": {'
                                    +'            "name": {'
                                    +'                "given_name": "'+inv.Contact__r.Name+'",'
                                    +'                "surname": ""'
                                    +'            },'
                                    +'            "address": {'
                                    +'                "address_line_1": "'+inv.Billing_Street__c+'",'
                                    +'                "admin_area_2": "'+inv.Billing_City__c+'",'
                                    +'                "admin_area_1": "'+inv.Billing_State_Province__c+'",'
                                    +'                "postal_code": "'+inv.Billing_Zip_Postal_Code__c+'",'
                                    +'                "country_code": "US"'
                                    +'            },'
                                    +'            "email_address": "'+inv.Contact__r.Email+'"'
                                    //+'            "phones": '+phoneDetails
                                    +'        }'
                                    +'    }'
                                  +'],'
                                  +'"items": '+JSON.serialize(items)                                
                     +'}';
                      
        
                     uReq.setBody(data);
        
                     Http h = new Http();
                     HttpResponse sendResponse = h.send(uReq);
                     
                     if(sendResponse.getStatusCode() == 200){
                         system.debug(sendResponse.getBody());
                     }
                    
        
    }
    
}