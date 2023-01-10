@IsTest(SeeAllData=true)
public class ProcessEmailTimesBatch_Test
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
        ProcessEmailTimesBatch batch1 = new ProcessEmailTimesBatch();
        database.executebatch(batch1, 20);
        Test.stopTest();
    }
    static testMethod void TestMethod2()
    {
        Test.startTest();
        Contact l = [Select Id from Contact where Email != null order  by createdDate DESC LIMIT 1];
        emailMessage inboundOne = new emailMessage(
        Subject = 'First inbound email subject',
        TextBody = 'First inbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = true
        );
        insert inboundOne;
        ProcessEmailTimesBatch batch1 = new ProcessEmailTimesBatch();
        database.executebatch(batch1, 20);
        Test.stopTest();
    }
}