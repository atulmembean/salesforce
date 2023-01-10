({
    invokeCancelInvoice : function(component,event) {
        var action=component.get("c.cancelQuoteInvoice");
        action.setParams({invoiceId:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                //Invoice Cancelled
                var returnMsg=response.getReturnValue();
                if(returnMsg!='Success'){
                    component.set("v.errorMsg",returnMsg);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Invoice cancelled successfully.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();     
                }
                
            }else{
                //Some error occurred
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some error occurred. Please check active invoice exists",
                    "type":"error"
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire(); 
            }
            
        });
        $A.enqueueAction(action);
    }
})