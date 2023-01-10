/**
* Class Type        : VF Page Controller
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : Controller for VF Page GroupedOpportunityAddSchools. It takes care of Adding Removing Child Opps to Grouped Opps.
**/
global with sharing class GroupedOpportunityAddSchoolsController {
    
    public Id currentId {get; private set;}
    public static Opportunity OpportunityDetails;
    public GroupedOpportunityAddSchoolsController() {}
    
    public GroupedOpportunityAddSchoolsController(ApexPages.StandardController controller) {
        currentId = ApexPages.currentPage().getParameters().get('id');
        system.debug('currentId'+currentId);
    }
    
     //Method added for the lightning component AddRemoveSchools on Opportunity object to get the Opportunity details
    @AuraEnabled
    public static Opportunity sendOpportunityDetails(Id opportunityId){
        OpportunityDetails=[SELECT Id, AccountId,Account.RecordType.DeveloperName, No_of_Quotes__c,RecordTypeId, Name, StageName, Amount, CloseDate, NextStep, Type, OwnerId, CreatedDate, Teacher__c, Subscription_Start_Year__c, Subscription_End_Year__c FROM Opportunity where id=:opportunityId];
        system.debug('opp details'+OpportunityDetails);
        return OpportunityDetails;
    }
    
    @RemoteAction
    global static Opportunity getCurrentOpp(Id oppId) {
        if(oppId != null) 
            return OpportunityService.getOpportunityById(oppId);
        return null;
    }
    
    @RemoteAction
    global static String getSection(Id oppId) {
        Opportunity currentOpp = getCurrentOpp(oppId);
        if(currentOpp != null) {
            if(currentOpp.Account.RecordType.DeveloperName == Constants.RT_Account_District) {
                return Constants.RT_Account_District;
            } else if(currentOpp.Account.RecordType.DeveloperName == Constants.RT_Account_Agency) {
                return Constants.RT_Account_Agency;
            }
        }
        return null;
    }
    
    @RemoteAction
    global static Boolean getShowDistrictSection(Id oppId) {
        if(getSection(oppId) == Constants.RT_Account_District) {
            return true;
        }
        return false;
    }
    
    @RemoteAction
    global static Boolean getShowAgencySection(Id oppId) {
        if(getSection(oppId) == Constants.RT_Account_Agency) {
            return true;
        }
        return false;
    }

    @RemoteAction
    global static Id getDistrictId(Id oppId) {
        Opportunity currentOpp = getCurrentOpp(oppId);
        if(currentOpp != null)
            return currentOpp.Account.District__c;
        
        return null;
    }
    
    //Existinf child opps for the Parent Opp
    @RemoteAction
    global static List<Opportunity> getLinkedChildOpps(Id oppId) {
        if(oppId != null)
            return OpportunityService.getChildOpportunitiesByParentId(oppId);
        return null;
    }
    
    //Search schoolIds for schools already linked to Parent Opp
    @RemoteAction
    global static List<Id> getLinkedSchoolIds(Id oppId) {
        List<Id> temp = new List<Id>();
        for(Opportunity opp : OpportunityService.getChildOpportunitiesByParentId(oppId)) {
            temp.add(opp.AccountId);
        }
        return temp;
    }
    
    //Search schools already linked to Parent Opp
    @RemoteAction
    global static List<Account> getLinkedSchools(List<Id> linkedSchoolIds) {
        return AccountService.getSchoolsByIds(linkedSchoolIds);
    }
    
    //Search schools by DistrictId which are not already selected
    @RemoteAction
    global static List<Account> getNonLinkedSchoolsByDistrictId(Id districtId, Id oppId) {
        return AccountService.getUnSelectedSchoolsByDistrictId(districtId, getLinkedSchoolIds(oppId));
    }
    
    //Search schools by Prefix which are not already selected
    @RemoteAction
    global static List<Account> getNonLinkedSchoolsByPrefix(String prefix, List<Id> schIds) {
        return AccountService.getUnSelectedSchoolsByPrefix(prefix, schIds);
    }
    
    //Search schools by DistrictId
    @RemoteAction
    global static List<Account> searchSchoolsByPrefix(String prefix) {
        return AccountService.getSchoolsByPrefix(prefix);
    }
    
    //Search schools by DistrictId
    @RemoteAction
    global static List<Account> searchSchoolsByDistrictId(Id districtId) {
        return AccountService.getSchoolsByDistrictId(districtId);
    }
    
    //Create child opps for selected schools and delete for deselected schools
    @RemoteAction
    global static String save(Opportunity parentOpp, List<Account> schools) {
        List<Opportunity> deleteOpps = new List<Opportunity>();
        List<Opportunity> insertOpps = new List<Opportunity>();
        List<Split_School_Detail__c> deleteschoolDetails=new List<Split_School_Detail__c>();
        set<Id> oppidSet=new set<Id>();
        Map<Id, Account> selectedSchoolsMap = new Map<Id, Account>();
        for(Account acc: schools) {
            selectedSchoolsMap.put(acc.Id, acc);
        }
        //Fetching existing Child Opps for the Parent Opp
        List<Opportunity> existingChildOpps = OpportunityService.getChildOpportunitiesByParentId(parentOpp.Id);
          system.debug('existingChildOpps '+existingChildOpps );
        //If their are existing Child Opps for the Parent Opp
        if(!existingChildOpps.isEmpty() && existingChildOpps != null) {
            Map<Id, List<Opportunity>> accountOpportunityMap = new Map<Id, List<Opportunity>>();
            for(Opportunity opp : existingChildOpps) {
                if(accountOpportunityMap.containsKey(opp.AccountId))
                    accountOpportunityMap.get(opp.AccountId).add(opp);
                else
                    accountOpportunityMap.put(opp.AccountId, new List<Opportunity> {opp});
            }
            
            //Creating Opps for newly selected Schools
            for(Account acc : schools) {
                if(!accountOpportunityMap.containsKey(acc.Id)) {
                    insertOpps.addAll(getChildOpportunitiesToInsert(parentOpp, acc));
                    system.debug('insertOpps---'+insertOpps);
                }
            }
            
            //Deleting Opps for deselected Schools
            for(Id accId : accountOpportunityMap.keySet()) {
                if(!selectedSchoolsMap.containsKey(accId)) {
                    deleteOpps.addAll(accountOpportunityMap.get(accId));
                }
            }
            if(deleteOpps.size()>0){
                for(Opportunity oppsid:deleteOpps){
                    oppidSet.add(oppsid.id);
                }
                for(Split_School_Detail__c ssd:[select id,Opportunity_Name__c from Split_School_Detail__c where Opportunity_Name__c in:oppidSet ]){
                    deleteschoolDetails.add(ssd);
                }
            }
        } else {
            for(Account acc : schools) {
                insertOpps.addAll(getChildOpportunitiesToInsert(parentOpp, acc));
                system.debug('insertOpps'+insertOpps);
            }   
        }
        
        String message;
        try {
            insert insertOpps;
            delete deleteOpps;
            delete deleteschoolDetails;
            message = 'Success';
        } catch(Exception e) {
            message = e.getMessage();
            //message = 'Something went wrong. Please try again.';
        }
        
        return message;
    }
    
    private static List<Opportunity> getChildOpportunitiesToInsert(Opportunity parentOpp, Account acc) {
        List<Opportunity> childOpps;
        
        if(OpportunityService.isMultiyearOpp(parentOpp)) {
           // childOpps = OpportunityService.createChildOpportunitiesForMultiyear(parentOpp, acc);
           childOpps = new List<Opportunity>();
            Opportunity childOpp = OpportunityService.createChildOpportunity(parentOpp, acc);
            childOpp.Subscription_Start_Year__c = parentOpp.Subscription_Start_Year__c;
            childOpp.Subscription_End_Year__c = parentOpp.Subscription_End_Year__c;
            //childOpp.Parent_account__c=parentOpp.AccountId;
            childOpps.add(childOpp);
        } else {
            childOpps = new List<Opportunity>();
            Opportunity childOpp = OpportunityService.createChildOpportunity(parentOpp, acc);
            childOpp.Subscription_Start_Year__c = parentOpp.Subscription_Start_Year__c;
            childOpp.Subscription_End_Year__c = parentOpp.Subscription_End_Year__c;
            //childOpp.Parent_account__c=parentOpp.AccountId;
            childOpps.add(childOpp);
        }
        return childOpps;
    }
}