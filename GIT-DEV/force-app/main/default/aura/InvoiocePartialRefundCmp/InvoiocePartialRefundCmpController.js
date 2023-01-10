({
	doInit : function(component, event, helper) {
       component.set("v.confirmed",true);
       
        
		//helper.invokePartialRefund(component, event);
	},
    doRefund:function(component,event,helper){
        console.log('inside controller.js');
        
        
            helper.invokePartialRefund(component, event);
       
		
	},
    
   
    handleClose:function(component, event, helper) {
        component.set("v.confirmed",false);
        $A.get("e.force:closeQuickAction").fire();
    },
    handleCancelConfirmed:function(component,event,helper){
        component.set("v.confirmed",false);
         helper.queryLineItem(component,event);
        
    }
})