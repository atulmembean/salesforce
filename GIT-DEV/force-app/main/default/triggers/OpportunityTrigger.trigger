/**
* Trigger           : OpportunityTrigger
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : Business logic is written in OpportunityTriggerHandler.
**/
trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete) {
    
    if(Trigger.isBefore) { 
        if(Trigger.isInsert && OpportunityService.runBeforeOnce()) {
            //OpportunityTriggerHandler.emailGaneshWhenOppStageBecomesOnthefenceOrClosedLost(true,Trigger.new,null, null);
            OpportunityTriggerHandler.updateOpportunityName(Trigger.new);
            OpportunityTriggerHandler.updateRecordtypesOpportunity(Trigger.new);
  
        }
        
        if(Trigger.isUpdate && OpportunityService.runBeforeOnce()) {
            //OpportunityTriggerHandler.emailGaneshWhenOppStageBecomesOnthefenceOrClosedLost(false,Trigger.new,Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.captureMembeanStudentCountWhenOppConvertsFromPilotToCloseWon(Trigger.new,Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.updateClosedDateToTodaysDateifOppisCloseWon(Trigger.new,Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.updateOpportunityName(Trigger.new); 
            OpportunityTriggerHandler.updateChildAmount(Trigger.new);
            OpportunityTriggerHandler.updateOppSubscriptionFlag(Trigger.oldMap, Trigger.newMap);
            OpportunityTriggerHandler.updateRecordtypesOpportunity(Trigger.new);
        }
        
        if(Trigger.isDelete && OpportunityService.runBeforeOnce()) {
           OpportunityTriggerHandler.deleteChildOppsOnDeleteParent(Trigger.old);
        }
    }
    
    if(Trigger.isAfter ) { 
        if(Trigger.isInsert && OpportunityService.runAfterOnce()) {
            //OpportunityTriggerHandler.emailGaneshWhenOppStageBecomesOnthefenceOrClosedLost(true,Trigger.new,null, null);
            OpportunityTriggerHandler.pilotRecordsCreationWhenPilotEndDateOnOppChanges(true,Trigger.new,null, null);
            OpportunityTriggerHandler.contactRoleCreationOnOpportunityIfTeacherIsTagged(Trigger.new,Trigger.newMap, null);
            OpportunityTriggerHandler.UpdateAccountMembeanExpiresOn(Trigger.new,null,null);
            OpportunityTriggerHandler.createTeachersMembeanUsage(Trigger.new);
            if(Test.isRunningTest())
                OpportunityTriggerHandler.createUpdateSubscription(Trigger.newMap, null);
            OpportunityTriggerHandler.activityUpdateOnCreation(Trigger.new);
            OpportunityTriggerHandler.ChildOppCustomRollup(Trigger.new);
        }
        
        
        if(Trigger.isUpdate) {
            system.debug('opportunity update'+Trigger.new+'Trigger.oldMap **'+Trigger.oldMap);
            
            if(OpportunityService.runAfterOnce()){
 
            OpportunityTriggerHandler.acknowledgementUpdate(Trigger.newMap.keyset(),Trigger.oldMap);
            OpportunityTriggerHandler.updateAccountStatusToPilot(Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.updateStartPilotonChildOpp(Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.updateChildOppStage(Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.UpdateAccountMembeanExpiresOn(Trigger.new,Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.updateAccSubscriptionsOnOpptyMoveFromCloseWon(Trigger.new,Trigger.newMap, Trigger.oldMap);
            
            OpportunityTriggerHandler.contactRoleCreationOnOpportunityIfTeacherIsTagged(Trigger.new,Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.updatePilotYearsInAccountWhenOppPilotIsStarted(false,Trigger.new,Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.pilotRecordsCreationWhenPilotEndDateOnOppChanges(false,Trigger.new,Trigger.newMap, Trigger.oldMap);
            OpportunityTriggerHandler.ChildOppCustomRollup(Trigger.new);
            OpportunityTriggerHandler.createUsageFidelityOnPilot(Trigger.new,Trigger.oldMap);  
            if(!Test.isRunningTest())
                //OpportunityTriggerHandler.createUpdateSubscription(Trigger.newMap, Trigger.oldMap);
                OpportunityTriggerHandler.logUpdateOnStageChange(Trigger.new,Trigger.oldMap);
            }
        }   
        
        if(Trigger.isDelete && OpportunityService.runAfterOnce()) {
            OpportunityTriggerHandler.updateSubscriptionOnDelete(Trigger.oldMap);
            OpportunityTriggerHandler.updatePilotYearsOnDeletion(Trigger.oldMap);
            OpportunityTriggerHandler.ChildOppCustomRollup(Trigger.old);
        }
    }
    
    /**For Validation on Split School Detail- Creation of custom rollup for capture count of child opportunities**/
     /*if (Trigger.isInsert && OpportunityService.runAfterOnce()) {
        if(trigger.isAfter){
            OpportunityTriggerHandler.ChildOppCustomRollup(Trigger.new);
        }        
    }
    if ((Trigger.isUpdate || Trigger.isDelete) && OpportunityService.runAfterOnce()) {
        if(trigger.isAfter){
            OpportunityTriggerHandler.ChildOppCustomRollup(Trigger.old);            
        }
    }
    
    if(Trigger.isUpdate && trigger.isAfter && OpportunityService.runAfterOnce()){
        OpportunityTriggerHandler.createUsageFidelityOnPilot(Trigger.new,Trigger.oldMap);
    } */  
}