@IsTest(SeeAllData=true)
public class OpportunityTriggerHandler_Test
{
  static testmethod void pilotconversion()
  {
      test.startTest();
      Date today = system.Today();
      OpportunityService.runBeforeTriggerCount = 1;
      Opportunity o = [Select Id,Pilot_End_Date__c,StageName from Opportunity where StageName != 'Close Won' AND Account.RecordType.Name = 'Public School' AND Pilot_End_Date__c > :today ORDER BY CreatedDate DESC LIMIT 1];
      o.Pilot_End_Date__c = o.Pilot_End_Date__c.addDays(30);
      o.StageName = 'Close Won';
      update o;
      Test.stopTest();
  }
  
  static testmethod void pilotconversionpublicSchoolidnull()
  {
      test.startTest();
      Date today = system.Today();
      Opportunity o = [Select Id,Pilot_End_Date__c,StageName,AccountId,Teacher__c from Opportunity where StageName != 'Close Won' AND Account.RecordType.Name = 'Public School' AND Pilot_End_Date__c > :today ORDER BY CreatedDate DESC LIMIT 1];
      Account a = [Select Id,School_Id__c from Account where Id = :o.AccountId];
      a.School_Id__c = Null;
      update a;
      o.Pilot_Start_Date__c = System.Today().addDays(-30);
      o.Pilot_End_Date__c = System.Today().addDays(-3);
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      Contact c = [Select Id from Contact where Role__c IN ('English Teacher') order by createddate desc limit 1];
      o.Teacher__c = c.Id;
      o.StageName = 'Close Won';
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      Test.stopTest();
  }
  
  static testmethod void pilotdateupdateoppty()
  {
      test.startTest();
      Date today = system.Today();
      Opportunity o = [Select Id,Pilot_End_Date__c,StageName from Opportunity where Start_Pilot__c = TRUE AND Is_Parent__c = FALSE AND StageName != 'Close Won' AND Account.RecordType.Name = 'Public School' AND Pilot_End_Date__c > :today ORDER BY CreatedDate DESC LIMIT 1];
      o.Pilot_End_Date__c = o.Pilot_End_Date__c.addDays(30);
      o.StageName = 'Close Won';
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      Test.stopTest();
  }
  
  static testMethod void createoptycontactrole() {
        Contact c = [select Id,Name,AccountId from Contact where Role__c = 'Teacher' AND AccountId != Null LIMIT 1];
        Id RecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        Opportunity o = New Opportunity();
        o.Name = 'test';
        o.Teacher__c = c.Id;
        o.CloseDate = System.Today().addDays(15);
        o.RecordTypeId = RecTypeId;
        o.Cloned_Opportunity_To_Process__c = FALSE;
        
        o.AccountId = c.AccountId;
        o.Stagename = 'Prospecting';
        o.Parent_Opportunity__c = Null;
        OpportunityService.runBeforeTriggerCount = 1;
        insert o;    
    }
  
  static testMethod void TestMethodupdateAccount()
  {
      Test.startTest();
      Opportunity o = [Select Id,Subscription_End_Year__c,AccountId from Opportunity where StageName = 'Close Won' AND Account.RecordType.Name = 'Public School' ORDER BY CreatedDate DESC LIMIT 1];
      o.Temporary_Membean_Extension_Date__c = system.Today();
      Account a = [Select Id,Membean_Expires_On__c,School_ID__c from Account where ID = :o.AccountId];
      a.Membean_Expires_On__c = Null;
      a.School_ID__c = 'estnew';
      update a;
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      Test.stopTest();
  }
  
