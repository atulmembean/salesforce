/*
Author: Nirosha MG
Date Created: 04/10/2016
Purpose: To update Stage to Pilot Ended if Pilot End Date crossed today.
*/  
global class BatchUpdateOpportunity implements Database.Batchable<sObject>{

global String query; 
    
global database.querylocator start(Database.BatchableContext bc){
         
    		//datetime  d=System.today() - 1;
    		//system.debug('----'+ d);
           query= 'Select Id,name from Opportunity where StageName = \'Pilot\' AND Pilot_End_Date__c !=null AND Pilot_End_Date__c=yesterday';
          
         return Database.getQueryLocator(query);  
}

global void execute(Database.BatchableContext bc, List<Opportunity> scope){
  
  List<Opportunity> oppList = new List<Opportunity>();

     for (Opportunity s : scope){      
          s.StageName='Pilot Ended';
          oppList.add(s);
     }
    try{
        update oppList;    
      }catch(Exception e)
        {
        
        }
}

global void finish(Database.BatchableContext bc){

}

}