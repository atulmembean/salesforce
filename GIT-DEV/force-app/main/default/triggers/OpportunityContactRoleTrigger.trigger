trigger OpportunityContactRoleTrigger on OpportunityContactRole (before insert, after insert, before update, after update, before delete, after delete) {
        
    if(Trigger.isBefore) {
        
        if(Trigger.isInsert){
            
        }
        
        if(Trigger.isUpdate){
            OpportunityContactRoleTriggerHandler.UpdateOppActivityLog(Trigger.new);
        }
        
    }
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            OpportunityContactRoleTriggerHandler.UpdateOppActivityLog(Trigger.new);
        } 
        
        if(Trigger.isUpdate){
            
        }
        
    }
}