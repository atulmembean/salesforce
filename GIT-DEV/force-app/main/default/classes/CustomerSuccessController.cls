/**
* Class Type        : Apex Class
* Created Date		: 17/10/2017
* Created by        : Pooja K
* Modified Date		: 01/02/2017
* Version           : 41
* Description       : Class contains the logic to create the new customer success records under a opportunity.
**/
public class CustomerSuccessController {
  
	@AuraEnabled//Annotation to use method in lightning component
    public static List<Opportunity> getOpportunityList() {//Fetch data
        Boolean flag =true;
        return [SELECT Id,Name,AccountId,No_of_Students__c,Parent_Opportunity__c,RPT_Membean_Student_Count__c,StageName,
                Start_Pilot__c,Subscription_Start_Year__c,Subscription_End_Year__c,Total_Users__c,Teacher__c FROM Opportunity LIMIT 5];
    }
    @AuraEnabled //Get details from Id
    public static Opportunity getAllFieldValue(Id oppId){
        try{
            Boolean flag =true;
            String sobjectType = oppId.getSObjectType().getDescribe().getName();
           // system.debug('sobjectType is -->11'+sobjectType);
            //system.debug('its opp id-->1'+oppId);
            
            if(sobjectType == 'Opportunity'){
                
            return [SELECT Id,Name,AccountId,Account.Name,No_of_Students__c,Account.No_of_Students__c,Parent_Opportunity__c,RPT_Membean_Student_Count__c,StageName,
                    account.Membean_Student_Count__c,Start_Pilot__c,Subscription_Start_Year__c,Subscription_End_Year__c,
                    Total_Users__c,Teacher__c,account.Population__c,account.Membean_URL__c,Account.Grade_5__c,Account.Grade_6__c,
                    Account.Grade_7__c,Account.Grade_8__c,Account.Grade_9__c,Account.Grade_10__c,Account.Grade_11__c,
                    Account.Grade_12__c  FROM Opportunity where id=:oppId];
            }else{
                
                Customer_Success__c cust = new Customer_Success__c(); 
                cust = [Select id,Opportunity__c ,Account__c from Customer_Success__c where id=:oppId];
                Id OpportunityId = cust.Opportunity__c;
                Opportunity opList=new opportunity();
                opList=[SELECT Id,Name,AccountId,No_of_Students__c,Account.No_of_Students__c,Parent_Opportunity__c,RPT_Membean_Student_Count__c,StageName,
                        account.Membean_Student_Count__c,Start_Pilot__c,Subscription_Start_Year__c,Subscription_End_Year__c,
                        Total_Users__c,Teacher__c,account.Population__c,account.Membean_URL__c,Account.Grade_5__c,Account.Grade_6__c,
                        Account.Grade_7__c,Account.Grade_8__c,Account.Grade_9__c,Account.Grade_10__c,Account.Grade_11__c,
                        Account.Grade_12__c   FROM Opportunity where id=:OpportunityId];
                return opList;
            }
        }catch(Exception e){
           
            system.debug('exception' +e);
            system.debug('exceptionMess'+e.getMessage());
            system.debug('exceptionsLine'+e.getLineNumber());
        	return null;
        }
    }
    @AuraEnabled //Get details from Id
    public static List<Opportunity> getAllOpportunityFromAccount(Id oppId){
        system.debug('its opp id-->2'+oppId);
        Boolean flag =true;
        return [SELECT Id,Name,AccountId,No_of_Students__c,Account.No_of_Students__c,Parent_Opportunity__c,RPT_Membean_Student_Count__c,StageName,
                account.Membean_Student_Count__c,Start_Pilot__c,Subscription_Start_Year__c,Subscription_End_Year__c,
                Total_Users__c,Teacher__c,account.Population__c,account.Membean_URL__c,Account.Grade_5__c,Account.Grade_6__c,
                Account.Grade_7__c,Account.Grade_8__c,Account.Grade_9__c,Account.Grade_10__c,Account.Grade_11__c,
                Account.Grade_12__c   FROM Opportunity where id=:oppId];
    }
   @AuraEnabled //Get details from Id
    public static List<Opportunity> getAllRelatedOpportunityFromAccount(Id oppId){
        try{
        Boolean flag =true;
        system.debug('its opp id-->3'+oppId);
        Opportunity opp = new opportunity(); 
        opp = [SELECT Id,Name,AccountId,No_of_Students__c,Account.No_of_Students__c,Parent_Opportunity__c,RPT_Membean_Student_Count__c,StageName,
               account.Membean_Student_Count__c,Start_Pilot__c,Subscription_Start_Year__c,Subscription_End_Year__c,
               Total_Users__c,Teacher__c,account.Population__c,account.Membean_URL__c,Account.Grade_5__c,Account.Grade_6__c,Account.Grade_7__c,
               Account.Grade_8__c,Account.Grade_9__c,Account.Grade_10__c,Account.Grade_11__c,Account.Grade_12__c FROM Opportunity where id=:oppId];
        Id AccId = opp.AccountId;
        list<Opportunity> listOfOpp = new list<Opportunity>();
        listOfOpp = [select id, accountid,Subscription_Start_Year__c,Subscription_End_Year__c,Total_Users__c from opportunity where AccountId =: AccId]; 
        return listOfOpp;
    	}catch(Exception e){
            system.debug('exception' +e);
            system.debug('exceptionMess'+e.getMessage());
            system.debug('exceptionsLine'+e.getLineNumber());
            return null;
        }
    }
    
