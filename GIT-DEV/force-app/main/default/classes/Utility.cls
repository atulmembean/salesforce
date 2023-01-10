/**
* Class Type        : Utility Class
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : To provide operations that can be used frequently across different classes.
**/
public class Utility {
    
    Public static final string CITY_STATE_OBJ       = 'City_State_Mapping__c';
    Public static final string LEAD_OBJ             = 'Lead';
    Public static final string ACCOUNT_OBJ          = 'Account';
    Public static final string INVOICE_OBJ      = 'Invoice__c';
    
    Public static final string STATE_FIELD          = 'State__c';
    Public static final string STATE_CODE_FIELD     = 'State_Code__c';
    Public static final string ROLE_FIELD           = 'Role__c';
    Public static final string NEXTSTEP_FIELD       = 'Next_Step__c';
    Public static final string PAYMENT_TERMS    = 'Payment_Terms__c';
    
    Public static final string PRIVATE_SCHOOL       = 'Private School';
    Public static final string PUBLIC_SCHOOL        = 'Public School';
    
    Public static final string TEACHER_REG_TEMPLATE_NAME    = System.Label.Template_Name_used_for_Teacher_Registration_Email;
    
    //Fetching Record Type for given Object and Developer Name
    public static Id getRecordTypeId(String objectName, String developerName) {
        try {
            return [Select Id, DeveloperName from RecordType where SobjectType = :objectName And DeveloperName = :developerName Limit 1].Id;   
        } catch(Exception e) {
            return null;
        }
    }
    
    public static Map<Id, RecordType> getRecordTypesByObject(String objectName) {
        try {
            return new Map<Id, RecordType>([Select Id, DeveloperName from RecordType where SobjectType = :objectName]);   
        } catch(Exception e) {
            return null;
        }
    }
    
    //Getting Set of RecordIds for list of records
    public static Set<Id> getRecordIds(List<SObject> objRecords) {
        Set<Id> objIds = new Set<Id>();
        for(SObject obj : objRecords) {
            objIds.add(obj.Id);
        }
        return objIds;
    }
    
    //Getting all State List
    public static List<String> getStateList() {       
        return getPicklistValues(CITY_STATE_OBJ,STATE_FIELD);
    }
    
    //Getting State Code for a State
    public static String getStateCode(string state) {
        List<City_State_Mapping__c> stateList   = new List<City_State_Mapping__c>();
        try{
            stateList   = [Select State_Code__c from City_State_Mapping__c where State__c=:state AND State_Code__c != '' limit 1];
            return stateList[0].State_Code__c;
        }catch(Exception ex){
            return null;
        }        
    }
    
    //Getting List of all City for a State
    public static List<AggregateResult> getStateCityList(string state) {
      return [select City__c from City_State_Mapping__c where State__c=:state AND State_Code__c != '' group By City__c];         
    }
    
    //Getting List of all City for a State
    public static List<Account> getSchoolList(string state, String city) {    
        
        try{
            string sCode    = getStateCode(state);
            if(sCode != null){
                return [Select id,Name from Account where BillingCity=:city AND BillingStateCode =:sCode 
                        AND (RecordTypeId=:Utility.getObjectRecordTypeId(Utility.ACCOUNT_OBJ,Utility.PRIVATE_SCHOOL) 
                            OR RecordTypeId=:Utility.getObjectRecordTypeId(Utility.ACCOUNT_OBJ,Utility.PUBLIC_SCHOOL))];  
            }else{
                return new List<Account>();
            }            
        }catch(Exception ex){
            return new List<Account>();
        }
        
    }
    
     /*
    * @Purpose: Get Picklist field values of any object  
    * @Param : @ObjectApi_name is sObject API Name and @Field_name is the field API Name for 
    *   which picklist values needed
    * @returnType: List<String>
    */
    public static List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 
        
        List<String> lstPickvals                        = new List<String>();
        Schema.SObjectType targetType                   = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name                             = targetType.newSObject();
        Schema.sObjectType sobject_type                 = Object_name.getSObjectType(); 
        Schema.DescribeSObjectResult sobject_describe   = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map      = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values     = field_map.get(Field_name).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a : pick_list_values) {
            lstPickvals.add(a.getValue());
        }
        
        return lstPickvals;
    }
    
    /*
    * @Purpose: Get Object reocrd type Id dynamically by passing object name and recordType Name
    * @Param : @objectType is sObject Name and @recordTypeName is the recordType Name
    * @returnType: string
    */
    public static string getObjectRecordTypeId(String objectType, String recordTypeName){
        return Schema.getGlobalDescribe().get(objectType).getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
    }
    
    /*
    * @Purpose: Send Email Notification
    * @Param : @recordId is Who Id (Like Lead or Contact) & @templateId
    * @returnType: nothing
    */
    @future
    public static void SendEmailNotification(string recordId, string templateId){
        try{
            List<Lead> newLeads =[select id,ownerId,owner.email from Lead where id=:recordId];
            OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(recordId);
            mail.setTemplateId(templateId);
            if(newLeads.size() > 0){
                mail.setReplyTo(newLeads[0].owner.email);    
            }
            //mail.setSaveAsActivity(false);
            //mail.setSenderDisplayName(owa.DisplayName);
            mail.setOrgWideEmailAddressId(owa.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){}
    }
    
    /*
    * @Purpose: Check Lead already present in system or not by email 
    * @Param : @leadEmail
    * @returnType: List<Lead>
    */
    public static List<Lead> checkExistingLead(string leadEmail){
        return [Select id,Email,LastName,Hear_About_Us__c from Lead where Email=:leadEmail LIMIT 1];
         
    }
    
    /*
    * @Purpose: Get Email Template Id by Passing Name
    * @Param : @TemplateName
    * @returnType: List<EmailTemplate>
    */
    public static List<EmailTemplate> getEmailTemplateName(string TemplateName){
        return [SELECT id FROM EmailTemplate WHERE developerName =: TemplateName LIMIT 1];
    }
    
    /*
    * @Purpose: Run activ lead assignment rule
    * @Param : @leadList
    * @returnType: List<Lead>
    */
     public static void runLeadAssignmentRule(List<Lead> leadList){
        try{    
                 
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            Database.update(leadList, dmo);
        }catch(Exception e){
            system.debug('Exception ::'+e.getMessage());
        }
    }
}