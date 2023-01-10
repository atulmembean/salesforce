@isTest(seeAllData=true)
public class QuoteTriggerHandler_Test{
  
 public static testmethod void methodtestPublic(){
        List<Quote> q = [Select Id,Status from Quote where Status != 'Accepted' AND Opportunity.Account.RecordType.Name =  'Public School' Order by CreatedDate DESC LIMIT 1];
        Test.Starttest();
        q[0].Status = 'Accepted';
        update q[0];
        q[0].status = 'Presented';
        update q[0];
        Test.StopTest();
 }
 public static testmethod void methodtestPublicPresented(){
        List<Quote> q = [Select Id,Status,Opportunity.AccountId from Quote where Status = 'Accepted' AND Opportunity.Account.RecordType.Name =  'Public School' Order by CreatedDate DESC LIMIT 1];
        Test.Starttest();
        q[0].status = 'Presented';
        update q[0];
        Account a = [Select Id, Tax_Exempt__c,Tax__c from Account where Id = :q[0].Opportunity.AccountId];
        a.Tax_Exempt__c = FALSE;
        a.Tax__c = 6;
        update a;
        List<QuoteLineItem> qli = [Select Id,Quantity from QuotelineItem where QuoteId = :q[0].Id];
        if (qli.Size()>0)
        {
            qli[0].Quantity = 123;
            update qli[0];
        }
        Test.StopTest();
 }
 public static testmethod void methodtestPublicRejected(){
        List<Quote> q = [Select Id,Status,Opportunity.AccountId from Quote where Status = 'Accepted' AND Opportunity.Account.RecordType.Name =  'Public School' Order by CreatedDate DESC LIMIT 1];
        Test.Starttest();
        Account a = [Select Id, Tax_Exempt__c,Tax__c from Account where Id = :q[0].Opportunity.AccountId];
        a.Tax_Exempt__c = FALSE;
        a.Tax__c = 6;
        update a;
        q[0].status = 'Rejected';
        update q[0];
        Test.StopTest();
 }
 public static testmethod void methodtestDistrict(){
        List<Quote> q = [Select Id,Status from Quote where Status != 'Accepted' AND Opportunity.Account.RecordType.Name =  'District' Order by CreatedDate DESC LIMIT 1];
        Test.Starttest();
        q[0].Status = 'Accepted';
        update q[0];
        q[0].status = 'Presented';
        update q[0];
        Test.StopTest();
 }
}