@IsTest(SeeAllData=true)
public class ProcessContactEmailChangeInvocable_Test
{
  static testMethod void TestMethodone()
  {
      Test.startTest();
      Contact c = [Select Id,Left_School__c from Contact where Left_School__c = FALSE AND Email != NULL order by createdDate DESC LIMIT 1];
      c.Left_School__c = TRUE;
      update c;
      ProcessContactEmailChangeInvocable.ProcessRequest request = new ProcessContactEmailChangeInvocable.ProcessRequest();
      request.contactId = c.Id;
      ProcessContactEmailChangeInvocable.ProcessRecord(request);
      Test.StopTest(); 
  }
}