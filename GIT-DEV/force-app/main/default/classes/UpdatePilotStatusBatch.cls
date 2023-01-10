global class UpdatePilotStatusBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query;
        Date todayDate = system.today();
        String status = 'Ended';
        if (Test.isRunningTest())
            //query='Select Id,Name,Pilot_Status__c,LatestPilotEndDate1__c from Account Where LatestPilotEndDate1__c <= :todayDate';
            query='Select Id,AccountId,Pilot_End_Date__c from Opportunity where Temporary_Membean_Extension_Date__c = :todayDate OR Pilot_End_Date__c = :todayDate LIMIT 3';
        else
         //query='Select Id,AccountId,Name,Pilot_Status__c,LatestPilotEndDate1__c from Account Where LatestPilotEndDate1__c <= :todayDate and Pilot_Status__c != :status';
         query='Select Id,Pilot_End_Date__c from Opportunity where Temporary_Membean_Extension_Date__c = :todayDate OR Pilot_End_Date__c = :todayDate';   
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    { 
        for (Opportunity opp :scope)
        {
            processRecord(opp.Id);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    global void processRecord(String rId)
    {
        Opportunity o = [Select Id,AccountId from Opportunity where Id = :rId];
        if (o != Null)
        {
            List<Account> a = [Select Id,Pilot_Status__c,LatestPilotEndDate1__c from Account where Id = :o.AccountId];
            if (a.Size() > 0)
            {
                a[0].Pilot_Status__c = 'Ended';
                a[0].LatestPilotEndDate1__c = System.Today();
                update a[0];
            }
        }
    }
}