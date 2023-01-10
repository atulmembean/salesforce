global class ProcessDistrictOpptyChildCount implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            if(Test.isRunningTest()){
               query = 'Select id from Opportunity where StageName != \'Close Won\' AND StageName != \'Close Lost\' AND StageName != \'Cancelled\' AND Count_of_Child_Opportunities__c > 0 order by CreatedDate DESC LIMIT 5';  
            }
            else{
               query = 'Select id from Opportunity where StageName != \'Close Won\' AND StageName != \'Close Lost\' AND StageName != \'Cancelled\' AND Count_of_Child_Opportunities__c > 0';
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
            Opportunity o = [Select Id,Count_of_Child_Opportunities__c from Opportunity where Id = :rId];
            if (o != Null)
            {
                List<Opportunity> olst = [Select Id from Opportunity where Parent_Opportunity__c = :o.Id];
                if (olst.Size() != o.Count_of_Child_Opportunities__c)
                {
                    o.Count_of_Child_Opportunities__c = olst.Size();
                    update o;
                }               
            }
       }
}