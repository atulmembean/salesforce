global class ProcessMembeanUserBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            
            if(Test.isRunningTest()){
               query = 'Select id from Membean_User__c order by CreatedDate DESC LIMIT 1';  
            }
            else{
               query = 'Select id from Membean_User__c where CreatedDate = TODAY';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Membean_User__c> scope){

                for(Membean_User__c mu:scope){
                    ProcessRecord(mu.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            Date dt = system.Today();
            List<Membean_User__c> muList = new List<Membean_User__c>();
            List<Lead> leadlstupd = New List<Lead>(); 
            List<Contact> contactlstupd = New List<Contact>();          
            Membean_User__c mu = [Select Id,Created_Date_in_Membean_com__c,Email__c,First_Name__c,Last_Name__c,Level__c,School_Code__c,Type__c,User_Comments__c from Membean_User__c where Id = :rId];
            
            if (mu != Null)
            {
                List<Lead> leadlst = [Select Id,Membean_User__c,Calibration_Level__c,Membean_Created_Date__c,Membean_User_Type__c from Lead where Email = :mu.Email__c AND isConverted = FALSE];
                for (Lead l :leadlst)
                {
                    l.Calibration_Level__c = mu.Level__c;
                    l.Membean_Created_Date__c = mu.Created_Date_in_Membean_com__c;
                    l.Membean_User_Type__c  = mu.Type__c;
                    l.Membean_User__c = TRUE;
                    leadlstupd.add(l);
                }
                if (leadlstupd.size()>0)
                {
                    update leadlstupd;
                    mu.Lead__c = leadlst[0].Id;
                    update mu;    
                }
                else
                {
                    List<Contact> contactlst = [Select Id,Membean_User__c ,Calibration_Level__c,Membean_Created_Date__c,Membean_User_Type__c from Contact where Email = :mu.Email__c];
                    for (Contact c :contactlst)
                    {
                        c.Calibration_Level__c = mu.Level__c;
                        c.Membean_Created_Date__c = mu.Created_Date_in_Membean_com__c;
                        c.Membean_User_Type__c  = mu.Type__c;
                        c.Membean_User__c = TRUE;
                        contactlstupd.add(c);
                    }
                    if (contactlstupd.size()>0)
                    {
                        update contactlstupd;
                        mu.Contact__c = contactlst[0].Id;
                        update mu;
                    }
                    else
                    {
                       /* Account acc = [Select Id,School_ID__c from Account where School_ID__c = :mu.School_Code__c limit 1];
                        if (acc != null)
                        {
                            If (mu.School_Code__c != Null)
                            {
                                Contact cins = New Contact();
                                cins.FirstName = mu.First_Name__c;
                                cins.LastName = mu.Last_Name__c;
                                cins.Email = mu.Email__c;
                                cins.Calibration_Level__c = mu.Level__c;
                                cins.Membean_Created_Date__c = mu.Created_Date_in_Membean_com__c;
                                cins.Membean_User_Type__c  = mu.Type__c;
                                cins.AccountId = acc.Id;
                                cins.Membean_User__c = TRUE;
                                if (mu.Type__c == 'Teacher')
                                    cins.Role__c = 'Teacher';
                                else
                                    cins.Role__c = 'Other';
                                insert cins;
                                mu.Contact__c = cins.Id;
                            }
                            else
                            {
                                system.debug('mu.Email__c::: ' + mu.Email__c);
                                String domain = mu.Email__c.split('@').get(1);
                                system.debug('domain b4::: ' + domain);
                                domain = domain.split('.com').get(0);
                                system.debug('domain after::: ' + domain);
                                Lead lins = New Lead();
                                lins.FirstName = mu.First_Name__c;
                                lins.LastName = mu.Last_Name__c;
                                lins.Email = mu.Email__c;
                                lins.Calibration_Level__c = mu.Level__c;
                                lins.Membean_Created_Date__c = mu.Created_Date_in_Membean_com__c;
                                lins.Membean_User_Type__c  = mu.Type__c;
                                lins.Company = domain;
                                lins.Membean_User__c = TRUE;
                                insert lins;
                                mu.Lead__c = lins.Id;
                            }
                        }*/
                    }
                }  
            }
       }
}