  static testMethod void TestMethodupdatemembeanExpires()
  {
      Test.startTest();
      Opportunity o = [Select Id,Subscription_End_Year__c from Opportunity where StageName = 'Close Won' AND Account.RecordType.Name = 'Public School' ORDER BY CreatedDate DESC LIMIT 1];
      o.Subscription_End_Year__c = String.valueOf(integer.valueOf(o.Subscription_End_Year__c)+1);
      o.Temporary_Membean_Extension_Date__c = system.Today().addDays(24);
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      Id RecTypeId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
      Contact c1 = [select Id,Name,AccountId from Contact where Role__c = 'Teacher' AND AccountId != Null AND Account.RecordType.Name = 'Public School' AND Account.School_ID__c != Null LIMIT 1];
      Account a = [Select Id,membean_Expires_On__c from Account where Id = :c1.AccountId];
      a.membean_Expires_On__c = Null;
      update a;
      Opportunity o1 = New Opportunity();
        o1.Name = 'test';
        o1.CloseDate = System.Today().addDays(15);
        o1.RecordTypeId = RecTypeId1;
        o1.AccountId = c1.AccountId;
        o1.Stagename = 'Prospecting';
        o1.Temporary_Membean_Extension_Date__c = system.Today().addDays(45);
        o1.Subscription_End_Year__c = '2022';
        o1.Subscription_Start_Year__c = '2021';
        OpportunityService.runBeforeTriggerCount = 1;
        insert o1;  
      Test.stopTest();
  }
  
  static testMethod void TestMethodupdateontheFence()
  {
      Test.startTest();
      Opportunity o = [Select Id,Subscription_End_Year__c from Opportunity where StageName = 'Close Won' AND Account.RecordType.Name = 'Public School' ORDER BY CreatedDate DESC LIMIT 1];
      o.stageName = 'On the fence';
      o.On_the_fence_email_repetition_check__c  = False;
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      Id RecTypeId1 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
      Contact c1 = [select Id,Name,AccountId from Contact where Role__c = 'Teacher' AND AccountId != Null AND Account.RecordType.Name = 'Public School' AND Account.School_ID__c != Null LIMIT 1];
      Opportunity o1 = New Opportunity();
        o1.Name = 'test';
        o1.CloseDate = System.Today().addDays(15);
        o1.RecordTypeId = RecTypeId1;
        o1.AccountId = c1.AccountId;
        o1.Stagename = 'On the fence';
        o1.On_the_fence_email_repetition_check__c = False;
        o1.Subscription_End_Year__c = '2022';
        o1.Subscription_Start_Year__c = '2021';
        OpportunityService.runBeforeTriggerCount = 1;
        insert o1;
      Test.stopTest();
  }
  
  static testmethod void updatePilotDate()
  {
      test.startTest();
      Date today = system.Today();
      Opportunity o = [Select Id,Pilot_End_Date__c from Opportunity where StageName != 'Close Won' AND Account.RecordType.Name = 'Public School' AND Pilot_End_Date__c > :today ORDER BY CreatedDate DESC LIMIT 1];
      o.Pilot_End_Date__c = o.Pilot_End_Date__c.addDays(30);
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      Test.stopTest();
  }
  
  static testMethod void creatupdatesubscription()
  {
      test.startTest();
      Date today = system.Today();
      Date nextday = system.Today().addDays(365);
      Opportunity o = [Select Id,Pilot_End_Date__c,No_Of_Students__c,AccountId,Subscription_Start_Year__c,Subscription_End_Year__c from Opportunity where StageName != 'Close Won' AND Account.RecordType.Name = 'Public School' ORDER BY CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Status__c from Account where Id = :o.Accountid];
      a.Subscription_Status__c = 'Expired';
      update a;
      o.Subscription_Start_Year__c = String.valueOf(today.Year());
      o.Subscription_End_Year__c = String.valueOf(nextday.Year());
      o.Stagename = 'Close Won';
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      OpportunityService.runBeforeTriggerCount = 1;
      o.No_Of_Students__c = 1209;
      update o;  
      test.StopTest();
  }
  
