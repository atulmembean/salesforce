({
	 helperMethod1: function(component, event, helper) {
       console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.recordId"));
        var action = component.get("c.getAllFieldValue");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            console.log('Entered the second handler -->22');
            console.log(response.getState());
            if (response.getState() === "SUCCESS" && response != null) {
                var results = response.getReturnValue();
                //console.log("@@@@@@@@@@@@"+results);
                component.set("v.customAttribute1", results);
                console.log("@@@@@@@@@@"+JSON.stringify(component.get("v.customAttribute1"))+'11111*************************'); 
            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
                console.log('error in helper2');
            }
        });
        $A.enqueueAction(action);
    }
})