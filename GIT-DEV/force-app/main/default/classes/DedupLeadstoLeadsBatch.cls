global class DedupLeadstoLeadsBatch implements Database.Batchable<sObject>{
    public string query;
    global Database.querylocator start(Database.BatchableContext BC){
        //Date dt = System.Today().AddDays(-30);
        Date dt = Date.newInstance(2020,11,04);
        Date dt1 = Date.newInstance(2020,11,06);
        if (Test.isRunningTest())
            query = 'Select Id, Email from Lead where Email != Null AND isConverted = FALSE ORDER BY CreatedDate ASC LIMIT 10';
        else
            query = 'Select Id, Email from Lead where Email != Null AND isConverted = FALSE ANd LeadLeadDeduped__c = FALSE ORDER BY CreatedDate ASC LIMIT 49500';
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
    mail.setSubject('Processing Leads to Leads Duplicate Batch Job Complete -- '+a.ApexClass.name);
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
    string htmlBody = '<div style="border:2px solid green; border-radius:15px;"><p>Hi,</p><p><span style="color:brown; font-weight:bolder;">Salesforce</span> completed running <b>Leads2Leads Duplicate Processing Batch Job</b>.</p>'
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
        List<Lead> a = [SELECT Id,Email,CreatedDate,CreatedBy.Name,LeadLeadDeduped__c,School_Account__c,School_Account__r.Name FROM Lead WHERE Id = :ProcessRecordId];
        List<Lead> leadList = [Select Id, Email From Lead Where Email = :a[0].Email AND Id != :a[0].Id];
        List<Duplicate__c> dupinslst =  New List<Duplicate__c>();
                
        if (a.Size()>0)
        {
            List<Duplicate__c> dupLst = [Select Id,Object_Record_Id__c from Duplicate__c where Object_Record_Id__c = :a[0].Id AND Process__c = 'Within Leads'];
            if (dupLst.Size() == 0)
            {    
                 if (leadList.Size()>=1)
                {
                    for (Lead a1 :leadList)
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
                    dupins.Process__c = 'Within Leads';
                    dupins.Account_Id__c = a[0].School_Account__c;
                    dupins.Account_Name__c = a[0].School_Account__r.Name;
                    dupinslst.add(dupins);
                }
                List<Lead> leadDupList =  [Select Id, Email, CreatedDate,CreatedBy.Name,School_Account__c,School_Account__r.Name from Lead where Id IN :DupIds];
                for (Lead lea :leadDupList)
                {
                    Duplicate__c dupins = New Duplicate__c();
                    dupins.Object_Name__c = 'Lead';
                    dupins.Lead__c = lea.Id;
                    dupins.Created_By__c = lea.CreatedBy.Name;
                    dupins.Email__c = lea.Email;
                    dupins.Object_Record_Id__c = lea.Id;
                    dupins.Record_Created_On__c = lea.CreatedDate;
                    dupins.Process__c = 'Within Leads';
                    dupins.Account_Id__c = lea.School_Account__c;
                    dupins.Account_Name__c = lea.School_Account__r.Name;
                    dupinslst.add(dupins);
                }
                if (dupinslst.size()>0)
                    insert dupinslst;
            }
            a[0].LeadLeadDeduped__c = TRUE;
            update a[0];
        }
    }        
}