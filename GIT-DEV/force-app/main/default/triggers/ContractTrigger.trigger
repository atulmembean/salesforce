/**
* Trigger           : ContractTrigger
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : Business logic is written in ContractTriggerHandler.
**/
trigger ContractTrigger on Contract (after insert, after update, after delete) {
    if(Trigger.isAfter) { 
        if(Trigger.isInsert) {
            ContractTriggerHandler.updateSchoolDetails(Trigger.new, null);
        }
        
        if(Trigger.isUpdate) {
            ContractTriggerHandler.updateSchoolDetails(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isDelete) {
            ContractTriggerHandler.updateSubscriptionYears(Trigger.oldMap);
        }
    }
}