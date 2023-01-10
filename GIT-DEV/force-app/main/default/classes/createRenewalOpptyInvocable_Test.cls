@isTest(SEEALLDATA=TRUE)
public class createRenewalOpptyInvocable_Test
{
    static testMethod void TestMethodOppty()
    {
        Quote q = [Select Id,OpportunityId from Quote where Status = 'Accepted' AND Opportunity.StageName = 'Close Won' order by createdDate DESC LIMIT 1];
        Opportunity o = [Select Id from Opportunity where Id = :q.OpportunityId];
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        request.opportunityId = o.Id;
        Test.startTest();
        createRenewalOpptyInvocable.ProcessRecord(request);
        Test.stopTest();
          
    }
    static testMethod void TestMethodOpptyCommitduration()
    {
        Quote q = [Select Id,OpportunityId from Quote where Status = 'Accepted' AND Opportunity.Commitment_Duration__c > 1 AND Opportunity.zDiscountAnnual__c > 1 AND Opportunity.StageName = 'Close Won' order by createdDate DESC LIMIT 1];
        Opportunity o = [Select Id from Opportunity where Id = :q.OpportunityId];
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        request.opportunityId = o.Id;
        Test.startTest();
        createRenewalOpptyInvocable.ProcessRecord(request);
        Test.stopTest();
          
    }
    static testMethod void TestMethodQuote()
    {
        Quote q = [Select Id,OpportunityId from Quote where Status = 'Accepted' AND Opportunity.StageName = 'Close Won' order by createdDate DESC LIMIT 1];
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        request.quoteId = q.Id;
        Test.startTest();
        createRenewalOpptyInvocable.ProcessRecord(request);
        Test.stopTest();
          
    }
    
    static testMethod void testmethodPaymentJan(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'January';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentFeb(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'February';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentMar(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'March';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentApr(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'April';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentMay(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'May';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentJun(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'June';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentJul(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'July';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentAug(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'August';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentSep(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'September';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentOct(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'October';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        
        Test.stopTest();
    }
    static testMethod void testmethodPaymentNov(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'November';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        request.paymentId = pay.Id;
        createRenewalOpptyInvocable.ProcessRecord(request);
        Test.stopTest();
    }
    static testMethod void testmethodPaymentDec(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'December';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        request.paymentId = pay.Id;
        createRenewalOpptyInvocable.ProcessRecord(request);
        Test.stopTest();
    }
    static testMethod void testmethodPaymentDecDistrictAccount(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' AND Quote__r.Opportunity.Account.RecordType.Name = 'District' Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'December';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        request.paymentId = pay.Id;
        createRenewalOpptyInvocable.ProcessRecord(request);
        Test.stopTest();
    } 
    static testMethod void testmethodPaymentDecDistrictAccountMultiYear(){
        Test.startTest();
                
        Invoice__c InvObj = [Select Id,Quote__c,Quote__r.Opportunity.AccountId from Invoice__c where STatus__c != 'Sent' AND Quote__r.Opportunity.Account.RecordType.Name = 'District' AND Quote__r.Commitment_Duration__c > 0 Order by CreatedDate DESC LIMIT 1];
        Account AccountObj = [Select Id, Subscription_Expiry_Month__c from Account where Id = :InvObj.Quote__r.Opportunity.AccountId LIMIT 1];       
             
        Payment__c pay = New Payment__c();
        createRenewalOpptyInvocable.ProcessRequest request = new createRenewalOpptyInvocable.ProcessRequest();
        
        AccountObj.Subscription_Expiry_Month__c =  'December';
        update AccountObj;
        pay = New Payment__c();
        pay.Amount__c = 10;
        pay.Invoice__c = InvObj.Id;
        pay.Payment_Date__c = System.Today();
        pay.Payment_Mode__c = 'Check';
        pay.Status__c = 'Paid';
        insert pay;
        request.paymentId = pay.Id;
        createRenewalOpptyInvocable.ProcessRecord(request);
        Test.stopTest();
    } 

}