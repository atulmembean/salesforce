({
    getAllOpportunityInfo: function(component, event, helper) {
            debugger;
            console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.recordId"));
            var action = component.get("c.sendOpportunityDetails");
            action.setParams({
                "opportunityId": component.get("v.recordId")
            });
            
            action.setCallback(this, function(response) {
                console.log(response.getState() );
                if (response.getState() === "SUCCESS" && response != null) {
                    var results = response.getReturnValue();
                    component.set("v.opportunityList", results);
                    console.log("@@@@@@@@@@opportunityList"+JSON.stringify(component.get("v.opportunityList"))+'11111*************************'); 
                } else if (response.getState() === "ERROR") {
                    component.set("v.error", "An error has occurred");
                    console.log('error in helper');
                }
            });
            $A.enqueueAction(action);
        },
})