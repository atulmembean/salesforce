/**
* Class Type     	: Service Class
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : All the Account specific SOQLs and Operations are written in this class.
* Modified Date		: 27/04/2018
* Modified By		: Pooja K
**/
public class AccountService {
    
    //Account RecordTypes Map by Id
    public static Map<Id, RecordType> accRecordTypesById {
        get {
            if(accRecordTypesById == null)
                accRecordTypesById = Utility.getRecordTypesByObject('Account');
            
            return accRecordTypesById;
        }
        private set;
    }
    
    //Account RecordTypes Map by Developer Name
    public static Map<String, RecordType> accRecordTypesByDevName {
        get {
            if(accRecordTypesByDevName == null) {
                accRecordTypesByDevName = new Map<String, RecordType>();
                if(accRecordTypesById != null) {
                    for(Id rId : accRecordTypesById.keySet()) {
                        if(accRecordTypesById.get(rId) != null) {
                         	accRecordTypesByDevName.put(accRecordTypesById.get(rId).DeveloperName, accRecordTypesById.get(rId));   
                        }
                    }
                }
            }
            
            return accRecordTypesByDevName;
        }
        private set;
    }
    
    //Static variable to stop Before Trigger recursion
    public static boolean runBeforeTrigger = true;
    public static boolean runBeforeOnce() {
        if(runBeforeTrigger) {
            runBeforeTrigger = false;
            return true;
        } else {
            return runBeforeTrigger;
        }
    }
    
    
    //Static variable to stop After Trigger recursion
    public static Integer runAfterTriggerCount = 1;
    public static boolean runAfterTrigger = true;
   /* public static boolean runAfterOnce() {
        if(runAfterTrigger) {
            runAfterTrigger = false;
            return true;
        } else {
            return runAfterTrigger;
        }
    } */
    //Allowing the account trigger to recursively fire once during the process to update the customer years at district.
      public static boolean runAfterOnce() {
        if(runAfterTrigger) {
            if(runAfterTriggerCount > 1)
                runAfterTrigger = false;
            runAfterTriggerCount++;
            return true;
        } else {
            return runAfterTrigger;
        }
    } 
    
    public static List<Account> getSchoolsByDistrictId(Id districtId) {
        if(districtId == null) {
            return null;
        }
        
        try {
            Id recordTypeId = accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id;
            return [Select Id, Name, RecordTypeId, BillingCountry, Subscription_Status__c, Subscription_Years__c, Pilot_Years__c from Account where District__c = :districtId And RecordTypeId = :recordTypeId  order by Name];
        } catch(Exception e) {
            return null;
        }
    }
    
    public static List<Account> getUnSelectedSchoolsByDistrictId(Id districtId, List<Id> accIds) {
        if(districtId == null) {
            return null;
        }
        
        try {
            Id recordTypeId = accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id;
            return [Select Id, Name, RecordTypeId, BillingCountry, Subscription_Status__c, Subscription_Years__c, Pilot_Years__c from Account where District__c = :districtId And Id Not In :accIds And RecordTypeId = :recordTypeId order by Name]; //Added order by on 18-04-2018
        } catch(Exception e) {
            return null;
        }
    }
    
    public static List<Account> getSchoolsByPrefix(String prefix) {
        try {
            prefix = prefix + '%';
            Id recordTypeId = accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id;
            return [Select Id, Name, RecordTypeId, BillingCountry, Subscription_Status__c, Subscription_Years__c, Pilot_Years__c from Account where Name Like :prefix And RecordTypeId = :recordTypeId  order by Name];
        } catch(Exception e) {
            return null;
        }
    }
    
    public static List<Account> getUnSelectedSchoolsByPrefix(String prefix, List<Id> accIds) {
        try {
            prefix = prefix + '%';
            Id recordTypeId = accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id;
            return [Select Id, Name, RecordTypeId, BillingCountry, Subscription_Status__c, Subscription_Years__c, Pilot_Years__c from Account where Name Like :prefix And Id Not In :accIds And RecordTypeId = :recordTypeId  order by Name];
        } catch(Exception e) {
            return null;
        }
    }
    
    public static List<Account> getSchoolsByIds(List<Id> accIds) {
        try {
            return [Select Id, Name, RecordTypeId, BillingCountry, Subscription_Status__c, Subscription_Years__c, Pilot_Years__c from Account where Id In :accIds order by Name];
        } catch(Exception e) {
            return null;
        }
    }
    
    public static Account getSchoolsById(Id accId) {
        try {
            return [Select Id, Name, RecordTypeId, BillingCountry, Subscription_Status__c, Subscription_Years__c, Pilot_Years__c from Account where Id = :accId  order by Name];
        } catch(Exception e) {
            return null;
        }
    }
}