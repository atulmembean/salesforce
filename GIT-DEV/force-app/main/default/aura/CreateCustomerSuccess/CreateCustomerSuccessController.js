({
	handleClick : function(component, event, helper) {
		 var evt = $A.get("e.force:navigateToComponent");
         evt.setParams({
             componentDef : "c:CustomerSuccessCreateNew",
             //componentDef: "c:TestCmp",
            componentAttributes: {
                defaultValue : component.get("v.recordId")
            } 
       });
         evt.fire();
	},
    
    doInit : function(component, event, helper) {
        helper.helperMethod1(component,event,helper);
    },
	/*Navigate : function(component, event, helper) {
         $A.createComponent(
            "c:SampleCustomerSuccessPage",
            {
                 
            },
            function(newCmp){
                if (component.isValid()) {
                    var body = component.get("v.body");
                    body.push(newCmp);
                    component.set("v.body", body);
                }
            }
        );	        
		
	}*/
})