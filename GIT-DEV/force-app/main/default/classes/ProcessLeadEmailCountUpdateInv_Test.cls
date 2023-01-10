@IsTest(SeeAllData=true)
public class ProcessLeadEmailCountUpdateInv_Test
{
  static testMethod void TestMethodone()
  {
      Test.startTest();
      Lead l = [Select Id,Update_Email_Count__c from Lead where Email != NULL order by createdDate DESC LIMIT 1];
      l.Update_Email_Count__c = TRUE;
      update l;
      User u = [Select Id,Email from User where FirstName = 'Ganesh' LIMIT 1];
      emailMessage inboundOne = new emailMessage(
        Subject = 'First inbound email subject',
        TextBody = 'First inbound email textbody',
        FromAddress = u.Email,
        ToAddress = l.Id,
        Status = '3',
        Incoming = true
        );
      insert inboundone;
      inboundOne = new emailMessage(
        Subject = 'Second inbound email subject',
        TextBody = 'Second inbound email textbody',
        FromAddress = u.Email,
        ToAddress = l.Id,
        Status = '3',
        Incoming = true
        );
      insert inboundone;
      emailMessage outboundOne = new emailMessage(
        Subject = 'First outbound email subject',
        TextBody = 'First outbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = false
        );
       insert outboundone;
      outboundOne = new emailMessage(
        Subject = 'MassMailer outbound email subject',
        TextBody = 'Second outbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = false
        );
       insert outboundone;
      ProcessLeadEmailCountUpdateInvocable.ProcessRequest request = new ProcessLeadEmailCountUpdateInvocable.ProcessRequest();
      request.leadId = l.Id;
      ProcessLeadEmailCountUpdateInvocable.ProcessRecord(request);
      Test.StopTest(); 
  }
}