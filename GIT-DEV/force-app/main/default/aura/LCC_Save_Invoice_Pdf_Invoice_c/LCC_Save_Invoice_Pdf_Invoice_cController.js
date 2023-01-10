({

        apexExecute : function(component, event, helper) {
            //Call Your Apex Controller Method.
            var action = component.get("c.saveInvoicePdfLightning");
            
            action.setParams({
                'invoiceID': ''+component.get('v.sObjectInfo.Id')+''
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log(state);
                
                    if (state === "SUCCESS") {
                        //after code
                        response.getReturnValue();
						alert('The invoice pdf is saved successfully');
						window.location.reload('/'+component.get('v.sObjectInfo.Id')+'');
                        $A.get("e.force:closeQuickAction").fire();
                    } else {
                        
                    }
                    
            });
            
            $A.enqueueAction(action);
	}
})