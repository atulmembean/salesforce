public with sharing class AccountMassMailerExt
{
    public List<Lead> leadlist {get;set;}
    public List<Contact> contactlist {get;set;}
    public List<Lead> leadlistupd;
    public List<Contact> contactlistupd;
    public List<Lead> leads;
    public List<Contact> contacts;
    public String currentId;
    public Boolean proceed {get;set;}

    public AccountMassMailerExt (ApexPages.StandardController controller)
    {
        currentId = ApexPages.currentPage().getParameters().get('id');
        Account acc = [Select Id, Invite_Token__c from Account where Id = :currentId];
        if (acc!= Null && acc.Invite_Token__c == Null)
        { 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Account Invite Token is not set'));
            proceed = false;
        }
        else
        {
            populateleads();
            populatecontacts();
            proceed = true;
        } 
    }
    
    public void reset()
    {
        leadlistupd =  New List<Lead>();
        leads = [Select Id,SendBulkEmail__c from Lead where School_Account__c = :currentId AND isConverted = FALSE AND Role__c IN ('Teacher','Chair')];
        for (Lead l :leads)
        {
            l.SendBulkEmail__c = FALSE;
            leadlistupd.add(l);
        }
        if (leadlistupd.Size()>0)
            update leadlistupd;
        contactlistupd =  New List<Contact>();
        contacts = [Select Id,SendBulkEmail__c from Contact where AccountId = :currentId AND Role__c IN ('Teacher','Chair')];
        for (Contact c :contacts)
        {
            c.SendBulkEmail__c = FALSE;
            contactlistupd.add(c);
        }
        if (contactlistupd.Size()>0)
            update contactlistupd;
    }
    
    public void resetleads()
    {
        leadlistupd =  New List<Lead>();
        leads = [Select Id,SendBulkEmail__c from Lead where School_Account__c = :currentId AND isConverted = FALSE AND Role__c IN ('Teacher','Chair')];
        for (Lead l :leads)
        {
            l.SendBulkEmail__c = FALSE;
            leadlistupd.add(l);
        }
        if (leadlistupd.Size()>0)
            update leadlistupd;
    }
    
    public void resetcontacts()
    {
        contactlistupd =  New List<Contact>();
        contacts = [Select Id,SendBulkEmail__c from Contact where AccountId = :currentId AND Role__c IN ('Teacher','Chair')];
        for (Contact c :contacts)
        {
            c.SendBulkEmail__c = FALSE;
            contactlistupd.add(c);
        }
        if (contactlistupd.Size()>0)
            update contactlistupd;
    }
     
    public List<Lead> populateleads()
    {
        leadlist = [select id, FirstName,LastName,Email,Role__c from Lead where School_Account__c = :currentId AND isConverted = FALSE AND Role__c IN ('Teacher','Chair')];
        return leadlist;
    }
    
    public List<Contact> populatecontacts()
    {
        contactlist = [SELECT Id,FirstName,LastName,Email,Role__c FROM Contact WHERE AccountId = :currentId AND Role__c IN ('Teacher','Chair')];
        return contactlist;
    }
    
    public List<SelectOption> getleadSelect(){

    List<SelectOption> leadSelect = new List<SelectOption>();
    leadIds = new List<Id>();
    
    List<Lead> dlead = [SELECT Id,FirstName,School_Account__c from Lead where School_Account__c = :currentId AND isConverted = FALSE ORDER BY FirstName asc];
    
    for(Lead l:dlead)
        leadSelect.add(new SelectOption(l.Id, l.FirstName));  
    
    return leadSelect;
    
    }
    
    String[] leadIds = new String[]{};
    public String[] getleadIds () {
        return leadIds;
    }
    
    public void setleadIds(String[] leadIds) {
        this.leadIds = leadIds;
    }
    

    public List<SelectOption> getcontactSelect(){

    List<SelectOption> contactSelect = new List<SelectOption>();
    contactIds = new List<Id>();
    
    List<Contact> dcontact = [SELECT Id,FirstName,LastName,Email from Contact where AccountId = :currentId  ORDER BY FirstName asc];
    
    for(Contact c:dcontact)
        contactSelect.add(new SelectOption(c.Id, c.FirstName));  
    
    return contactSelect;
    
    }
    
    String[] contactIds = new String[]{};
    public String[] getcontactIds () {
        return contactIds;
    }
    
    public void setcontactIds(String[] contactIds) {
        this.contactIds = contactIds;
    }
    
   
    
}