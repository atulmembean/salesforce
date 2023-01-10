global class DailyFutureEventTaskSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date d = System.Today();
            if(Test.isRunningTest()){
               query = 'Select Id from Task where ActivityDate >= :d AND WhoId != Null AND Status = \'Open\' order by ActivityDate ASC LIMIT 20';  
            }
            else{
               query = 'Select Id from Task where ActivityDate >= :d AND WhoId != Null AND Status = \'Open\' order by ActivityDate ASC';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Task> scope){

                for(Task t :scope){
                    ProcessRecord(t.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            Date dt = system.Today();
            Task e= [Select Id, WhoId, ActivityDate, Subject from Task where Id = :rId];
            String chr = e.WhoId;
            chr = chr.left(3);
            String sub = e.Subject;
            if (e != Null && chr == '003' && sub.indexOf('Canceled:') == -1)
            {
                Contact c = [Select Id, Has_Future_Event__c from Contact where Id = :e.WhoId];
                if (c != Null)
                {
                    if (c.Has_Future_Event__c == FALSE)
                    {
                        c.Has_Future_Event__c = TRUE;
                        try{
                            update c;
                        } catch (Exception e1)
                        {
                        
                        }
                    }
                }
            }
            else if (e != Null && chr == '00Q' && sub.indexOf('Canceled:') == -1)
            {
                Lead l = [Select Id,Has_Future_Event__c from Lead where Id = :e.WhoId];
                if (l != Null)
                {
                    if (l.Has_Future_Event__c == FALSE)
                    {
                        l.Has_Future_Event__c = TRUE;
                        try{
                            update l;
                        } catch (Exception e1)
                        {
                        
                        }
                    }
                }
            }
       }
}