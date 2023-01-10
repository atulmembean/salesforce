@IsTest(SeeAllData=true)
public class ContractTrigger_Test
{
  static testMethod void TestMethod1()
  {
      Opportunity o = [Select Id,AccountId from Opportunity where StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__c = Null order by CreatedDate DESC LIMIT 1];
      Contract c = New Contract();
      c.Subscription_Start_Year__c = String.valueOf(System.Today().Year());
      c.Subscription_End_Year__c = String.valueOf(System.Today().Year()+1);
      c.No_Of_Students__c = 10;
      c.No_Of_Teachers__c = 2;
      c.AccountId = o.AccountId;
      insert c;
      c.No_Of_Teachers__c =4;
      update c;
      delete c;
  }
}