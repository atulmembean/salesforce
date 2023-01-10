@IsTest(SeeAllData=true)
public class ProcessMassMailerVeriBatchOnetime_Test
{
  static testMethod void TestMethodLead()
  {
      Test.startTest();
      Cloudrop__MassMailer_Email_Verify_Status__c evs = [Select Id,Cloudrop__Lead__c,Cloudrop__Status__c from Cloudrop__MassMailer_Email_Verify_Status__c where Cloudrop__Lead__c != Null and Cloudrop__Status__c  != 'valid' order by createddate desc limit 1];
      evs.Cloudrop__Status__c = 'valid';
      update evs;
      ProcessMassMailerVeriBatchOnetime batch1 = new ProcessMassMailerVeriBatchOnetime();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
  static testMethod void TestMethodContact()
  {
      Test.startTest();
      Cloudrop__MassMailer_Email_Verify_Status__c evs = [Select Id,Cloudrop__Contact__c,Cloudrop__Status__c from Cloudrop__MassMailer_Email_Verify_Status__c where Cloudrop__Contact__c != Null and Cloudrop__Status__c  != 'valid' order by createddate desc limit 1];
      evs.Cloudrop__Status__c = 'valid';
      update evs;
      ProcessMassMailerVeriBatchOnetime batch1 = new ProcessMassMailerVeriBatchOnetime();
      database.executebatch(batch1, 1);
      Test.stopTest();
  }
}