({
	helperMethod : function() {
		
	},
    
    getInvoiceStatus: function(component,event){
        
        const action = component.get("c.getInvoiceStatus");
        
        action.setParams({
            'invId': component.get("v.recordId")
        });
        
        action.setCallback(this,function(res){
            console.log(res.getReturnValue());
            if(res.getReturnValue() == 'Success'){
                component.set("v.status",'True');                
            }
            else if(res.getReturnValue() == 'Exists'){
                component.set("v.status",'False');
            }
                        
        });
        
        $A.enqueueAction(action);
        
    }
})