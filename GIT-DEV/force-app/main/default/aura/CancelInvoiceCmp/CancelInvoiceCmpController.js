({
	doInit : function(component, event, helper) {
        component.set("v.confirmed",true);
       
       
		
	},
    handleClose:function(component, event, helper) {
        
        $A.get("e.force:closeQuickAction").fire();
    },
    handleCancelConfirmed:function(component,event,helper){
        component.set("v.confirmed",false);
        helper.invokeCancelInvoice(component, event);
    }
})