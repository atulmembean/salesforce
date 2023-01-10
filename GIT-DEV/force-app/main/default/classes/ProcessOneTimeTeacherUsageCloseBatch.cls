global class ProcessOneTimeTeacherUsageCloseBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            dt = dt.addDays(-192);
            String close = 'Close Lost';
            //close = '\''+close+'\'';
            String recId = [Select Id from RecordType where sObjectType = 'Opportunity' AND Name = 'Renewal'].Id;
            if(Test.isRunningTest()){
               query = 'Select id from Opportunity where StageName = :close LIMIT 5';  
            }
            else{
               query = 'Select id from Opportunity where StageName = :close AND CloseDate >= :dt';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Opportunity> scope){

                for(Opportunity o:scope){
                    ProcessRecord(o.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            List<Teachers_membean_usage__c> tmuList = new List<Teachers_membean_usage__c>();        
            List<String> category = new List<String>{'Consistent & Recommended','Consistent & Below par','Inconsistent','Started well and dropped','Never started'};
            Opportunity o = [Select Id from Opportunity where Id = :rId];
            if (o != Null)
            {
                List<Teachers_membean_usage__c> memlst = [Select Id from Teachers_membean_usage__c where Opportunity__c = :o.Id];
                if (memlst.Size()==0)
                {
                    for(Integer i=0;i<5;i++)
                    {
                        Teachers_membean_usage__c tmu = new Teachers_membean_usage__c();
                        tmu.Opportunity__c = o.Id;
                        tmu.Category__c = category[i];
                        tmuList.add(tmu);
                    }
                    if (tmuList.size()>0)
                        insert tmuList;
                }               
            }
       }
}