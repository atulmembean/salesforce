({
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
        debugger;
         action.setCallback(this,function(response){
             var state = response.getState();
             if(state === "SUCCESS") {
                 var resp = response.getReturnValue();
                 var options = [];
                 var values = [];
                 var required = [];
                 var aftersplit = [];
                 required=component.get("v.viewCustomAttribute.Risk_Reason__c");
                 if(required != null && required != ''){
                 	aftersplit = required.split(';');
                  	console.log(aftersplit);
                 }else{
                     aftersplit = '';
                 }
                 component.set("v.defaultOptions",aftersplit);
                 console.log('Its the required values~~~~~~~~'+required);
                 for (var i = 0; i < resp.length; i++) {
                    options.push(
                              { value: resp[i], label: resp[i] }
                    );
                }
                 component.set("v.listOptions", options);
                // component.set("v.defaultOptions", values);
                // component.set("v.requiredOptions", required);
                // console.log(component.get("v.requiredOptions"));
             }
         });
         
         $A.enqueueAction(action);
    },
     
   /* handleChange: function (cmp, event) {
        // Get the list of the "value" attribute on all the selected options
        var selectedOptionsList = event.getParam("value");
        alert("Options selected: '" + selectedOptionsList + "'");
    },  */

 onViewOfRecord: function(component, event, helper) {
     debugger;
    // component.get("v.Disable");
        //component.set("v.Disable", true);
       console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.recordId"));
        var action = component.get("c.getAllCustomerSuccessRecord");
        action.setParams({
            "customerSuccessRecord": component.get("v.recordId")
        });
     //  "customerSuccessString":JSON.stringify(component.get("v.CustomerSuccessObj"))
        
        action.setCallback(this, function(response) {
            console.log('Entered the onViewOfRecord -->66666');
            console.log(response.getState() );
            if (response.getState() === "SUCCESS" && response != null) {
                debugger;
                var results = response.getReturnValue();
                component.set("v.viewCustomAttribute", results);
                
                helper.helperMethod6(component,event,helper);  
                
                console.log("@@@@@@@@@@"+JSON.stringify(component.get("v.viewCustomAttribute"))+'11111*************************'); 
				console.log("@@@@@@@@@@"+JSON.stringify(component.get("v.CustomerSuccessObj"))+'222222*************************'); 

            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
            }
        });
        $A.enqueueAction(action);
    },
    getOppRelatedValues: function(component, event, helper) {
        
       console.log("!!!!!!!!!!!!!!!!!!"+component.get("v.recordId"));
        var action = component.get("c.getAllFieldValue");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            console.log('Entered the getOppRelatedValues -->7777');
            console.log(response.getState() );
            if (response.getState() === "SUCCESS" && response != null) {
                var results = response.getReturnValue();
                component.set("v.customAttribute", results);
              
                             
                console.log("@@@@@@@@@@"+JSON.stringify(component.get("v.customAttribute"))+'11111*************************'); 
            } else if (response.getState() === "ERROR") {
                component.set("v.error", "An error has occurred");
            }
        });
        $A.enqueueAction(action);
    },
    SubscriptionDetails: function(component, event, helper){
        var action = component.get("c.getAllRelatedSubscriptionsFromAccount");
        action.setParams({
            "oppId": component.get("v.recordId")
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
    helperMethod6 :function(component, event, helper) {
    
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
         	  "NewFeature":component.get("v.viewCustomAttribute.New_Feature__c"),
              "Testing":component.get("v.viewCustomAttribute.Testing__c"),
              "Grading":component.get("v.viewCustomAttribute.Grading__c"),
              "Activities":component.get("v.viewCustomAttribute.Activities__c"),
              "OtherProponents":component.get("v.viewCustomAttribute.Other_Proponents__c"),
              "issuesandConcerns":component.get("v.viewCustomAttribute.Concerns_and_Issues__c"),
              "CallPreps":component.get("v.viewCustomAttribute.Call_Preps__c"),
              "Agent":component.get("v.viewCustomAttribute.Agents__c"),
              "Mode":component.get("v.viewCustomAttribute.Mode__c"),
              "RiskFactor":component.get("v.viewCustomAttribute.Risk_Factor__c"),
	          "RiskReasonSelected":component.get("v.viewCustomAttribute.Risk_Reason__c"),
              "Direction":component.get("v.viewCustomAttribute.Direction__c"),
              "Source":component.get("v.viewCustomAttribute.Source__c"),
              "conName":component.get("v.viewCustomAttribute.Contact__r.Name"),
         	 // "ContactIDView":component.get("v.viewCustomAttribute.Contact__r.Name"),
              "accName":component.get("v.viewCustomAttribute.Account__r.Name"),
              "oppName":component.get("v.viewCustomAttribute.Opportunity__r.Name")
        }
     
     component.set("v.CustomerSuccessObj",customerSuccess);
    }
})