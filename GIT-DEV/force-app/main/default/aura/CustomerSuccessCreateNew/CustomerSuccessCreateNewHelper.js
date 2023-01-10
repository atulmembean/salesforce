({
    helperMethod1 : function(component,event,helper) {
        var action = component.get("c.getOpportunityList");
        action.setCallback(this,function(response) {
            // console.log(response);
            console.log('this is inside action');
            var state =  response.getState();
            if(state === "SUCCESS") {
                component.set("v.oppList",response.getReturnValue());  
                console.log(JSON.stringify(component.get("v.oppList"))+'*************************');   
            }
        });
        $A.enqueueAction(action);
    },
    helperMethod2: function(component, event, helper) {
        debugger;
        console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.recordId"));
        var action = component.get("c.getAllFieldValue");
        action.setParams({
            "oppId": component.get("v.defaultValue")
        });
        
        action.setCallback(this, function(response) {
            console.log('Entered the second handler -->22');
            console.log(response.getState() );
            if (response.getState() === "SUCCESS" && response != null) {
                var results = response.getReturnValue();
                //console.log("@@@@@@@@@@@@"+results);
                component.set("v.customAttribute", results);
                helper.helperMethod6(component,event,helper);
                
                console.log("@@@@@@@@@@CustomAttribute"+JSON.stringify(component.get("v.customAttribute"))+'11111*************************'); 
            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
                console.log('error in helper2');
            }
        });
        $A.enqueueAction(action);
    },
    helperMethod3: function(component, event, helper){
        var action = component.get("c.getAllRelatedSubscriptionsFromAccount");
        action.setParams({
            "oppId": component.get("v.defaultValue")
        });
        
        action.setCallback(this, function(response) {
            console.log('Entered the second handler -->33');
            console.log(response.getState());
            if (response.getState() === "SUCCESS" && response != null){
                var results = response.getReturnValue();
                console.log(results);
                component.set("v.SubscriptionDetails", response.getReturnValue());
                console.log(JSON.stringify(component.get("v.SubscriptionDetails"))+'3333*************************'); 
            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
                console.log('error in helper3');
            }
        });
        $A.enqueueAction(action);
    },
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    fetchMultiSelect: function (component,fieldName) {
         
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        
         action.setCallback(this,function(response){
             var state = response.getState();
             if(state === "SUCCESS") {
                 var resp = response.getReturnValue();
                 var options = [];
                 var values = [];
                 for (var i = 0; i < resp.length; i++) {
                    options.push(
                              { value: resp[i], label: resp[i] }
                    );
                }
                 component.set("v.listOptions", options);
                 component.set("v.defaultOptions", values);
             }
         });
         
         $A.enqueueAction(action);
    },
    helperMethod6 :function(component, event, helper) {
        
        var customerSuccess = {
            "CusId":"",
            "CustomerSuccessName":"Customer Success Reachout",
            "accId":component.get("v.customAttribute.AccountId"),
            "UsageRelatedDiscussion":"", 
            "GrowthRelatedDiscussion":"",
            "Comments":"",
            "oppId":component.get("v.defaultValue"),
            "UserRating":"",
            "CallFeedback":"",
            "Training":"",
            "Status":"",
            "DueDate":"",
            "NewFeatureExploration":"",
            "NewFeature":"",
            "Testing":"",
            "Grading":"",
            "Activities":"",
            "OtherProponents":"",
            "issuesandConcerns":"",
            "CallPreps":"",
            "Agent":"",
            "Mode":"",
            "RiskFactor":"",
            "RiskReasonSelected":"",
            "RiskReason":"",
            "Direction":"",
            "Source":"",
           // "ContactId":"",
            "accName":component.get("v.customAttribute.Account.Name"),
            "oppName":component.get("v.customAttribute.Name")
        }
        
        component.set("v.CustomerSuccessObj",customerSuccess);
    },
    helperMethod7 :function(component, event, helper) {
        debugger;
        var customerSuccess = {
            "CusId":component.get("v.viewCustomAttribute.Id"),
            "CustomerSuccessName":component.get("v.viewCustomAttribute.Name"),
            "accId":component.get("v.viewCustomAttribute.Account__c"),
            "UsageRelatedDiscussion":component.get("v.viewCustomAttribute.Usage_Related_Discussion__c"), 
            "GrowthRelatedDiscussion":component.get("v.viewCustomAttribute.Growth_Related_Discussion__c"),
            "Comments":component.get("v.viewCustomAttribute.Comments__c"),
            "oppId":component.get("v.viewCustomAttribute.Opportunity__c"),
            "UserRating":component.get("v.viewCustomAttribute.User_Rating__c"),
            "CallFeedback":component.get("v.viewCustomAttribute.Call_Feedback__c"),
            "Training":component.get("v.viewCustomAttribute.Training__c"),
            "Status":component.get("v.viewCustomAttribute.Status__c"),
            "DueDate":component.get("v.viewCustomAttribute.Due_Date__c"),
            "NewFeatureExploration":component.get("v.viewCustomAttribute.New_Feature_Exploration__c"),
            "accName":component.get("v.customAttribute.Account.Name"),
            "oppName":component.get("v.customAttribute.Name"),
            "districtAccount":component.get("v.viewCustomAttribute.District_Account__c")
        }
        
        component.set("v.CustomerSuccessObj",customerSuccess);
    }
    /*  onViewOfRecord: function(component, event, helper) {
        
        //console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.recordId"));
        var action = component.get("c.saveCustomerSuccesssRecord");
        action.setParams({
            "customerSuccessString":JSON.stringify(component.get("v.CustomerSuccessObj"))
        });
        //  "customerSuccessString":JSON.stringify(component.get("v.CustomerSuccessObj"))
        
        action.setCallback(this, function(response) {
            console.log('Entered the onViewOfRecord for update -->888');
            console.log(response.getState() );
            if (response.getState() === "SUCCESS" && response != null) {
                var results = response.getReturnValue();
                component.set("v.viewCustomAttribute", results);
                
                // helper.helperMethod6(component,event,helper);  
                
                console.log("@@@@@@@@@@"+JSON.stringify(component.get("v.viewCustomAttribute"))+'11111*************************'); 
                console.log("@@@@@@@@@@"+JSON.stringify(component.get("v.CustomerSuccessObj"))+'222222*************************'); 
                
            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
            }
        });
        $A.enqueueAction(action);
    } */
})