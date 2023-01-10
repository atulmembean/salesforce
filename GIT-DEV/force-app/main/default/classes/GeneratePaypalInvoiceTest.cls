@isTest(SEEALLDATA=TRUE)
private class GeneratePaypalInvoiceTest {

    /*@testSetup static void setup()
    {
               
        Account acc = new Account();
        acc.Name = 'Test School';
        acc.Low_Grade__c = 'K';
        acc.High_Grade__c = 'T';
        acc.Subscription_Expiry_Month__c = 'August';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
        
        insert acc;
                        
        Contact c = new Contact();
        c.FirstName = 'Shantanu';
        c.LastName = 'Kumar';
        c.AccountId = acc.Id;
        
        insert c;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunitiy';
        opp.Type = 'Regular';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today();
        opp.Subscription_Start_Year__c = '2019';
        opp.Subscription_End_Year__c = '2020';
        opp.AccountId = acc.Id;
        opp.Teacher__c = c.Id;
        
        insert opp;
        
        Quote qu = new Quote();
        qu.Name = 'Test Quote';
        qu.OpportunityId = opp.Id;
        qu.Status = 'Accepted';
        qu.Subscription_Start_Year__c = '2020';
        qu.Subscription_End_Year__c = '2021';
        
        insert qu;
        
        Invoice__c inv = new Invoice__c();
        inv.Subscription_Month__c = 6;
        inv.Subscription_Expiry_Month__c = 'August';
        inv.Date__c = Date.today();
        inv.Due_Date__c = Date.today().addDays(30);
        inv.Subscription_Start_Date__c = Date.today();
        inv.Quote__c = qu.Id;
        inv.Accountname_relatedlist__c = acc.Id;
        inv.Account_of_Contact__c = acc.Id;
        inv.Account__c = acc.id;
        inv.Contact__c = c.Id;
        insert inv;

        
    }*/
    
    static testMethod void validateGetInvoiceStatus()
    {           
        Test.startTest();
        Invoice__c invoice = [Select Id from Invoice__c where paypal_send_url__c = Null order by createdDate DESC LIMIT 1];                
        GeneratePaypalInvoice.getInvoiceStatus(invoice.Id);
        Test.stopTest();
    }
    
    static testMethod void validateGetInvoiceDetails()
    {
        Test.startTest();
        Invoice__c invoice = [Select Id from Invoice__c where paypal_send_url__c = Null order by createdDate DESC LIMIT 1];        
        GeneratePaypalInvoice.getInvoiceDetails(invoice.Id);
        Test.stopTest();
    }
    
