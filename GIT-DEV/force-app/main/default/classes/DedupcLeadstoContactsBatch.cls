global class DedupcLeadstoContactsBatch implements Database.Batchable<sObject>{
    public string query;
    global Database.querylocator start(Database.BatchableContext BC){
        //Date dt = System.Today().AddDays(-30);
        Date dt = Date.newInstance(2020,11,04);
        Date dt1 = Date.newInstance(2020,11,06);
        if (Test.isRunningTest())
            query = 'Select Id, Email from Lead where Email != Null AND isConverted =  TRUE ORDER BY CreatedDate ASC LIMIT 10';
        else
            query = 'Select Id, Email from Lead where Email != Null AND isConverted =  TRUE ORDER BY CreatedDate ASC LIMIT 49500';
        system.debug('Query::: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Lead> scope){
        for (Lead l : Scope){
            ProcessRecord(l.Id);
        }       
    }

    global void finish(Database.BatchableContext BC){
    messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
     AsyncApexJob a = [SELECT Id,
                             Status,
                             NumberOfErrors,
                             JobItemsProcessed,
                             TotalJobItems,
                             CompletedDate,
                             ExtendedStatus,
                             ApexClass.name,
                             CreatedBy.Email,
                             CreatedBy.Name
                      FROM AsyncApexJob 
                      WHERE Id =:BC.getJobId()];
    if (a.TotalJobItems > 0)
    {
    List<String> FinalToAddresses = new list<String>();
    FinalToAddresses.add('reachsfdcconsultant@gmail.com');
    mail.setToAddresses(FinalToAddresses);
    mail.setSubject('Processing Leads to Contacts Duplicate Batch Job Complete -- '+a.ApexClass.name);
    mail.setUseSignature(false);

    string td1='"border:1px solid green; width=200px;"';
    string td2='"width=200px; border:1px solid green; background-color:red; color:white; font-weight:bold;"';
    string tdHead='"border:1px solid green; width=200px; color:white; background-color:green; font-weight:bold;"';
    string ExtendedStatus='';
    if(a.ExtendedStatus!=null)
        ExtendedStatus=a.ExtendedStatus;
    string tdErrors=td1;
    if(a.NumberOfErrors>0)
        tdErrors=td2;
    string htmlBody = '<div style="border:2px solid green; border-radius:15px;"><p>Hi,</p><p><span style="color:brown; font-weight:bolder;">Salesforce</span> completed running <b>Asset Duplicate Processing Batch Job</b>.</p>'
    +'<p>Results:</p>'
    +'<center><table style="border:3px solid green; border-collapse:collapse;">'
    +'<tr><td style='+tdHead+'>Class Name</td><td style='+tdHead+'>'+a.ApexClass.name+'</td></tr>'
    +'<tr><td style='+td1+'>Completed Date</td><td style='+td1+'>'+a.CompletedDate+'</td></tr>'
    +'<tr><td style='+td1+'>Status</td><td style='+td1+'>'+a.Status+'</td></tr>'
    +'<tr><td style='+td1+'>Job Items Processed</td><td style='+td1+'>'+a.JobItemsProcessed+' / '+a.TotalJobItems+'</td></tr>'
    +'<tr><td style='+td1+'>NumberOfErrors</td><td style='+tdErrors+'>'+a.NumberOfErrors+'</td></tr>'
    +'<tr><td style='+td1+'>Extended Status</td><td style='+td1+'>'+ExtendedStatus+'</td></tr>'
    +'<tr><td style='+tdHead+'>Created By</td><td style='+tdHead+'>'+a.CreatedBy.Name+'</td></tr>'
    +'</table></center>'
    +'<p><b>Have a Nice Day !!!</b></p><p><span style="font-family:"Courier New", Courier, monospace; color:green; font-weight:bold; font-size:larger;">Team Salesforce</span></p></div>';

    mail.setHtmlBody(htmlBody);
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    mails.add(mail);
    Messaging.sendEmail(mails);
    }
    }
    
    global void ProcessRecord(Id ProcessRecordId)
    {
        Set<Id> dupIds = New Set<Id>();
        List<Lead> a = [SELECT Id,Email,CreatedDate,CreatedBy.Name,LeadContactDeduped__c,School_Account__c,School_Account__r.Name FROM Lead WHERE Id = :ProcessRecordId];
        List<Contact> contactList = [Select Id, Email From Contact Where Email = :a[0].Email];
        List<Duplicate__c> dupinslst =  New List<Duplicate__c>();
                
        if (a.Size()>0)
        {
            List<Duplicate__c> dupLst = [Select Id,Object_Record_Id__c from Duplicate__c where Object_Record_Id__c = :a[0].Id AND Process__c = 'Leads to Contacts Converted'];
            if (dupLst.Size() == 0)
            {    
                if (contactList.Size()>=2)
                {
                    for (Contact a1 :contactList)
                    {
                            dupIds.add(a1.Id);
                    }
                    Duplicate__c dupins = New Duplicate__c();
                    dupins.Object_Name__c = 'Lead';
                    //dupins.Lead__c = a[0].Id;
                    dupins.Created_By__c = a[0].CreatedBy.Name;
                    dupins.Email__c = a[0].Email;
                    dupins.Object_Record_Id__c = a[0].Id;
                    dupins.Record_Created_On__c = a[0].CreatedDate;
                    dupins.Process__c = 'Leads to Contacts Converted';
                    dupins.Account_Id__c = a[0].School_Account__c;
                    dupins.Account_Name__c = a[0].School_Account__r.Name;
                    dupinslst.add(dupins);
                }
                List<Contact> contactDupList =  [Select Id, Email,AccountId, CreatedDate,CreatedBy.Name,Account.Name from Contact where Id IN :DupIds];
                for (Contact con :contactDupList)
                {
                    Duplicate__c dupins = New Duplicate__c();
                    dupins.Object_Name__c = 'Contact';
                    dupins.Contact__c = con.Id;
                    dupins.Created_By__c = con.CreatedBy.Name;
                    dupins.Email__c = con.Email;
                    dupins.Object_Record_Id__c = con.Id;
                    dupins.Record_Created_On__c = con.CreatedDate;
                    dupins.Process__c = 'Leads to Contacts Converted';
                    dupins.Account_Id__c = con.AccountId;
                    dupins.Account_Name__c = con.Account.Name;
                    dupinslst.add(dupins);
                }
                if (dupinslst.size()>0)
                    insert dupinslst;
            }
        }
    }        
}