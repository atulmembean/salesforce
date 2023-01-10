@IsTest(SeeAllData=true)
public class ProcessMembeanUserBatch_Test
{
  static testMethod void TestLead()
  {
      Lead l = New Lead();
      l.FirstName = 'FFName';
      l.LastName = 'llname';
      l.Email = 'fnamelname@flname.com';
      l.Company = 'Company1';
      insert l;
      Membean_User__c mu = New Membean_User__c();
      mu.Created_Date_in_Membean_com__c=System.Now();
      mu.Email__c='fnamelname@flname.com';
      mu.Level__c='1';
      mu.Type__c='Teacher';
      mu.User_Comments__c='New Comments';
      insert mu; 
      Test.startTest();
      ProcessMembeanUserBatch batch1 = new ProcessMembeanUserBatch ();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
  static testMethod void TestNoLead()
  {
      Membean_User__c mu = New Membean_User__c();
      mu.Created_Date_in_Membean_com__c=System.Now();
      mu.Email__c='fnamelname007@flname.com';
      mu.First_Name__c = 'Fname007';
      mu.Last_Name__c = 'lname007';
      mu.Level__c='1';
      mu.Type__c='Teacher';
      mu.User_Comments__c='New Comments';
      insert mu; 
      Test.startTest();
      ProcessMembeanUserBatch batch1 = new ProcessMembeanUserBatch ();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
  static testMethod void TestContact()
  {
      Account acc = [Select Id,School_ID__c from Account where RecordType.Name = 'Public School' AND School_ID__c != Null Order by CreatedDate DESC LIMIT 1];
      Contact c = New Contact();
      c.FirstName = 'CFName';
      c.LastName = 'Clname';
      c.Email = 'cfnamelname@flname.com';
      c.Role__c = 'Other';
      c.AccountId = acc.Id;
      insert c;
      Membean_User__c mu = New Membean_User__c();
      mu.Created_Date_in_Membean_com__c=System.Now();
      mu.Email__c='cfnamelname@flname.com';
      mu.Level__c='1';
      mu.Type__c='Teacher';
      mu.School_Code__c = acc.School_ID__c;
      mu.User_Comments__c='New Comments';
      insert mu; 
      Test.startTest();
      ProcessMembeanUserBatch batch1 = new ProcessMembeanUserBatch ();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
  static testMethod void TestNoContact()
  {
      Account acc = [Select Id,School_ID__c from Account where RecordType.Name = 'Public School' AND School_ID__c != Null Order by CreatedDate DESC LIMIT 1];
      
      Membean_User__c mu = New Membean_User__c();
      mu.Created_Date_in_Membean_com__c=System.NOW();
      mu.First_Name__c = 'NewFname';
      mu.Last_Name__c =  'Newlname';
      mu.Email__c='cfnamelname1@flname.com';
      mu.Level__c='1';
      mu.Type__c='Teacher';
      mu.School_Code__c = acc.School_ID__c;
      mu.User_Comments__c='New Comments';
      insert mu; 
      Test.startTest();
      ProcessMembeanUserBatch batch1 = new ProcessMembeanUserBatch ();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
}