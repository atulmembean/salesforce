trigger CityStateMapTrigger on City_State_Mapping__c (before insert,after insert,before update,after update,before delete,after delete) {
	
    if(trigger.isUpdate){
        
        if(trigger.isBefore){
            
        }
        
        if(trigger.isAfter){
           CityStateMapTriggerHandler.insertTaxLineItem(trigger.new,trigger.oldMap); 
        }
        
    }
    
    
}