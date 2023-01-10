({
		handleClick : function(component, event, helper) {
            debugger;
            console.log(component.get("v.recordId"));
		 var evt = $A.get("e.force:navigateToComponent");
         evt.setParams({
             componentDef : "c:AddRemoveSchools",
             componentAttributes: {
                defaultValue : component.get("v.recordId")
            } 
       });
         evt.fire();
	},
    
    doInit : function(component, event, helper) {
		helper.getAllOpportunityInfo(component, event, helper);
	}
})