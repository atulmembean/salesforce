trigger CustomerSuccessTrigger on Customer_Success__c (before insert,before update) {
	
    if(Trigger.isBefore) { 
        if(Trigger.isInsert) {
           // Update a CustomerSuccess Name based on  Account name and a string 
           CustomerSuccessTriggerHandler.updateCustomerSuccessName(Trigger.new);
        }
        
        if(Trigger.isUpdate) {
           // Update a CustomerSuccess Name based on  Account name and a string 
             CustomerSuccessTriggerHandler.updateCustomerSuccessName(Trigger.new); 
        } 
    }
}