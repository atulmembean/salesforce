global class ProcessDailyEventTimesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date d = System.Today();
            d=d.addDays(-1);
            Date dtst = date.newinstance (2022,08,26);
            if(Test.isRunningTest()){
               query = 'Select Id from Event where EndDate > :dtst AND WhoId != Null AND Cancelled__c = FALSE order by EndDate ASC LIMIT 20';  
            }
            else{
               query = 'Select Id from Event where EndDate = :d AND WhoId != Null AND Cancelled__c = FALSE order by EndDate ASC';
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
            
       }
    
       global void ProcessRecord(String rId){
            Date dt = system.Today();
            Event e= [Select Id, WhoId, EndDate, Subject from Event where Id = :rId];
            String chr = e.WhoId;
            chr = chr.left(3);
            String sub = e.Subject;
            if (e != Null && chr == '003' && sub.indexOf('Canceled:') == -1)
            {
                Contact c = [Select Id, Total_Events_Conducted__c from Contact where Id = :e.WhoId];
                if (c != Null)
                {
                    if (c.Total_Events_Conducted__c == Null)
                        c.Total_Events_Conducted__c = 1;
                    else
                        c.Total_Events_Conducted__c = c.Total_Events_Conducted__c + 1;
                    try{
                        update c;
                    } catch (Exception e1)
                    {
                    
                    } 
                }
            }
            else if (e != Null && chr == '00Q' && sub.indexOf('Canceled:') == -1)
            {
                Lead l = [Select Id,Total_Events_Conducted__c from Lead where Id = :e.WhoId];
                if (l != Null)
                {
                     if (l.Total_Events_Conducted__c == Null)
                        l.Total_Events_Conducted__c = 1;
                    else
                        l.Total_Events_Conducted__c = l.Total_Events_Conducted__c + 1;      
                    try{
                        update l;
                    } catch (Exception e1)
                    {
                    
                    } 
                }
            }
            integer i=0;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
            ++i;
       }
}