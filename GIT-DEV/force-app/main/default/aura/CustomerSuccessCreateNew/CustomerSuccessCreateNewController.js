({
    doInit : function(component, event, helper) {
        
        helper.helperMethod1(component,event,helper);
        helper.helperMethod2(component,event,helper);
        helper.helperMethod3(component,event,helper);
        helper.fetchPickListVal(component, 'Status__c', 'Status');
        helper.fetchPickListVal(component, 'User_Rating__c', 'UserRating');
        helper.fetchPickListVal(component, 'Call_Feedback__c', 'CallFeedback');
        helper.fetchPickListVal(component, 'Agents__c', 'Agent');
        helper.fetchPickListVal(component, 'Mode__c', 'Mode');
        helper.fetchPickListVal(component, 'Risk_Factor__c', 'RiskFactor');
        helper.fetchMultiSelect(component, 'Risk_Reason__c');
        helper.fetchPickListVal(component, 'Direction__c', 'Direction');
        helper.fetchPickListVal(component, 'Source__c', 'Source');
        /*   helper.onViewOfRecord(component,event,helper); */
        /*var customerSuccess = {
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
              "NewFeatureExploration":"",
              "accName":component.get("v.customAttribute.Account.Name"),
              "oppName":component.get("v.customAttribute.Name")
            
              
            
        */
        
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        event.getSource().get("v.value");
        // alert(event.getSource().get("v.value"));
    },
    
     handleChange: function (cmp, event) {
         debugger;
        // Get the list of the "value" attribute on all the selected options
        var selectedOptionsList = event.getParam("value");
        var selectoptions = []; 
        for(var i =0 ; i< selectedOptionsList.length;i++) {
             selectoptions.push(selectedOptionsList[i]);
        } 
        cmp.set("v.defaultOptions",selectoptions); 
        cmp.set("v.CustomerSuccessObj.RiskReasonSelected",JSON.stringify(selectoptions)); 
        console.log(cmp.get("v.CustomerSuccessObj.RiskReasonSelected"));
        cmp.set("v.IsMultiSelectChange",true);
        console.log('IsMultiSelectChange is'+ cmp.get("v.IsMultiSelectChange"));
         
    },
    onMultiSelectChange: function(cmp, evt) {
        debugger;
        var selectCmp = cmp.find("RiskReason");
        console.log(selectCmp.get("v.value"));
        var resultCmp = cmp.find("multiResult");
        resultCmp.set("v.value", selectCmp.get("v.value"));
        console.log(resultCmp.get("v.value"));
        cmp.set("v.CustomerSuccessObj.RiskReasonSelected",resultCmp.get("v.value"));
        console.log(cmp.get("v.CustomerSuccessObj.RiskReasonSelected"));
    },
    goToSchool : function(component, event, helper){
        console.log("########"+component.get("v.customAttribute.AccountId"));
        var sObjectEvent = $A.get("e.force:navigateToSObject");        
        sObjectEvent.setParams({
            "recordId": component.get("v.customAttribute.AccountId")
        })
        sObjectEvent.fire();
    },
    goToOpportunity : function(component, event, helper){
        console.log("########"+component.get("v.customAttribute.Id"));
        var sObjectEvent = $A.get("e.force:navigateToSObject");        
        sObjectEvent.setParams({
            "recordId": component.get("v.customAttribute.Id")
        })
        sObjectEvent.fire();
    },
    saveRecord: function(component, event, helper){
       debugger;
       var AgentCheck = true;
        //  var Agentval = component.find("Agent");
        var Agentval= component.get("v.CustomerSuccessObj.Agent");
        console.log('its agent val***'+Agentval);
        var divErrAgent = component.find("divErrorAgent");
        $A.util.removeClass(divErrAgent,'slds-show');
        $A.util.addClass(divErrAgent,'slds-hide');
        
        var ContactVal = component.get("v.selectedLookUpRecord.Id");
        console.log('its selectedLookUpRecord***'+ContactVal);
        var divErrorContact = component.find("divErrorContact");
        $A.util.removeClass(divErrorContact,'slds-show');
        $A.util.addClass(divErrorContact,'slds-hide');
 
        var Modeval= component.get("v.CustomerSuccessObj.Mode");
        var divErrMode = component.find("divErrorMode");
        $A.util.removeClass(divErrMode,'slds-show');
        $A.util.addClass(divErrMode,'slds-hide');
        
        var Statusval= component.get("v.CustomerSuccessObj.Status");
        var divErrStatus = component.find("divErrorStatus");
        $A.util.removeClass(divErrStatus,'slds-show');
        $A.util.addClass(divErrStatus,'slds-hide');
        
        var ActivityDateval= component.get("v.CustomerSuccessObj.DueDate");
        var divErrActivityDate = component.find("divErrorActivityDate");
        $A.util.removeClass(divErrActivityDate,'slds-show');
        $A.util.addClass(divErrActivityDate,'slds-hide');
        
        var UserRatingval= component.get("v.CustomerSuccessObj.UserRating");
        var divErrUserRating = component.find("divErrorUserRating");
        $A.util.removeClass(divErrUserRating,'slds-show');
        $A.util.addClass(divErrUserRating,'slds-hide');
        
        var CallFeedbackval= component.get("v.CustomerSuccessObj.CallFeedback");
        var divErrCallFeedback = component.find("divErrorCallFeedback");
        $A.util.removeClass(divErrCallFeedback,'slds-show');
        $A.util.addClass(divErrCallFeedback,'slds-hide');
        
        var Directionval= component.get("v.CustomerSuccessObj.Direction");
        var divErrDirection = component.find("divErrorDirection");
        $A.util.removeClass(divErrDirection,'slds-show');
        $A.util.addClass(divErrDirection,'slds-hide');
        
        var Sourceval= component.get("v.CustomerSuccessObj.Source");
        var divErrSource = component.find("divErrorSource");
        $A.util.removeClass(divErrSource,'slds-show');
        $A.util.addClass(divErrSource,'slds-hide');
        
        var RiskFactorval= component.get("v.CustomerSuccessObj.RiskFactor");
        var divErrRiskFactor = component.find("divErrorRiskFactor");
        $A.util.removeClass(divErrRiskFactor,'slds-show');
        $A.util.addClass(divErrRiskFactor,'slds-hide');
        
        if(Agentval == null || Agentval == ''){
            console.log('its agent val inside if***'+Agentval);
            $A.util.removeClass(divErrAgent,'slds-hide');
            $A.util.addClass(divErrAgent,'slds-show');
            AgentCheck = false;
        }if(ContactVal == null || ContactVal == ''){
            $A.util.removeClass(divErrorContact,'slds-hide');
            $A.util.addClass(divErrorContact,'slds-show');
            AgentCheck = false;
        }if(Modeval == null || Modeval == ''){
            console.log('its Modeval inside if***'+Modeval);
            $A.util.removeClass(divErrMode,'slds-hide');
            $A.util.addClass(divErrMode,'slds-show');
            AgentCheck = false;
        }if(Statusval == null || Statusval == ''){
            console.log('its Statusval inside if***'+Statusval);
            $A.util.removeClass(divErrStatus,'slds-hide');
            $A.util.addClass(divErrStatus,'slds-show');
            AgentCheck = false;
        }if(ActivityDateval == null || ActivityDateval == ''){
            console.log('its ActivityDateval inside if***'+ActivityDateval);
            $A.util.removeClass(divErrActivityDate,'slds-hide');
            $A.util.addClass(divErrActivityDate,'slds-show');
            AgentCheck = false;
        }if(UserRatingval == null || UserRatingval == ''){
            console.log('its UserRatingval inside if***'+UserRatingval);
            $A.util.removeClass(divErrUserRating,'slds-hide');
            $A.util.addClass(divErrUserRating,'slds-show');
            AgentCheck = false;
        }if(CallFeedbackval == null || CallFeedbackval == ''){
            console.log('its CallFeedbackval inside if***'+CallFeedbackval);
            $A.util.removeClass(divErrCallFeedback,'slds-hide');
            $A.util.addClass(divErrCallFeedback,'slds-show');
            AgentCheck = false;
        }if(Directionval == null || Directionval == ''){
            console.log('its Directionval inside if***'+Directionval);
            $A.util.removeClass(divErrDirection,'slds-hide');
            $A.util.addClass(divErrDirection,'slds-show');
            AgentCheck = false;
        }if(Sourceval == null || Sourceval == ''){
            console.log('its Sourceval inside if***'+Sourceval);
            $A.util.removeClass(divErrSource,'slds-hide');
            $A.util.addClass(divErrSource,'slds-show');
            AgentCheck = false;
        }if(RiskFactorval == null || RiskFactorval == ''){
            console.log('its RiskFactorval inside if***'+RiskFactorval);
            $A.util.removeClass(divErrRiskFactor,'slds-hide');
            $A.util.addClass(divErrRiskFactor,'slds-show');
            AgentCheck = false;
        } 
        
        
        if(AgentCheck){
            console.log('########Selected'+JSON.stringify(component.get("v.selectedLookUpRecord")));
            var spinner  = component.find("mySpinner");
            $A.util.removeClass(spinner,'slds-hide');
            $A.util.addClass(spinner,'slds-show');
            
            var SaveRec  = component.find("saveRec");
            $A.util.removeClass(SaveRec,'slds-show');
            $A.util.addClass(SaveRec,'slds-hide');
            
            var action = component.get("c.saveCustomerSuccesssRecord");
            
            action.setParams({
                "customerSuccessString":JSON.stringify(component.get("v.CustomerSuccessObj")),
                "ContactId" : component.get("v.selectedLookUpRecord.Id"),
                "IsMultiSelectChange":component.get("v.IsMultiSelectChange")
                //"customerSuccessString":(component.get("v.CustomerSuccessObj"))
                
            });
            
            action.setCallback(this, function(response) {
                
                if (response.getState() === "SUCCESS" && response != null){
                    //  alert("Success");
                    var results = response.getReturnValue();
                    component.set("v.viewCustomAttribute", results);
                    
                    var sObjectEvent = $A.get("e.force:navigateToSObject");        
                    sObjectEvent.setParams({
                        "recordId": component.get("v.viewCustomAttribute.Id")
                    })
                    sObjectEvent.fire();
                    
                    $A.util.removeClass(spinner,'slds-show');
                    $A.util.addClass(spinner,'slds-hide');
                    
                    var EditRec  = component.find("editRec");
                    $A.util.removeClass(EditRec,'slds-hide');
                    $A.util.addClass(EditRec,'slds-show');
                    
                    component.set("v.viewCustomAttribute", results);
                    console.log("##############viewCustomAttribute"+JSON.stringify(component.get("v.viewCustomAttribute"))+'11111*************************'); 
                    //helper.helperMethod7(component,event,helper);
                    //helper.onViewOfRecord(component,event,helper);
                    
                } else if (response.getState() === "ERROR") {
                    component.set("v.error", "An error has occurred");
                    $A.util.removeClass(spinner,'slds-show');
                    $A.util.addClass(spinner,'slds-hide');
                    
                    var SaveRec  = component.find("saveRec");
                    $A.util.removeClass(SaveRec,'slds-show');
                    $A.util.addClass(SaveRec,'slds-hide');
                    
                    var EditRec  = component.find("editRec");
                    $A.util.removeClass(EditRec,'slds-hide');
                    $A.util.addClass(EditRec,'slds-show');
                    
                }
            });
            $A.enqueueAction(action);
        }
        // window.location.reload( );
    },
    editRecord:function(component,event,helper){
        var SaveRec  = component.find("saveRec");
        $A.util.removeClass(SaveRec,'slds-hide');
        $A.util.addClass(SaveRec,'slds-show');
    }
    
})