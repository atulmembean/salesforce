global class ProcessCustAccountTimezoneupdate implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext context){
        string query;
        String yr1 = '2019';
        String yr2 = '2020';
        if (Test.isRunningTest())
            query='Select Id from Account where Timezone_UI__c = Null AND Timezone_Geopointe__c != Null LIMIT 3';
        else
            query='Select Id from Account where Timezone_UI__c = Null AND Timezone_Geopointe__c != Null AND Batch_Timezone__c = TRUE LIMIT 49000';
        return Database.getQueryLocator(query);
    }
    global void  execute(database.BatchableContext context, List<Account>lstAcc)
    {
        for (Account a :lstAcc)
            processRecord(a.Id);
    }
    
    global void finish(Database.BatchableContext context){
        
    }
    
    global void processRecord(String rId)
    {
        Account a = [Select Id,Timezone_UI__c,Timezone__c,Timezone_Geopointe__r.Name  from Account where Id  = :rId];
        if (a != Null)
        {
            a.Timezone_UI__c = a.Timezone_Geopointe__r.Name;
            String str = a.Timezone_Geopointe__r.Name;
            //if (a.Timezone__c == Null)
            a.Timezone__c = str.RIGHT(str.Length()-10);
            update a;
        } 
    }
}