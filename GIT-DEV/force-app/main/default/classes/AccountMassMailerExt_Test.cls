@isTest(seeAllData = TRUE)
public class AccountMassMailerExt_Test {

    static testMethod void testMethodLead()
    {
         Lead l = [Select Id,School_Account__c from Lead where School_Account__c != Null AND isConverted = FALSE Order by CreatedDate DESC LIMIT 1];
         List<Account> acclst = [Select Id from Account where Id = :l.School_Account__c];
         Test.setCurrentPage(Page.BulkMassMail);
         ApexPages.currentPage().getParameters().put('id', acclst[0].Id);
         AccountMassMailerExt ac = new AccountMassMailerExt(new ApexPages.StandardController(acclst[0]));
         ac.reset();
         ac.resetleads();
         ac.resetcontacts();
         ac.populateleads();
         ac.populateContacts();
         ac.getleadSelect();
         ac.getleadIds();
    }
    
    static testMethod void testMethodContact()
    {
         Contact c = [Select Id,AccountId from Contact where AccountId != Null Order by CreatedDate DESC LIMIT 1];
         List<Account> acclst = [Select Id from Account where Id = :c.AccountId];
         Test.setCurrentPage(Page.BulkMassMail);
         ApexPages.currentPage().getParameters().put('id', acclst[0].Id);
         AccountMassMailerExt ac = new AccountMassMailerExt(new ApexPages.StandardController(acclst[0]));
         ac.reset();
         ac.resetleads();
         ac.resetcontacts();
         ac.populateleads();
         ac.populateContacts();
         ac.getcontactSelect();
         ac.getcontactIds();
    }
}