  static testMethod void creatupdatesubscriptionmultiple()
  {
      test.startTest();
      Date today = system.Today();
      Date nextday = system.Today().addDays(365);
      Opportunity o = [Select Id,Pilot_End_Date__c,No_Of_Students__c,No_Of_Teachers__c,AccountId,Subscription_Start_Year__c,Subscription_End_Year__c from Opportunity where StageName != 'Close Won' AND Account.RecordType.Name = 'Public School' AND Pilot_End_Date__c = Null ORDER BY CreatedDate DESC LIMIT 1];
      Account a = [Select Id,Subscription_Status__c from Account where Id = :o.Accountid];
      a.Subscription_Status__c = 'Expired';
      update a;
      o.Stagename = 'Close Won';
      o.No_Of_Students__c = 1209;
      o.No_Of_Teachers__c = 76;
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      o.StageName = 'Propecting';
      //update o;
      List<Contract> contracts = [Select Id from Contract where AccountId = :a.Id];
      if (contracts.Size()>0)
          delete contracts;
      o.StageName = 'Close Won';
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      test.StopTest();
  }
  
  static testMethod void deleteopportunityscubscriptions()
  {
      test.startTest();
      Date today = System.Today();
      Opportunity o = [Select Id,No_Of_Students__c, Subscription__c, No_Of_Teachers__c,AccountId,Subscription_Start_Year__c,Subscription_End_Year__c from Opportunity where StageName = 'Close Won' AND Account.RecordType.Name = 'Public School' ORDER BY CreatedDate DESC LIMIT 1];
      List<Contract> conlst =  [Select Id from Contract where AccountId = :o.AccountId];
      if (conlst.Size() == 0)
      {
          Contract con = New Contract();
          con.AccountId = o.AccountId;
          con.Subscription_Start_Year__c = o.Subscription_Start_Year__c;
          con.Subscription_End_Year__c = o.Subscription_End_Year__c;
          con.No_Of_Students__c = o.No_Of_Students__c;
          con.No_Of_Teachers__c = o.No_Of_Teachers__c;
          insert con;
      }
      delete o;
      test.Stoptest();
  }
  
  static testMethod void deleteopportunityscubscriptions1()
  {
      test.startTest();
      Date today = System.Today();
      Opportunity o = [Select Id,No_Of_Students__c, Subscription__c, No_Of_Teachers__c,AccountId,Subscription_Start_Year__c,Subscription_End_Year__c from Opportunity where StageName = 'Close Won' AND Account.RecordType.Name = 'Public School' ORDER BY CreatedDate DESC LIMIT 1];
      List<Contract> conlst =  [Select Id from Contract where AccountId = :o.AccountId];
      Contract con = New Contract();
      if (conlst.Size() == 0)
      {
          con.AccountId = o.AccountId;
          con.Subscription_Start_Year__c = o.Subscription_Start_Year__c;
          con.Subscription_End_Year__c = o.Subscription_End_Year__c;
          con.No_Of_Students__c = o.No_Of_Students__c;
          con.No_Of_Teachers__c = o.No_Of_Teachers__c;
          insert con;
      }
      if (conlst.Size()> 0)
          o.Subscription__c = conlst[0].Id;
      else
          o.Subscription__c = con.Id;
      OpportunityService.runBeforeTriggerCount = 1;
      update o;
      delete o;
      test.Stoptest();
  }
  
  static testMethod void deleteparentopportunityscubscriptions()
  {
      test.startTest();
      Date today = System.Today();
      Opportunity o = [Select Id,Parent_Opportunity__c,No_Of_Students__c, Subscription__c, No_Of_Teachers__c,AccountId,Subscription_Start_Year__c,Subscription_End_Year__c from Opportunity where StageName = 'Close Won' AND Account.RecordType.Name = 'Public School' AND Parent_Opportunity__c != Null ORDER BY CreatedDate DESC LIMIT 1];
      Opportunity parentopp = [Select Id from Opportunity where Id = :o.Parent_Opportunity__c];
      delete parentopp;
  }
  static testMethod void validateStageChangeLogUpdate(){
        Test.startTest();
        Opportunity opp = [select Id,Key_Activity_Log__c,Teacher__c,StageName from Opportunity where Teacher__c != NULL AND Stagename = 'Close Lost' order by createdDate DESC limit 1];
        Contact c = [select Id,Name from Contact where Role__c = 'Teacher' order by createdDate desc LIMIT 1];
        OpportunityService.runBeforeTrigger = true;
        OpportunityService.runAfterTriggerCount = 0;
        OpportunityService.runAfterTrigger = true;
        opp.Teacher__c = c.Id;
        opp.StageName = 'Prospecting';
        OpportunityService.runBeforeTriggerCount = 1;
        update opp;
        Test.stopTest();
        
        
    }
    
