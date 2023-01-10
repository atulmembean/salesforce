global class ProcessLeadStatusUpdDailyBatch implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query;
        String stat = 'Nurturing';
        //stat = '\''+stat+'\'';
        Date dt = System.Today().addDays(-1);
        List<Lead_Status_Update_Query__mdt> lsuq = [Select Id,SOQL__c from Lead_Status_Update_Query__mdt];
        if(Test.isRunningTest()){
           query = 'Select id from Lead where Status = :stat AND Consider__c = TRUE LIMIT 1';  
        }
        /*else{
            if (lsuq.Size()==0)
               query = 'Select id from Lead where Status = :stat AND Consider__c = TRUE LIMIT 49000';
            else
               query = lsuq[0].SOQL__c;
        }*/
        else
            query = 'Select id from Lead where Status = :stat AND Consider__c = TRUE LIMIT 49000';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Lead> scope){

            for(Lead l:scope){
                ProcessRecord(l.Id);
            }
                
    }

    global void finish(Database.BatchableContext BC){
        
    }

    global void ProcessRecord(String rId){
        List<Lead> leadlst = [Select Id, Status from Lead where Id = :rId];
        
        if (leadlst.Size()>0)
        {
                
            leadlst[0].Status = 'Prospecting';
            update leadlst[0];
            
        }
    }
}