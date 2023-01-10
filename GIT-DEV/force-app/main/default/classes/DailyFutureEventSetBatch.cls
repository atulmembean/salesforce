global class DailyFutureEventSetBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date d = System.Today();
            if(Test.isRunningTest()){
               query = 'Select Id from Event where EndDate >= :d AND WhoId != Null AND Cancelled__c = FALSE order by EndDate ASC LIMIT 20';  
            }
            else{
               query = 'Select Id from Event where EndDate >= :d AND WhoId != Null AND Cancelled__c = FALSE order by EndDate ASC';
            }
            system.debug('Query:::'+query);
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Event> scope){

                for(event ev :scope){
                    ProcessRecord(ev.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            if (Test.isRunningTest())
               Database.executeBatch(new DailyFutureEventTaskSetBatch(),20);
           else
               Database.executeBatch(new DailyFutureEventTaskSetBatch(),1); 
            
       }
    
       global void ProcessRecord(String rId){
            Date dt = system.Today();
            Event e= [Select Id, WhoId, EndDate, Subject from Event where Id = :rId];
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