    static testMethod void validateAcknowledgementUpdate(){

        Opportunity opp = [select Id,Key_Activity_Log__c,Quote_Acknowledgement__c,Estimate_Status__c from Opportunity where Stagename != 'Close Won' order by createdDate DESC limit 1];
        opp.Estimate_Status__c = 'Estimated';
        opp.Key_Activity_Log__c = 'abcd';
        opp.Quote_Acknowledgement__c = FALSE;
        Test.startTest();
        OpportunityService.runBeforeTriggerCount = 1;
        update opp;
        opp.Key_Activity_Log__c = 'abcd2';
        update opp;
        Test.stopTest();
        
    }
    
    static testMethod void validateCreateUsageFidelityOnPilot(){
        Date dt = System.Today().addDays(230);
        Opportunity opp = [select Id,Key_Activity_Log__c from Opportunity where Start_Pilot__c = FALSE order by createdDate DESC limit 1];
        opp.Pilot_End_Date__c = dt;
        opp.Start_Pilot__c = TRUE;
        OpportunityService.runBeforeTriggerCount = 1;
        Test.startTest();
        update opp;
        Test.stopTest();    
    }
    
    static testMethod void getParentOpp(){
        Opportunity opp = [select Id,Key_Activity_Log__c from Opportunity where StageName = 'Close Won' order by createdDate DESC limit 1];
        List<String> lid = New List<String>();
        lid.add(opp.Id);
        Test.startTest();
        List<Opportunity> lopp = New List<Opportunity>();
        lopp = OpportunityTriggerHandler.getParentOpps(lid);
        Test.stopTest();    
    }
    
    static testMethod void activityUpdateOnCreation(){
        List<Opportunity> opp = [select Id,Parent_Renewal_Opportunity__c,RecordTypeId from Opportunity where RecordType.Name = 'Renewal' AND StageName = 'Close Won' AND Parent_Renewal_Opportunity__c != Null order by createdDate DESC limit 1];
        Test.startTest();
        OpportunityTriggerHandler.activityUpdateOnCreation(opp);
        Test.stopTest();    
    }  
    
    static testMethod void createTeachersMembeanUsage() {
        Contact c = [select Id,Name,AccountId from Contact where Role__c = 'Teacher' AND AccountId != Null LIMIT 1];
        Id RecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Opportunity opp =  [Select Id from Opportunity where RecordTypeId = :RecTypeId AND StageName = 'Close Won' order by CreatedDate DESC LIMIT 1];
        Opportunity o = New Opportunity();
        o.Name = 'test';
        o.CloseDate = System.Today().addDays(15);
        o.RecordTypeId = RecTypeId;
        o.AccountId = c.AccountId;
        o.Stagename = 'Prospecting';
        o.Parent_Opportunity__c = opp.Id;
        OpportunityService.runBeforeTriggerCount = 1;
        insert o;    
    }
    
    static testMethod void createTeachersMembeanUsagetest() {
        Contact c = [select Id,Name,AccountId from Contact where Role__c = 'Teacher' AND AccountId != Null LIMIT 1];
        Id RecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        Opportunity o =  [Select Id,Start_Pilot__c,Pilot_Start_Date__c,Pilot_End_Date__c,Usage_fidelity_count__c from Opportunity where RecordTypeId = :RecTypeId AND StageName != 'Close Won' AND Usage_fidelity_count__c = 0 order by CreatedDate DESC LIMIT 1];
        o.Start_Pilot__c = TRUE;
        o.Pilot_Start_Date__c = System.today();
        o.Pilot_End_Date__c = System.Today().addDays(30);
        OpportunityService.runBeforeTriggerCount = 1;
        update o;    
    }
}