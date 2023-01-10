@IsTest(SeeAllData=true)
public class leadTrigger_Test
{
  static testMethod void TestMethodOne()
  {
      Test.startTest();
      Lead l = [Select Id from Lead where FirstName != Null and LastName != Null order by CreatedDate DESC LIMIT 1];
      l.FirstName = 'Mr. Test';
      update l;
      Test.stopTest();
  }
  static testMethod void TestMethodTwo()
  {
      Test.startTest();
      Lead l = [Select Id from Lead where FirstName != Null and LastName != Null order by CreatedDate DESC LIMIT 1];
      l.FirstName = 'Test12';
      update l;
      Test.stopTest();
  }
  static testMethod void TestMethodThree()
  {
      Test.startTest();
      Contact c = [Select Id, Email from Contact where Email != Null order by createdDate Desc LIMIT 1];
      Lead l = New Lead();
      l.FirstName = 'Test12';
      l.LastName = 'Test';
      l.Email = c.Email;
      l.Role__c = 'Teacher';
      l.LeadSource = 'Webinar';
      l.Company = 'New One';
      l.School_Description__c = 'Test';
      l.Highest_Grade__c = '8';
      l.Lowest_Grade__c = '3';
      l.Additional_Comments__c  = 'Additional';
      insert l;
      Test.stopTest();
  }
}