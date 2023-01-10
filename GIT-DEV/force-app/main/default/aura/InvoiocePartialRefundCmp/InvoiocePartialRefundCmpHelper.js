({
    invokePartialRefund : function(component,event) {
        console.log('Inside helper');
        debugger;
        var action=component.get("c.processPartialRefund");
        action.setParams({invoiceId:component.get("v.recordId"),
                          itemList:component.get("v.quoteItemList")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                //Invoice Cancelled
                if(response.getReturnValue()!='Success'){
                    component.set("v.errorMsg",response.getReturnValue());
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Refund processed successfully.",
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
                    "message": "Some error occurred. ",
                    "type":"error"
                });
                toastEvent.fire();
                 $A.get("e.force:closeQuickAction").fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    queryLineItem:function(component,event){
        var action=component.get("c.fetchLilneItems");
        action.setParams({invoiceId:component.get("v.recordId")});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                component.set("v.quoteItemList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})