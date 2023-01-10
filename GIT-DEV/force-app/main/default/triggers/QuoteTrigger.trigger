trigger QuoteTrigger on Quote (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
    QuoteTriggerHandler quoteTriggerHandlerObj =  new QuoteTriggerHandler(Trigger.new,Trigger.old,Trigger.newMap,Trigger.oldMap);
    quoteTriggerHandlerObj.run();
    
    if(trigger.isUpdate&&trigger.isAfter) {
       
       if(OpportunityService.runAfterOnce() || Test.isRunningTest()){
            
            QuoteTriggerHandler q = new QuoteTriggerHandler();
            q.quoteSyncWithOpportunity(Trigger.New,Trigger.oldMap);
           
       }
    }
    
    if(trigger.isUpdate && trigger.isBefore){
        //Added by Karthik on 1/07/2020 to restrict modification of accepted quote having multiple invoices
       QuoteTriggerHandler.restrictAcceptedQuoteModification(Trigger.oldMap, Trigger.newMap);
        
       if(OpportunityService.runBeforeOnce() || Test.isRunningTest()){
            QuoteTriggerHandler q = new QuoteTriggerHandler();
            q.discountAmount(Trigger.New);
        }
    }
    
    if(Trigger.isUpdate){
        if(Trigger.isBefore){
            
        }
        
        if(Trigger.isAfter){
              
              QuoteTriggerHandler.activityLogUpdate(Trigger.new, Trigger.oldMap);
              QuoteTriggerHandler.quoteAmountChange(Trigger.new,Trigger.oldMap);
              QuoteTriggerHandler.quoteChange(Trigger.new,Trigger.oldMap);
        }
    }
    
    if(Trigger.isDelete){
        if(Trigger.isBefore){
            
        }
        
        if(Trigger.isAfter){                            
              QuoteTriggerHandler.quoteAmountChange(Trigger.old,Trigger.oldMap);
        }
    }
    
}