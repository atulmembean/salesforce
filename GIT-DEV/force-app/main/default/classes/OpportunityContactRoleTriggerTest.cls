@isTest
public class OpportunityContactRoleTriggerTest {
        
    @testSetup static void setup(){
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
        
    }
 
    static testMethod void validateUpdateOppActivityLog(){
        
        Opportunity opp = [select Id,Teacher__c from Opportunity order by createdDate DESC limit 1];
        
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.OpportunityId = opp.Id;
        ocr.ContactId = opp.Teacher__c;
        ocr.Role = 'Influencer';
        
        Test.startTest();
        insert ocr;        
        update ocr;
        Test.stopTest();
                
    }
        
}