     @AuraEnabled //Get details from Id
    public static List<Contract> getAllRelatedSubscriptionsFromAccount(Id oppId){
        try{
        Boolean flag =true;
        String sobjectType = oppId.getSObjectType().getDescribe().getName();
        system.debug('sobjectType is -->11'+sobjectType);
        system.debug('its opp id-->4'+oppId);
            if(sobjectType=='Opportunity'){
                Opportunity opp = new opportunity(); 
                opp = [SELECT Id,Name,AccountId,No_of_Students__c,Account.No_of_Students__c,Parent_Opportunity__c,RPT_Membean_Student_Count__c,StageName,
                       account.Membean_Student_Count__c,Start_Pilot__c,Subscription_Start_Year__c,Subscription_End_Year__c,
                       Total_Users__c,Teacher__c,account.Population__c,Account.Grade_5__c,Account.Grade_6__c,Account.Grade_7__c,
                       Account.Grade_8__c,Account.Grade_9__c,Account.Grade_10__c,Account.Grade_11__c,
                       Account.Grade_12__c   FROM Opportunity where id=:oppId];
                Id AccId = opp.AccountId;
                list<Contract> listOfSubs = new list<Contract>();
                listOfSubs = [select id,name,ContractNumber, No_of_Students__c,No_of_Teachers__c,Subscription_Start_Year__c,Subscription_End_Year__c from Contract where AccountId =: AccId order by createdDate Desc]; 
                system.debug('list of subsriptions'+listOfSubs);
                return listOfSubs;
            }else{
                 Customer_Success__c cust = new Customer_Success__c(); 
                 cust = [Select id,Opportunity__c ,Account__c from Customer_Success__c where id=:oppId];
                 Id OpportunityId = cust.Opportunity__c;
                Opportunity opList=new opportunity();
                opList=[SELECT Id,Name,AccountId,No_of_Students__c,Account.No_of_Students__c,Parent_Opportunity__c,RPT_Membean_Student_Count__c,StageName,
                       account.Membean_Student_Count__c,Start_Pilot__c,Subscription_Start_Year__c,Subscription_End_Year__c,
                       Total_Users__c,Teacher__c,account.Population__c,Account.Grade_5__c,Account.Grade_6__c,Account.Grade_7__c,
                       Account.Grade_8__c,Account.Grade_9__c,Account.Grade_10__c,Account.Grade_11__c,Account.Grade_12__c
                       FROM Opportunity where id=:OpportunityId];
                Id AccountId = opList.AccountId;
                list<Contract> listOfSubs2 = new list<Contract>();
                listOfSubs2 = [select id,name,ContractNumber, No_of_Students__c,No_of_Teachers__c,Subscription_Start_Year__c,Subscription_End_Year__c from Contract where AccountId =: AccountId order by createdDate Desc]; 
                system.debug('list of subsriptions'+listOfSubs2);
                return listOfSubs2;
            }
        }catch(Exception e){
            system.debug('exception' +e);
            system.debug('exceptionMess'+e.getMessage());
            system.debug('exceptionsLine'+e.getLineNumber());
            return null;
        }
    }
    
    
     @AuraEnabled //For getting the picklist values from object
 public static List < String > getselectOptions(sObject objObject, string fld) {
  Boolean flag=false;
  system.debug('objObject --->' + objObject);
  system.debug('fld --->' + fld);
  List < String > allOpts = new list < String > ();
  // Get the object type of the SObject.
  Schema.sObjectType objType = objObject.getSObjectType();
 
  // Describe the SObject using its object type.
  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
 
  // Get a map of fields for the SObject
  map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
 
  // Get the list of picklist values for this field.
  list < Schema.PicklistEntry > values =
   fieldMap.get(fld).getDescribe().getPickListValues();
 
  // Add these values to the selectoption list.
  for (Schema.PicklistEntry a: values) {
   allOpts.add(a.getValue());
  }
  system.debug('allOpts ---->' + allOpts);
  //allOpts.sort();
  return allOpts;
 }
    @AuraEnabled //Save the customer success record
    public static Customer_Success__c
        saveCustomerSuccesssRecord(String customerSuccessString, string ContactId,Boolean IsMultiSelectChange){
        //Customer Success Name , Account Name, Usage Related Discussion, Growth Related Discussion, Comments, Status, Opportunity Name,User Rating,Call Feedback,Training,New Feature Exploration
        // system.debug('@@@@@@ContactId'+ContactId);
     try{
         Boolean flag = true;
         
         system.debug('entered in@@@@@@'+customerSuccessString);
         Customer_Success__c cus = new Customer_Success__c();
         Map<String,String> cas =  (Map<String,String>)System.JSON.deserialize(customerSuccessString,Map<String,String>.class);
         system.debug('cas-->########'+cas.get('RiskReasonSelected'));
         
         /********* Pooja Added here *************/
         String s1='';
         if(cas.get('RiskReasonSelected') != null && cas.get('RiskReasonSelected') !='' && cas.get('RiskReasonSelected') != 'undefined') {
             system.debug('entered the if ###');
             if(IsMultiSelectChange){
             List <String> myList=(List<String>)System.JSON.deserialize( cas.get('RiskReasonSelected'), List<String>.class);
              
             if(!myList.isEmpty()) {
                 for(String item:myList){
                     if(s1 != ''){
                         s1 = s1 + ';' + item;
                     }else{
                         s1= item;
                     }
                 }
             }
              system.debug(myList);
             }else{
                 s1=cas.get('RiskReasonSelected');
             }
         }
         system.debug('Its mylist ********');
        
         
         system.debug('Its s1 here new****'+s1);
 
         /*********Ends Here ***************/
         cus.Name=cas.get('CustomerSuccessName');
         cus.Account__c=cas.get('accId');
         cus.Risk_Reason__c=s1;
         cus.Usage_Related_Discussion__c= cas.get('UsageRelatedDiscussion');
         cus.Growth_Related_Discussion__c= cas.get('GrowthRelatedDiscussion');
         cus.Comments__c = cas.get('Comments');
         cus.Status__c=cas.get('Status');
         cus.Opportunity__c= cas.get('oppId');
         cus.User_Rating__c=cas.get('UserRating');
         cus.Call_Feedback__c = cas.get('CallFeedback');
         cus.Training__c=Boolean.valueOf(cas.get('Training'));
         if(cas.get('DueDate') != null && !string.ISBLANK(cas.get('DueDate'))){
             Integer mon = date.valueof(cas.get('DueDate')).month();
             Integer day = date.valueof(cas.get('DueDate')).day();
             Integer year = date.valueof(cas.get('DueDate')).year();
             date cusdueDate = date.newInstance(year, mon, day);
             system.debug('date is'+mon +'' +day +' ' +year);
             cus.Due_Date__c=cusdueDate;
         }
         cus.New_Feature_Exploration__c = Boolean.valueOf(cas.get('NewFeatureExploration'));
         cus.New_Feature__c=cas.get('NewFeature');
         cus.Testing__c=cas.get('Testing');
         cus.Grading__c=cas.get('Grading');
         cus.Activities__c=cas.get('Activities');
         cus.Other_Proponents__c=cas.get('OtherProponents');
         cus.Concerns_and_Issues__c=cas.get('issuesandConcerns');
         cus.Call_Preps__c=cas.get('CallPreps');
         cus.Agents__c=cas.get('Agent');
         cus.Mode__c=cas.get('Mode');
         cus.Risk_Factor__c=cas.get('RiskFactor'); 
         cus.Direction__c=cas.get('Direction');
         cus.Source__c=cas.get('Source');
         if(ContactId != null && ContactId != 'undefined'){
         	cus.Contact__c = ContactId;
         }
         system.debug('%%this is the contact for the customer success'+cus.Contact__c);
         system.debug('its customer success' +cus);
         system.debug('cas.get in update before'+cas.get('CusId'));
         if((cas.get('CusId') != null) && (!string.ISBLANK(cas.get('CusId')))) {
             system.debug('cas.get in update'+cas.get('CusId'));
             cus.Id=cas.get('CusId');
             update cus;
             system.debug('customer object record on update'+cus);
             return cus;
         }else{
             system.debug('cas.get in insert'+cas.get('CusId'));
         	 insert cus;
             system.debug(cus.Id);
            // cas.get('CusId')=cus.Id;
             system.debug('customer object record on insert'+cus);
             return cus;
         }
         
      }catch(Exception e){
          system.debug('Exception' +e);
          system.debug('Exception message'+e.getMessage());
          system.debug('Exception line'+e.getLineNumber());
          return null;
      }
            
    } 
   
    @AuraEnabled // Fetch the customer success record from salesforce database
    public static Customer_Success__c getAllCustomerSuccessRecord(Id customerSuccessRecord){
        try{
            Boolean flag = true;
            system.debug('Entered Customer success'+customerSuccessRecord);
            return [select id,Name,Account__c,Account__r.Name, Usage_Related_Discussion__c,Growth_Related_Discussion__c,Comments__c,Status__c,Opportunity__c,Opportunity__r.Name,User_Rating__c,
              Call_Feedback__c,Training__c,New_Feature_Exploration__c,District_Account__c,Membean_Url__c,Due_Date__c,Grading__c,Other_Proponents__c,Testing__c,Activities__c,New_Feature__c,
              Concerns_and_Issues__c,Call_Preps__c,Contact__c,Contact__r.Name,Agents__c,Mode__c,Risk_Factor__c,Risk_Reason__c,Direction__c,Source__c from Customer_Success__c where Id=:customerSuccessRecord];
        }catch(Exception e){
          system.debug('Exception' +e);
          system.debug('Exception message'+e.getMessage());
          system.debug('Exception line'+e.getLineNumber());
          
      }
      return null;  
    } 
}