    @isTest static void validateCreatePaypalInvoice()
    {

        /*SingleRequestMock res1 = new SingleRequestMock(200,'OK','{"scope": "https://uri.paypal.com/services/invoicing https://uri.paypal.com/services/disputes/read-buyer https://uri.paypal.com/services/payments/realtimepayment https://uri.paypal.com/services/disputes/update-seller https://uri.paypal.com/services/payments/payment/authcapture openid https://uri.paypal.com/services/disputes/read-seller https://uri.paypal.com/services/payments/refund https://api.paypal.com/v1/vault/credit-card https://api.paypal.com/v1/payments/.* https://uri.paypal.com/payments/payouts https://api.paypal.com/v1/vault/credit-card/.* https://uri.paypal.com/services/subscriptions https://uri.paypal.com/services/applications/webhooks","access_token": "A21AAECGwXimulfBXrIxG-e7-xht6SpBJv0bwfXt7AX3EVgb3FXRXIZX3zT5qw-0dCQxUGybUALeEtb_GzB9ToOj72hlJLZVw","token_type": "Bearer","app_id": "APP-80W284485P519543T","expires_in": 32400,"nonce": "2020-05-01T13:14:19ZpPltRaMoQr-b3CzoXM7V3yz105akh4yO_ge18ZiPNws"}',null);

        SingleRequestMock res2 = new SingleRequestMock(201,'OK','{"rel": "self","href": "https://api.sandbox.paypal.com/v2/invoicing/invoices/INV2-REC6-TCTL-LV3L-T4PD","method": "GET"}',null);
                
        SingleRequestMock res3 = new SingleRequestMock(200,'OK','{"id": "INV2-Z56S-5LLA-Q52L-CPZ5","status": "DRAFT","detail": {"invoice_number": "#123","reference": "deal-ref","invoice_date": "2018-11-12","currency_code": "USD","note": "Thank you for your business.","term": "No refunds after 30 days.","memo": "This is a long contract","payment_term": {"term_type": "NET_10","due_date": "2018-11-22"},"metadata": {"create_time": "2018-11-12T08:00:20Z","recipient_view_url": "https://www.api.paypal.com/invoice/p#Z56S5LLAQ52LCPZ5","invoicer_view_url": "https://www.api.paypal.com/invoice/details/INV2-Z56S-5LLA-Q52L-CPZ5"}},"invoicer": {"name": {"given_name": "David","surname": "Larusso"},"address": {"address_line_1": "1234 First Street","address_line_2": "337673 Hillside Court","admin_area_2": "Anytown","admin_area_1": "CA","postal_code": "98765","country_code": "US"},"email_address": "merchant@example.com","phones": [{"country_code": "001","national_number": "4085551234","phone_type": "MOBILE"}],"website": "https://example.com","tax_id": "ABcNkWSfb5ICTt73nD3QON1fnnpgNKBy-Jb5SeuGj185MNNw6g","logo_url": "https://example.com/logo.PNG","additional_notes": "2-4"},"primary_recipients": [{"billing_info": {"name": {"given_name": "Stephanie","surname": "Meyers"},"address": {"address_line_1": "1234 Main Street","admin_area_2": "Anytown","admin_area_1": "CA","postal_code": "98765","country_code": "US"},"email_address": "bill-me@example.com","phones": [{"country_code": "001","national_number": "4884551234","phone_type": "HOME"}],"additional_info_value": "add-info"},"shipping_info": {"name": {"given_name": "Stephanie","surname": "Meyers"},"address": {"address_line_1": "1234 Main Street","admin_area_2": "Anytown","admin_area_1": "CA","postal_code": "98765","country_code": "US"}}}],"items": [{"name": "Yoga Mat","description": "Elastic mat to practice yoga.","quantity": "1","unit_amount": {"currency_code": "USD","value": "50.00"},"tax": {"name": "Sales Tax","percent": "7.25","amount": {"currency_code": "USD","value": "3.27"}},"discount": {"percent": "5","amount": {"currency_code": "USD","value": "2.5"}},"unit_of_measure": "QUANTITY"},{"name": "Yoga T Shirt","quantity": "1","unit_amount": {"currency_code": "USD","value": "10.00"},"tax": {"name": "Sales Tax","percent": "7.25","amount": {"currency_code": "USD","value": "0.34"}},"discount": {"amount": {"currency_code": "USD","value": "5.00"}},"unit_of_measure": "QUANTITY"}],"configuration": {"partial_payment": {"allow_partial_payment": true,"minimum_amount_due": {"currency_code": "USD","value": "20.00"}},"allow_tip": true,"tax_calculated_after_discount": true,"tax_inclusive": false,"template_id": "TEMP-19V05281TU309413B"},"amount": {"currency_code": "USD","value": "74.21","breakdown": {"item_total": {"currency_code": "USD","value": "60.00"},"custom": {"label": "Packing Charges","amount": {"currency_code": "USD","value": "10.00"}},"shipping": {"amount": {"currency_code": "USD","value": "10.00"},"tax": {"name": "Sales Tax","percent": "7.25","amount": {"currency_code": "USD","value": "0.73"}}},"discount": {"item_discount": {"currency_code": "USD","value": "-7.50"},"invoice_discount": {"percent": "5","amount": {"currency_code": "USD","value": "-2.63"}}},"tax_total": {"currency_code": "USD","value": "4.34"}}},"due_amount": {"currency_code": "USD","value": "74.21"},"links": [{"href": "https://api.paypal.com/v2/invoicing/invoices/INV2-Z56S-5LLA-Q52L-CPZ5","rel": "self","method": "GET"},{"href": "https://api.paypal.com/v2/invoicing/invoices/INV2-Z56S-5LLA-Q52L-CPZ5/send","rel": "send","method": "POST"},{"href": "https://api.paypal.com/v2/invoicing/invoices/INV2-Z56S-5LLA-Q52L-CPZ5/update","rel": "replace","method": "PUT"},{"href": "https://api.paypal.com/v2/invoicing/invoices/INV2-Z56S-5LLA-Q52L-CPZ5","rel": "delete","method": "DELETE"},{"href": "https://api.paypal.com/v2/invoicing/invoices/INV2-Z56S-5LLA-Q52L-CPZ5/payments","rel": "record-payment","method": "POST"},{"href": "https://api.paypal.com/v2/invoicing/invoices/INV2-Z56S-5LLA-Q52L-CPZ5/generate-qr-code","rel": "qr-code","method": "POST"}]}',null);
          
        
        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        
        endpoint2TestResp.put('https://api.sandbox.paypal.com/v1/oauth2/token',res1);
        endpoint2TestResp.put('https://api.sandbox.paypal.com/v2/invoicing/invoices/',res2);
        endpoint2TestResp.put('https://api.sandbox.paypal.com/v2/invoicing/invoices/INV2-Z56S-5LLA-Q52L-CPZ5',res3);    
 
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);*/
                
        Test.startTest();
        Invoice__c invoice = [Select Id,Name from Invoice__c where paypal_send_url__c = Null order by createdDate DESC LIMIT 1];
        String invoice_data = '{"detail": {"invoice_number": "'+invoice.Name+'","reference": "deal-ref","invoice_date": "2018-11-12","currency_code": "USD","note": "Thank you for your business.","term": "No refunds after 30 days.","memo": "This is a long contract","payment_term": {"term_type": "NET_10","due_date": "2018-11-22"}},"invoicer": {"name": {"given_name": "David","surname": "Larusso"},"address": {"address_line_1": "1234 First Street","address_line_2": "337673 Hillside Court","admin_area_2": "Anytown","admin_area_1": "CA","postal_code": "98765","country_code": "US"},"email_address": "merchant@example.com","phones": [{"country_code": "001","national_number": "4085551234","phone_type": "MOBILE"}],"website": "www.test.com","tax_id": "ABcNkWSfb5ICTt73nD3QON1fnnpgNKBy- Jb5SeuGj185MNNw6g","logo_url": "https://example.com/logo.PNG","additional_notes": "2-4"},"primary_recipients": [{"billing_info": {"name": {"given_name": "Stephanie","surname": "Meyers"},"address": {"address_line_1": "1234 Main Street","admin_area_2": "Anytown","admin_area_1": "CA","postal_code": "98765","country_code": "US"},"email_address": "bill-me@example.com","phones": [{"country_code": "001","national_number": "4884551234","phone_type": "HOME"}],"additional_info_value": "add-info"},"shipping_info": {"name": {"given_name": "Stephanie","surname": "Meyers"},"address": {"address_line_1": "1234 Main Street","admin_area_2": "Anytown","admin_area_1": "CA","postal_code": "98765","country_code": "US"}}}],"items": [{"name": "Yoga Mat","description": "Elastic mat to practice yoga.","quantity": "1","unit_amount": {"currency_code": "USD","value": "50.00"},"tax": {"name": "Sales Tax","percent": "7.25"},"discount": {"percent": "5"},"unit_of_measure": "QUANTITY"},{"name": "Yoga t-shirt","quantity": "1","unit_amount": {"currency_code": "USD","value": "10.00"},"tax": {"name": "Sales Tax","percent": "7.25"},"discount": {"amount": {"currency_code": "USD","value": "5.00"}},"unit_of_measure": "QUANTITY"}],"configuration": {"partial_payment": {"allow_partial_payment": true,"minimum_amount_due": {"currency_code": "USD","value": "20.00"}},"allow_tip": true,"tax_calculated_after_discount": true,"tax_inclusive": false,"template_id": "TEMP-19V05281TU309413B"},"amount": {"breakdown": {"custom": {"label": "Packing Charges","amount": {"currency_code": "USD","value": "10.00"}},"shipping": {"amount": {"currency_code": "USD","value": "10.00"},"tax": {"name": "Sales Tax","percent": "7.25"}},"discount": {"invoice_discount": {"percent": "5"}}}}}';
        //Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        GeneratePaypalInvoice.createPaypalInvoice(invoice_data,invoice.Id);
        Test.stopTest();
    }
        
    
}