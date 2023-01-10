global class UpdateAccountStatus implements Database.Batchable<sObject>, Database.AllowsCallouts {
      
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            if(Test.isRunningTest()){
               query = 'select Id from Account where Subscription_Status__c = \'Customer\' LIMIT 1';
            }
            else{
               query = 'select Id from Account where Subscription_Status__c = \'Customer\' LIMIT 45000';
            }
            
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Account>scope){
            for(Account acc:scope){
                ProcessRecord(acc.Id);
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
            String[] ToAddresses = new String[] {};
    
            String[] ToEmails = new String[]{};
            ToEmails.add('ganesh@membean.com');       
            List<String> FinalToAddresses = new list<String>();
            FinalToAddresses.addAll(ToEmails);
            mail.setToAddresses(FinalToAddresses);
         
            mail.setSubject('Processing of Monthly Acccount status update Batch Job Complete -- '+a.ApexClass.name);
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
            string htmlBody = '<div style="border:2px solid green; border-radius:15px;"><p>Hi,</p><p><span style="color:brown; font-weight:bolder;">Salesforce</span> completed processing <b>Account status update via a Batch Job</b>.</p>'
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
       
       global void ProcessRecord(Id rId){
           Account acnt = [Select Id,Subscription_Status__c,Subscription_Years__c,Subscription_Expiry_Month_Calc__c from Account where Id =:rId LIMIT 1];
           Date dt = System.Today();
           Date acntsubenddt;
           if (acnt != Null && acnt.Subscription_Expiry_Month_Calc__c != Null && acnt.Subscription_Years__c != Null)
           {
               System.debug(acnt.Subscription_Years__c);
               List<String> lst = acnt.Subscription_Years__c.Split(';');
               lst.Sort();
               String lastyear = '';
               for (String s :lst)
                   lastyear = s;    
               //Integer yr = integer.valueOf(acnt.Subscription_Years__c.right(4));
               Integer yr = integer.valueOf(lastyear)+1;
               Integer mnth = integer.valueOf(acnt.Subscription_Expiry_Month_Calc__c);
               Integer d = 1;
               acntsubenddt =  date.newInstance(yr,mnth,d);
               Integer numberOfDays = Date.daysInMonth(acntsubenddt.year(), acntsubenddt.month());
               acntsubenddt = date.newinstance(yr,mnth,numberOfDays);
               if (dt > acntsubenddt)
               {
                   acnt.Subscription_Status__c = 'Expired';
                   update acnt;
               }
           }
       }
}