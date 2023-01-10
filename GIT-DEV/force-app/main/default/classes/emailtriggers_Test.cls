@isTest(SeeAllData=TRUE)
private class emailtriggers_Test {
   
    static testMethod void testmethodInboundEmailLeadUpdate() {
        
        Test.StartTest();
        Lead l = [Select Id from LEad where Status =  'Prospecting' and Email != null order  by createdDate DESC LIMIT 1];
        emailMessage inboundOne = new emailMessage(
        Subject = 'First inbound email subject',
        TextBody = 'First inbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = true
        );
        insert inboundOne;
        Test.StopTest();
    }
    
    static testMethod void testmethodOutboundEmailLeadUpdate() {
        Test.StartTest();
        Lead l = [Select Id from LEad where Status =  'Prospecting' and Email != null order  by createdDate DESC LIMIT 1];
        emailMessage outboundOne = new emailMessage(
        Subject = 'First outbound email subject',
        TextBody = 'First outbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = false
        );
        insert outboundOne;
        Test.StopTest();
    }
}