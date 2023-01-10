trigger InvoiceTrigger on Invoice__c (before insert,after insert,before update,after update,before delete,after delete) {

    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
            
        }
        
        if(Trigger.isUpdate){
            if(InvoiceService.runBeforeOnce()){
                InvoiceTriggerHandler.invokePaypalHandler(Trigger.newMap.keyset(),Trigger.new,Trigger.oldMap);                
            }  
        }
    }
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
        }
        
        if(Trigger.isUpdate){
                      
        }
        
        if(Trigger.isDelete){
            if(InvoiceService.runBeforeOnce()){
                InvoiceTriggerHandler.invokePaypalHandlerforDeleteInvoice(Trigger.old);                
            }              
        }
        
    }
    
}