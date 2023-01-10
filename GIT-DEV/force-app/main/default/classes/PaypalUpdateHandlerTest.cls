@isTest(SeeAllData=TRUE)
public class PaypalUpdateHandlerTest {
    
    /*@testSetup static void setup(){
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
        c.Phone = '8094382192';
        c.Email = 'abc@xyz.com';
        
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
        inv.Paypal_status__c = 'Sent';
        insert inv;
        
        inv.Paypal_status__c = 'Sent';
        inv.Paypal_Invoice__c = '';
        inv.paypal_send_url__c = '';
        inv.Paypal_Invoice_Id__c = 'abcd';
        
        update inv;
    }*/
    
    @isTest static void validatePaypalUpdateTrigger(){
        
        Database.BatchableContext BC;
        
        SingleRequestMock res = new SingleRequestMock(200,'OK','{"scope": "https://uri.paypal.com/services/invoicing https://uri.paypal.com/services/disputes/read-buyer https://uri.paypal.com/services/payments/realtimepayment https://uri.paypal.com/services/disputes/update-seller https://uri.paypal.com/services/payments/payment/authcapture openid https://uri.paypal.com/services/disputes/read-seller https://uri.paypal.com/services/payments/refund https://api.paypal.com/v1/vault/credit-card https://api.paypal.com/v1/payments/.* https://uri.paypal.com/payments/payouts https://api.paypal.com/v1/vault/credit-card/.* https://uri.paypal.com/services/subscriptions https://uri.paypal.com/services/applications/webhooks","access_token": "A21AAECGwXimulfBXrIxG-e7-xht6SpBJv0bwfXt7AX3EVgb3FXRXIZX3zT5qw-0dCQxUGybUALeEtb_GzB9ToOj72hlJLZVw","token_type": "Bearer","app_id": "APP-80W284485P519543T","expires_in": 32400,"nonce": "2020-05-01T13:14:19ZpPltRaMoQr-b3CzoXM7V3yz105akh4yO_ge18ZiPNws"}',null);
        
        List<Invoice__c> inv = [Select Id,Name,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Paypal_status__c,Date__c,Due_Date__c,Paypal_Invoice__c,paypal_send_url__c,Paypal_Invoice_Id__c,Contact__r.Phone,Contact__r.Email,Contact__r.Name,P_O_Number__c from Invoice__c order by createdDate DESC LIMIT 1];
                       
        PaypalUpdateHandler puh = new PaypalUpdateHandler(inv);
        

        Test.setMock(HttpCalloutMock.class, res);
        List<Invoice__c> invs = puh.start(BC);
        Test.startTest();
        puh.execute(BC,invs);
        puh.finish(BC);
        Test.stopTest();
    }
    
}