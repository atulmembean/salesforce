({
	myAction : function(component, event, helper) {
		
	},
    
    doInit : function(component, event, helper) {
		var action = component.get("c.getInvoiceDetails");
        
        action.setParams({
            'invId': component.get("v.recordId") 
        });
        
        action.setCallback(this,function(res){
            if(res.getReturnValue().Paypal_Invoice_Id__c){
                component.set("v.status","True");
                component.set("v.Invoice",res.getReturnValue());
            }
            else{
                component.set("v.status","False");
            }
        });
        
        $A.enqueueAction(action);
	},
    
    handleClick: function(component,event,helper){
        var action = component.get("c.cancelInvoice");
        
        action.setParams({
            'invoice':  component.get("v.Invoice")
        });
        
        action.setCallback(this,function(res){
            var toastEvent = $A.get("e.force:showToast");
            if(res.getReturnValue() == 'success'){
                
                    
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Paypal invoice deleted successfully."
                    });
                    toastEvent.fire();
				
            }
            else{
                	toastEvent.setParams({
                        "title": "Error!",
                        "message": res.getReturnValue()
                    });
                    toastEvent.fire();
            }
            
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url":'/one/one.app?#/sObject/'+component.get('v.recordId')+'/view'
            });
            urlEvent.fire();
        })
        
        $A.enqueueAction(action);
    }
})