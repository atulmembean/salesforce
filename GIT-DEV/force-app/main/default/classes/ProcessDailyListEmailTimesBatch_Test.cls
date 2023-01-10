@IsTest(SeeAllData=true)
public class ProcessDailyListEmailTimesBatch_Test
{
  static testMethod void TestMethodleadin()
  {
      Test.startTest();
      Lead l = [Select Id,Attention_Required__c from LEad where Status =  'Prospecting' and Email != null order  by createdDate DESC LIMIT 1];
      l.Attention_Required__c = TRUE;
      update l;
        emailMessage inboundOne = new emailMessage(
        Subject = 'First inbound email subject',
        TextBody = 'First inbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = true
        );
        insert inboundOne;
      ProcessDailyListEmailTimesBatch batch1 = new ProcessDailyListEmailTimesBatch();
      database.executebatch(batch1, 20);
      Test.stopTest();
  }
}