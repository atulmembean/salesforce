trigger InvoiceLineItemTrigger on Invoice_Line_Item__c (before insert,after insert,before update,after update,before delete,after delete) {

    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
            
        }
        
        if(Trigger.isUpdate){
            
        }
    }
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
        }
        
        if(Trigger.isUpdate){
            if(InvoiceService.runBeforeOnce()){
            	InvoiceLineItemTriggerHandler.invokePaypalHandler(Trigger.new);
            }
        }
    }
    
}