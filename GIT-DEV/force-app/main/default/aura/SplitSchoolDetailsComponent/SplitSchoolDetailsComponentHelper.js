({
	 getAllquoteInfo: function(component, event, helper) {
        debugger;
        console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.quoteRecId"));
        var action = component.get("c.sendQuoteDetails");
        action.setParams({
            "quoteId": component.get("v.quoteRecId")
        });
        
        action.setCallback(this, function(response) {
          //  console.log('Entered the second handler -->22');
            console.log(response.getState() );
            if (response.getState() === "SUCCESS" && response != null) {
                var results = response.getReturnValue();
                //console.log("@@@@@@@@@@@@"+results);
                component.set("v.quoteList", results);
           //     helper.helperMethod6(component,event,helper);
                
                console.log("@@@@@@@@@@quoteList"+JSON.stringify(component.get("v.quoteList"))+'11111*************************'); 
            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
                console.log('error in helper');
            }
        });
        $A.enqueueAction(action);
    },
})