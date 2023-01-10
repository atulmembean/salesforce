@IsTest(SeeAllData=true)
public class ProcessEmailTimesLeadCorrBatch_Test
{
    static testMethod void TestMethod1()
    {
        Test.startTest();
        Lead l = [Select Id from Lead where Email != null order  by createdDate DESC LIMIT 1];
        emailMessage inboundOne = new emailMessage(
        Subject = 'First inbound email subject',
        TextBody = 'First inbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = true
        );
        insert inboundOne;
        ProcessEmailTimesLeadCorrBatch batch1 = new ProcessEmailTimesLeadCorrBatch();
        database.executebatch(batch1, 20);
        Test.stopTest();
    }
}