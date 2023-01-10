public class UpdatePaypalInvoice
{
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
@future (callout = true)
public static void updatePaypalInv(String invId)
{
    system.debug('Inside updatePaypalInv :::');
    system.debug('invId::: ' + invId);
    
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

            Httprequest uReq = New HttpRequest();
            Invoice__c inv = New Invoice__c();
            List<Invoice__c> scope = [select Id,Name,Terms_and_Conditions__c,Contact__r.Phone,Contact__r.FirstName,Contact__r.LastName,Due_Date__c,Date__c,Contact__r.Name,Contact__r.Email,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Billing_Country__c,Paypal_Invoice_Id__c,P_O_Number__c,(select Id,Name,Product__r.Family,Description_Line_Item__c,Quantity__c,Unit_Price__c from Invoice_Line_Items__r) from Invoice__c where Id = :invId];
            String cCode = 'US';
            List<Country_Master__c> countrylst = New List<Country_Master__c>();
            for(Invoice__c sc:scope){
                countrylst = New List<Country_Master__c>();
                countrylst = [Select Name, Country_Code__c from Country_Master__c where Name = :sc.Billing_Country__c];
                if (countrylst.Size()>0)
                {
                    cCode = countrylst[0].Country_Code__c;
                }
                system.debug(sc.Paypal_Invoice_Id__c);
                if(!String.isBlank(sc.Paypal_Invoice_Id__c) || Test.isRunningTest()){
                    updateReq.setEndpoint('https://api.paypal.com/v2/invoicing/invoices/'+sc.Paypal_Invoice_Id__c);
                    //updateReq.setEndpoint('https://api.sandbox.paypal.com/v1/oauth2/token'+sc.Paypal_Invoice_Id__c);
                    //updatePaypalInvoice(sc,updateReq);
                   inv = sc;
                   uReq = updateReq;
              if (sc.Billing_Country__c == 'China')
                  cCode = 'C2';      
        
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
            system.debug('Items::: ' + items);     
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
                                        //+'"terms_and_conditions": "This Invoice sets forth the products/services to be provided by Membean, Inc. (\"Membean\") to the entity referenced above (\"Customer\") and is governed by the terms of the clickwrap \"Terms of Service\" located at http://membean.com/agreement (the \"Agreement\"). Your use of the products/services and/or payment of the fees described above constitutes your acceptance of the Agreement.",'
                                        +'"terms_and_conditions": "'+inv.Terms_and_Conditions__c+'",'
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
                                    //+'        "country_code": "' +cCode+'"'
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
                                    +'                "given_name": "'+inv.Contact__r.FirstName+'",'
                                    //+'                "surname": ""'
                                    +'                "surname": "'+inv.Contact__r.LastName+'"'
                                    +'            },'
                                    +'            "address": {'
                                    +'                "address_line_1": "'+inv.Billing_Street__c+'",'
                                    +'                "admin_area_2": "'+inv.Billing_City__c+'",'
                                    +'                "admin_area_1": "'+inv.Billing_State_Province__c+'",'
                                    +'                "postal_code": "'+inv.Billing_Zip_Postal_Code__c+'",'
                                    //+'                "country_code": "US"'
                                    +'        "country_code": "' +cCode+'"'
                                    +'            },'
                                    //+'            "email_address": "'+inv.Contact__r.Email+'"'
                                    +'            "email": "'+inv.Contact__r.Email+'"'
                                    //+'            "phones": '+phoneDetails
                                    +'        }'
                                    +'    }'
                                  +'],'
                                  +'"items": '+JSON.serialize(items)                                
                     +'}';
                      
                     system.debug('data::: ' + data);
                     uReq.setBody(data);
                     system.debug('uReq:::' + uReq);
                     h = new Http();
                     HttpResponse sendResponse = h.send(uReq);
                     system.debug(sendResponse.getBody());
                     if(sendResponse.getStatusCode() == 200){
                         system.debug(sendResponse.getBody());
                     }
                        
                }                    
            }
            
        }

}
}