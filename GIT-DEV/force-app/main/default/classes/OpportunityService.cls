/**
* Class Type        : Service Class
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : All the Opportunity specific SOQLs and Operations are written in this class.
**/
public class OpportunityService {
    
    public static integer stopRecursion = 0;
    public static integer SubscriptionstopRecursion = 0;
    //Opportunity RecordTypes Map by Id
    public static Map<Id, RecordType> oppRecordTypesById {
        get {
            if(oppRecordTypesById == null)
                oppRecordTypesById = Utility.getRecordTypesByObject('Opportunity');
            
            return oppRecordTypesById;
        }
        private set;
    }
    
    //Opportunity RecordTypes Map by Developer Name
    public static Map<String, RecordType> oppRecordTypesByDevName {
        get {
            if(oppRecordTypesByDevName == null) {
                oppRecordTypesByDevName = new Map<String, RecordType>();
                if(oppRecordTypesById != null) {
                    for(Id rId : oppRecordTypesById.keySet()) {
                        if(oppRecordTypesById.get(rId) != null) {
                            oppRecordTypesByDevName.put(oppRecordTypesById.get(rId).DeveloperName, oppRecordTypesById.get(rId));   
                        }
                    }
                }
            }
            
            return oppRecordTypesByDevName;
        }
        private set;
    }
    
    //Static variable to stop Before Trigger recursion
    public static Integer runBeforeTriggerCount = 1;
    public static boolean runBeforeTrigger = true;
   /* public static boolean runBeforeOnce() {
        if(runBeforeTrigger) {
            runBeforeTrigger = false;
            return true;
        } else {
            return runBeforeTrigger;
        }
    } */
    //Added on 03-09-2018
    public static boolean runBeforeOnce() {
        if(runBeforeTrigger) {
            if(runBeforeTriggerCount > 1)
                runBeforeTrigger = false;
            runBeforeTriggerCount++;
            return true;
        } else {
            return runBeforeTrigger;
        }
    }
    //Static variable to stop After Trigger recursion
    public static Integer runAfterTriggerCount = 1;
    public static boolean runAfterTrigger = true;
    public static boolean runAfterOnce() {
        if(runAfterTrigger) {
            //if(runAfterTriggerCount > 2)
            if(runAfterTriggerCount > 1)
                runAfterTrigger = false;
            runAfterTriggerCount++;
            return true;
        } else {
            return runAfterTrigger;
        }
    }
    
    //Get Opportunity Record by RecordId
    public static Opportunity getOpportunityById(Id oppId) {
        try {
            return [Select Id, Name, RecordTypeId, RecordType.DeveloperName, AccountId, Account.RecordType.DeveloperName, 
                    Account.District__c, CloseDate, StageName, Subscription_Start_Year__c, Subscription_End_Year__c, Teacher__c, 
                    Estimate_Status__c,  Parent_Opportunity__c 
                    from Opportunity 
                    where Id = :oppId];   
        } catch(Exception e) {
            return null;
        }
    }
    
    //Get Opportunity Records by RecordIds
    public static List<Opportunity> getOpportunitiesByIds(Set<Id> oppIds) {
        try {
            return [Select Id, Name, RecordTypeId, RecordType.DeveloperName, AccountId, Account.RecordType.DeveloperName, 
                    Account.District__c, CloseDate, StageName, Subscription_Start_Year__c, Subscription_End_Year__c, Teacher__c, 
                    Estimate_Status__c,  Parent_Opportunity__c 
                    from Opportunity 
                    where Id In :oppIds];   
        } catch(Exception e) {
            return null;
        }
    }
    
    //Get Children Opportunities by for given Parent Opportunity Id
    public static List<Opportunity> getChildOpportunitiesByParentId(Id oppId) {
        try {
            return [Select Id, Name, RecordTypeId, RecordType.DeveloperName, AccountId, Account.RecordType.DeveloperName, 
                    Account.District__c, CloseDate, StageName, Subscription_Start_Year__c, Subscription_End_Year__c, Teacher__c, 
                    Estimate_Status__c, Parent_Opportunity__c 
                    from Opportunity 
                    where Parent_Opportunity__c = :oppId];  
        } catch(Exception e) {
            return null;
        }
    }
    
    //Get Map of key as Parent OppId and value as List of Children Opportunities. List of Parent Opportunities as Parameter
    public static Map<Id, List<Opportunity>> getChildOpportunitiesMapByParent(List<Opportunity> oppList) {
        Set<Id> oppIds = Utility.getRecordIds(oppList);
        List<Opportunity> childOpps;
        Map<Id, List<Opportunity>> parentChildOppsMap = new Map<Id, List<Opportunity>>();
        try {
            //Querying all Child Opps for list of Parent Opp Ids
            childOpps = [Select Id, Name, RecordTypeId, RecordType.DeveloperName, AccountId, Account.RecordType.DeveloperName, 
                         Account.District__c, CloseDate, StageName, Subscription_Start_Year__c, Subscription_End_Year__c, Teacher__c, 
                         Estimate_Status__c, Parent_Opportunity__c 
                         from Opportunity 
                         where Parent_Opportunity__c In :oppIds];  
            
            //Creating map of Parent Opp Id -> List of Child Opps
            for(Opportunity opp : childOpps) {
                if(parentChildOppsMap.containsKey(opp.Parent_Opportunity__c)) {
                    parentChildOppsMap.get(opp.Parent_Opportunity__c).add(opp);
                } else {
                    parentChildOppsMap.put(opp.Parent_Opportunity__c, new List<Opportunity>{opp});
                }
            }
            return parentChildOppsMap;
        } catch(Exception e) {
            return null;
        }
    }
    
