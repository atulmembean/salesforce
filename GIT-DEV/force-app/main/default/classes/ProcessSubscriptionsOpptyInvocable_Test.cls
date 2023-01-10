@IsTest(SeeAllData=true)
public class ProcessSubscriptionsOpptyInvocable_Test
{
  static testMethod void TestMethodPublicSubclosewon()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Years__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      if (a.Subscription_Years__c == Null)
          a.Subscription_Years__c = '2018';
      update a;
      o.StageName = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      update o;
      o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      a = [Select Id,Subscription_Expiry_Month__c,Subscription_Years__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      if (a.Subscription_Years__c == Null)
          a.Subscription_Years__c = '2018';
      update a;
      o.StageName = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOpptyInvocable.ProcessRequest request = new ProcessSubscriptionsOpptyInvocable.ProcessRequest();
      request.opportunityId = o.Id;
      ProcessSubscriptionsOpptyInvocable.ProcessRecord(request);
      Test.StopTest(); 
  }
}