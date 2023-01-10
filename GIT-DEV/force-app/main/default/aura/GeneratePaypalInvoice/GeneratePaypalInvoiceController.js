({
	myAction : function(component, event, helper) {
		
	},
    
    doInit : function(component, event, helper) {
		helper.getInvoiceStatus(component, event);
	},
    
    handleClick: function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
        
        console.log(component.get('v.recordId'));
        urlEvent.setParams({
            "url":"/apex/PaypalInvoice?id="+component.get('v.recordId')
        });
        urlEvent.fire();
	}
})