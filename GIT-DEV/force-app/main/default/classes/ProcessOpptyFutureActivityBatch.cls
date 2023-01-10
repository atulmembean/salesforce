global class ProcessOpptyFutureActivityBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            if(Test.isRunningTest()){
               query = 'select Id from Opportunity where (Probability > 0 AND Probability < 100) OR (Probability = 100 AND CreatedDate >= LAST_N_DAYS:365) LIMIT 5';  
            }
            else{
               query = 'select Id from Opportunity where (Probability > 0 AND Probability < 100) OR (Probability = 100 AND CreatedDate >= LAST_N_DAYS:365)';
            }
            
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
            List<Opportunity> olst = [Select Id, Has_Future_Activity__c from Opportunity where Id = :rId];
            List<Opportunity> olstupd = New List<Opportunity>();
            List<OpenActivity> actlst = New LIst<OpenActivity>();
            Date dt= System.Today();
            for (Opportunity o :olst)
            {
                List<Task> tskresults = [select Id from Task where whatid = :o.Id and ActivityDate > :dt AND IsClosed = FALSE];
                List<Event> eventresults = [select Id from Event where whatid = :o.Id and ActivityDate > :dt];
    
                if ((tskresults.Size() == 0) && (eventresults.Size() == 0))
                {
                    if (o.Has_Future_Activity__c == TRUE)
                    {
                        o.Has_Future_Activity__c = FALSE;
                        olstupd.add(o);
                    }
                }
                else
                {
                    if (o.Has_Future_Activity__c == FALSE)
                    {
                        o.Has_Future_Activity__c = TRUE;
                        olstupd.add(o);
                    }
                }
            }
            if (olstupd.Size() > 0)
                update olstupd;  
       }
}