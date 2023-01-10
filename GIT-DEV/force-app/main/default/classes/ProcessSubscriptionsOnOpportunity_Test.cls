@IsTest(SeeAllData=true)
public class ProcessSubscriptionsOnOpportunity_Test
{
  static testMethod void TestMethodPublicSubclosewon()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId,StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE AND Subscription_End_Year__c != Null AND Subscription_Start_Year__c  != Null order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Teacher_Email__c,Parent_Pay__c,Student_Pay__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Teacher_Email__c = Null;
      a.Student_Pay__c = FALSE;
      a.Parent_Pay__c = FALSE;
      update a;
      o.StageName = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      update o;
      o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      a = [Select Id,Subscription_Expiry_Month__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      update a;
      o.StageName = 'Close Won';
      
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateSubclosewon()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, Refund__c, Refunded_Amount__c , StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2022' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,AnnualRevenue__c,Subscription_Years__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.AnnualRevenue__c = 14000;
      if (a.Subscription_Years__c == Null)
          a.Subscription_Years__c = '2021';
      update a;
      o.StageName = 'Close Won';
      o.Refunded_Amount__c = 100;
      o.Subscription_Processed__c = TRUE;
      update o;
      o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2022' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      a = [Select Id,Subscription_Expiry_Month__c,Subscription_Years__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.AnnualRevenue__c = 14000;
      if (a.Subscription_Years__c == Null)
          a.Subscription_Years__c = '2021';
      update a;
      o.StageName = 'Close Won';
      o.Refunded_Amount__c = 100;
      o.Refund__c = 'Full Refund';
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivatePilot()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C != NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      update a;
      o.Pilot_Start_Date__c = System.Today();
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      update o;
      Opportunity onew = o.clone(false,false);
      onew.name = 'test New one';
      onew.Pilot_Start_Date__c = System.Today().addDays(500);
      onew.Pilot_End_Date__c =  System.Today().addDays(550);
      onew.Subscription_Processed__c = TRUE;
      onew.closeDate = System.Today();
      insert onew;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      update o;
      p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivatePilotCloseLost()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C != NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      update a;
      List<Contract> con = [Select Id,AccountId from Contract order by CreatedDate DESC LIMIT 3];
      List<Contract> colst = New List<Contract>();
      for (Contract co :con)
      {
          co.AccountId = a.Id;
          colst.add(co);
      }
      update colst;
      o.Pilot_Start_Date__c = System.Today();
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      o.StageName = 'Close Lost';
      update o;
      Opportunity onew = o.clone(false,false);
      onew.name = 'test New one';
      onew.AccountId = a.Id;
      onew.Pilot_Start_Date__c = System.Today().addDays(40);
      onew.Pilot_End_Date__c =  System.Today().addDays(50);
      onew.Amount= 1000;
      onew.closeDate = System.Today();
      insert onew;
      onew = o.clone(false,false);
      onew.name = 'test New two';
      onew.AccountId = a.Id;
      onew.Pilot_Start_Date__c = System.Today().addDays(60);
      onew.Pilot_End_Date__c =  System.Today().addDays(70);
      onew.closeDate = System.Today();
      onew.Amount= 1000;
      insert onew;
      onew = o.clone(false,false);
      onew.name = 'test New three';
      onew.AccountId = a.Id;
      onew.Subscription_Start_Year__c = '2020';
      onew.Subscription_End_Year__c = '2021';
      onew.Amount=10000;
      onew.Stagename = 'Close Won';
      onew.Subscription_Processed__c = TRUE;
      onew.closeDate = System.Today();
      insert onew;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      update o;
      p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateNotcustomer()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Account.Subscription_Status__c != 'Customer' AND Subscription_End_Year__c = Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C != NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c from Account where Id = :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      update a;
      o.Pilot_Start_Date__c = System.Today();
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      update o;
      Opportunity onew = o.clone(false,false);
      onew.name = 'test New two';
      onew.Pilot_Start_Date__c = System.Today().addDays(500);
      onew.Pilot_End_Date__c =  System.Today().addDays(550);
      onew.Subscription_Processed__c = TRUE;
      onew.closeDate = System.Today();
      insert onew;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateCustomerNoSubscriptionExpirayDt()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId,StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Account.Subscription_Status__c = 'Customer' AND Subscription_End_Year__c = Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C != NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c from Account where Id = :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = null;
      update a;
      o.Pilot_Start_Date__c = System.Today();
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateSubclosewonAccountSEDtNull()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = Null;
      update a;
      o.StageName = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      update o;
      
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateSubclosewonAccountSEDtFuture()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c,AnnualRevenue__c,No_Of_Students__c,No_Of_Teachers__c,parent_Pay__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = System.Today().addDays(1555);
      a.AnnualRevenue__c = Null;
      a.No_Of_Students__c =  Null;
      a.No_Of_Teachers__c =  Null;
      a.parent_Pay__c = TRUE;
      update a;
      o.Stagename = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      update o;
      
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateSubclosewonAccountSEDtFuture1()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, Student_Pay__c, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c,AnnualRevenue__c,No_Of_Students__c,No_Of_Teachers__c,parent_Pay__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = System.Today().addDays(1555);
      a.AnnualRevenue__c = 10000;
      a.No_Of_Students__c =  100;
      a.No_Of_Teachers__c =  50;
      a.parent_Pay__c = FALSE;
      update a;
      o.Stagename = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      o.Student_Pay__c = TRUE;
      update o;
      
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateSubcloselostAccountSEDtFuture1()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, CloseDate,Student_Pay__c,Loss_Reason__c,Lost_Reason__c,StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName = 'Close Won' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c,AnnualRevenue__c,No_Of_Students__c,No_Of_Teachers__c,parent_Pay__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      //a.Subscription_Expiry_Date1__c = System.Today().addDays(1555);
      a.AnnualRevenue__c = 1000000;
      a.No_Of_Students__c =  1000;
      a.No_Of_Teachers__c =  500;
      a.parent_Pay__c = FALSE;
      update a;
      o.StageName = 'Close Lost';
      o.Subscription_Processed__c = TRUE;
      o.CloseDate = System.Today();
      o.Loss_Reason__c =  'Other';
      o.Lost_Reason__c = 'Test';
      update o;
      
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodRefund()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, CloseDate,Student_Pay__c,Loss_Reason__c,Lost_Reason__c,StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = '2021' AND Account_RecordType__C = 'Private School' AND Amount > 0 AND StageName = 'Close Won' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c,AnnualRevenue__c,No_Of_Students__c,No_Of_Teachers__c,parent_Pay__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      //a.Subscription_Expiry_Date1__c = System.Today().addDays(1555);
      a.AnnualRevenue__c = 1000000;
      a.No_Of_Students__c =  1000;
      a.No_Of_Teachers__c =  500;
      a.parent_Pay__c = FALSE;
      update a;
      o.Refund__c = 'Full Refund';
      o.Refunded_Amount__c = 1;
      o.Subscription_Processed__c = TRUE;
      update o;
      
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateCustomerTempMembeanExtensionDt()
  {
      Test.startTest();
      Opportunity o = [Select Id,Temporary_Membean_Extension_Date__c,AccountId,StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Account.Subscription_Status__c = 'Customer' AND Subscription_End_Year__c = Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C != NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c from Account where Id = :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = null;
      update a;
      o.Pilot_Start_Date__c = System.Today();
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Temporary_Membean_Extension_Date__c = System.Today().addDays(39);
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivateCustomerTempMembeanExtensionDt1()
  {
      Test.startTest();
      Opportunity o = [Select Id,Temporary_Membean_Extension_Date__c,AccountId,StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Account.Subscription_Status__c = 'Customer' AND Subscription_End_Year__c = Null AND (Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C != NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c from Account where Id = :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = null;
      a.Membean_Expires_On__c = System.Today().addDays(18);
      update a;
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodPrivatePilotclosewon()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c = Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C != NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c,Membean_Expires_On__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = Null;
      a.Membean_Expires_On__c = Null;
      update a;
      o.Pilot_Start_Date__c = System.Today();
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      update o;
      Opportunity onew = o.clone(false,false);
      onew.name = 'test New one';
      onew.Pilot_Start_Date__c = System.Today().addDays(500);
      onew.Pilot_End_Date__c =  System.Today().addDays(550);
      onew.Subscription_Processed__c = TRUE;
      onew.closeDate = System.Today();
      insert onew;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      o.Pilot_End_Date__c =  System.Today().addDays(35);
      o.Subscription_Processed__c = TRUE;
      update o;
      p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodlueBirdSchoolsclosewon()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c != Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c,Membean_Expires_On__c,Subscription_Years__c,Pilot_Years__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      a.Subscription_Expiry_Date1__c = Null;
      a.Membean_Expires_On__c = Null;
      a.Subscription_Years__c = Null;
      a.Pilot_Years__c = Null;
      update a;
      o.StageName = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      
      Test.StopTest(); 
  }
  
  static testMethod void TestMethodlueBirdSchoolsclosewonexpired()
  {
      Test.startTest();
      Opportunity o = [Select Id, AccountId, StageName,Pilot_Start_Date__c,Pilot_End_Date__c from Opportunity where Subscription_End_Year__c != Null AND (Account_RecordType__C = 'Private School' OR Account_RecordType__C = 'Public School') AND StageName != 'Close Won' AND StageName != 'Close Lost' AND Pilot_End_Date__C = NULL AND Subscription_Processed__c = FALSE order by CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Expiry_Month__c,Subscription_Expiry_Date1__c,Membean_Expires_On__c,Subscription_Years__c,Pilot_Years__c from Account where Id =  :o.AccountId];
      a.Subscription_Expiry_Month__c = 'August';
      Date daten = System.Today();
      a.Subscription_Expiry_Date1__c = daten.addDays(-30);
      a.Membean_Expires_On__c = daten.addDays(-30);
      a.Pilot_Years__c = Null;
      update a;
      o.StageName = 'Close Won';
      o.Subscription_Processed__c = TRUE;
      update o;
      ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
      Database.ExecuteBatch(p,3);
      
      Test.StopTest(); 
  }
}