    //Get Map of key as Parent OppId and value as List of Accounts linked to Children Opportunities. List of Parent Opportunities as Parameter
    public static Map<Id, Set<Account>> getChildOpportunitiesSchoolsMapByParent(List<Opportunity> oppList) {
        Map<Id, Set<Account>> parentChildOppsSchoolsMap = new Map<Id, Set<Account>>();
        
        //Getting map of Parent Opp Id -> List of Child Opps
        Map<Id, List<Opportunity>> parentChildOppsMap = getChildOpportunitiesMapByParent(oppList);        
        
        //List of AccIds linked to Children Opps for given list of Parent Opps
        List<Id> accIds = new List<Id>();
        for(List<Opportunity> opps : parentChildOppsMap.values()) {
            for(Opportunity opp : opps) {
                accIds.add(opp.AccountId);
            }
        }
        
        //Map of Aoount Id->Record
        Map<Id, Account> accMap = new Map<Id, Account>(AccountService.getSchoolsByIds(accIds));
        
        //Creating map of Parent Opp Id -> List of Accounts linked to Child Opps
        for(Id oppId : parentChildOppsMap.keySet()) {
            for(Opportunity cOpp : parentChildOppsMap.get(oppId)) {
                if(parentChildOppsSchoolsMap.containsKey(oppId)) {
                    parentChildOppsSchoolsMap.get(oppId).add(accMap.get(cOpp.AccountId));
                } else {
                    parentChildOppsSchoolsMap.put(oppId, new Set<Account>{accMap.get(cOpp.AccountId)});   
                }
            }
        }
        
        return parentChildOppsSchoolsMap;
    }
    
    //Create Child opp for given Parent opp and Account    
    public static Opportunity createChildOpportunity(Opportunity parentOpp, Account school) {
        String schoolName = '';
        //Querying Account if not NULL received as Parameter
        if(school == NULL) {
            school = AccountService.getSchoolsById(parentOpp.AccountId);
        } 
        
        if(school != NULL) {
            schoolName = ' - ' + school.Name;
        }
        
        //Copying Parent Opp data to Child Opp
        Opportunity childOpp = new Opportunity();
        childOpp.Parent_Opportunity__c = parentOpp.Id;
        childOpp.AccountId = school.Id;
        childOpp.Name = parentOpp.Name + schoolName;
        childOpp.RecordTypeId = oppRecordTypesByDevName.get(Constants.RT_Opportunity_Child).Id;
        childOpp = copyParentOppDataToChild(parentOpp, childOpp);
        
        return childOpp;
    }
    
    //Creating Child Opps for all the academic years for a given Parent Opp
    public static List<Opportunity> createChildOpportunitiesForMultiyear(Opportunity parentOpp, Account school) {
        
        List<Opportunity> newChildOpps = new List<Opportunity>();
        
        //Querying Account if not NULL received as Parameter
        try{
            if(school == null) school = AccountService.getSchoolsById(parentOpp.AccountId);   
        } catch(Exception e) {
            return null;
        }
        
        //Initializing startYear
        Integer startYear;
        if(parentOpp.Subscription_Start_Year__c == NULL) {
            return null;   
        } else {
            startYear = Integer.valueOf(parentOpp.Subscription_Start_Year__c);   
        }
        
        //Initializing endYear
        Integer endYear;
        if(parentOpp.Subscription_End_Year__c == NULL) {
            return null;   
        } else {
            endYear = Integer.valueOf(parentOpp.Subscription_End_Year__c);   
        }            
        
        //Determining Start year and End year for Child Opps
        for(Integer i=endYear; i-startYear!=0; i--) {
            Opportunity childOpp = OpportunityService.createChildOpportunity(parentOpp, school);
            childOpp.Subscription_Start_Year__c = String.valueOf(i-1);
            childOpp.Subscription_End_Year__c = String.valueOf(i);
            childOpp.Name = childOpp.Name +' - '+ String.valueOf(i-1) + '-'+String.valueOf(i).substring(2);
            newChildOpps.add(childOpp);
        }
        
        return newChildOpps;
    }
    
    //Determining if the Opportunity is Multiyear or not
    public static Boolean isMultiyearOpp(Opportunity opp) {
        Integer startYear = opp.Subscription_Start_Year__c != NULL ? Integer.valueOf(opp.Subscription_Start_Year__c) : 0;
        Integer endYear = opp.Subscription_End_Year__c != NULL ? Integer.valueOf(opp.Subscription_End_Year__c) : 0;
        
        if(endYear - startYear > 1) {
            return true;
        } else {
            return false;
        }
    }
    
    //Determining if the Opportunity is Grouped or not
    public static Boolean isGroupedOpp(Opportunity opp, Account acc) {
        if(acc != NULL && (acc.RecordTypeId == AccountService.accRecordTypesByDevName.get(Constants.RT_Account_Agency).Id || 
           acc.RecordTypeId == AccountService.accRecordTypesByDevName.get(Constants.RT_Account_District).Id)) {
               return true;   
           } else {
               return false;
           }
    }
    
    //Copying Parent Opp data to Child Opp
    public static Opportunity copyParentOppDataToChild(Opportunity parentOpp, Opportunity childOpp) {
        childOpp.Teacher__c = parentOpp.Teacher__c;
        childOpp.Estimate_Status__c = parentOpp.Estimate_Status__c;        
        childOpp.CloseDate = parentOpp.CloseDate;
        childOpp.StageName = parentOpp.StageName;
        return childOpp;
    }
    
    public static List<Opportunity> getOpportunitiesByAccountIds(Set<Id> accIds) {
        return null;
    }
}