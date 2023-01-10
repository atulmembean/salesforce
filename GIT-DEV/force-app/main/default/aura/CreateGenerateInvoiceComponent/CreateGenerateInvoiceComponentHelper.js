({
	getAllquoteInfo: function(component, event, helper) {
            debugger;
        
            console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.recordId"));
            var action = component.get("c.sendQuoteDetails");
            action.setParams({
                "quoteId": component.get("v.recordId")
            });
            
            action.setCallback(this, function(response) {
                console.log(response.getState() );
                if (response.getState() === "SUCCESS" && response != null) {
                    var results = response.getReturnValue();
                    
                    if(results.Opportunity.Student_Pay__c ==true){
                        
                        component.set("v.message","Invoice cannot be created for Parent Pay Opportunity");
                    }else{
                        component.set("v.quoteList", results);
                    }
                    console.log("@@@@@@@@@@quoteList"+JSON.stringify(component.get("v.quoteList"))+'11111*************************'); 
                } else if (response.getState() === "ERROR") {
                    component.set("v.error", "An error has occurred");
                    console.log('error in helper');
                }
            });
            $A.enqueueAction(action);
        },
})