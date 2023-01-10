global class ProcessMassMailerLeadUpdateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            String event = 'processed';
            event = '\''+event+'\'';
            String event1 = 'dropped';
            event1 = '\''+event1+'\'';
            List<String> stage = New List<String>{'Renewal'};
            if(Test.isRunningTest()){
               query = 'Select id,Cloudrop__Lead__c from Cloudrop__BulkEmail_Status__c where Cloudrop__Lead__c != Null AND (Cloudrop__Event__c = \'processed\' OR Cloudrop__Event__c = \'dropped\') AND CreatedDate = TODAY AND Processed__c = FALSE LIMIT 1';  
            }
            else{
               query = 'Select id,Cloudrop__Lead__c from Cloudrop__BulkEmail_Status__c where Cloudrop__Lead__c != Null AND (Cloudrop__Event__c = \'processed\' OR Cloudrop__Event__c = \'dropped\') AND CreatedDate = TODAY AND Processed__c = FALSE LIMIT 49000';
            }
            system.debug(query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Cloudrop__BulkEmail_Status__c> scope){
                List<Cloudrop__BulkEmail_Status__c> mmlst = New List<Cloudrop__BulkEmail_Status__c>();
                integer i = 0;
                for(Cloudrop__BulkEmail_Status__c l:scope){
                    if (i==15)
                    {
                        ProcessRecord(mmlst);
                        i=0;
                        mmlst = New List<Cloudrop__BulkEmail_Status__c>();
                    }
                    else
                    {
                        mmlst.add(l);
                        ++i;
                    }
                }
                if (mmlst.size()>0)
                    ProcessRecord(mmlst);    
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(List<Cloudrop__BulkEmail_Status__c> mlst){
           Cloudrop__BulkEmail_Status__c st = New Cloudrop__BulkEmail_Status__c();
           List<Cloudrop__BulkEmail_Status__c> stlstupd =  New List<Cloudrop__BulkEmail_Status__c>();
           List<Lead> leadlstupd =  New List<Lead>();
           for (Cloudrop__BulkEmail_Status__c cl :mlst)
           {
            st = [Select Id,Cloudrop__Cloudrop_Event_Time__c,Cloudrop__Lead__c,Processed__c from Cloudrop__BulkEmail_Status__c where Id = :cl.Id];
            DateTime dtime = st.Cloudrop__Cloudrop_Event_Time__c;
            dtime = dtime.addMinutes(2);
            system.debug(dtime);
            Lead ld = [Select Id,Lead_Contacted_DateTime__c,Process_Massmailer__c,Status from Lead where Id = :st.Cloudrop__Lead__c];
            if (ld != Null)
            {
                ld.Lead_Contacted_DateTime__c = dtime;
                leadlstupd.add(ld);               
            }
            st.Processed__c =  TRUE;
            stlstupd.add(st);
           }
           if (leadlstupd.size()>0)
               update leadlstupd;
           if (stlstupd.size()>0)
               update stlstupd;
            system.debug(leadlstupd);
           
       }
}