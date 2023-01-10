({
 	getAllOpportunityInfo: function(component, event, helper) {
        debugger;
        console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.defaultValue"));
        var action = component.get("c.sendOpportunityDetails");
        action.setParams({
            "opportunityId": component.get("v.defaultValue")
        });
        
        action.setCallback(this, function(response) {
          //  console.log('Entered the second handler -->22');
            console.log(response.getState() );
            if (response.getState() === "SUCCESS" && response != null) {
                var results = response.getReturnValue();
                //console.log("@@@@@@@@@@@@"+results);
                component.set("v.opportunityList", results);
           //     helper.helperMethod6(component,event,helper);
                
                console.log("@@@@@@@@@@opportunityList"+JSON.stringify(component.get("v.opportunityList"))+'11111*************************'); 
            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
                console.log('error in helper');
            }
        });
        $A.enqueueAction(action);
    },
})