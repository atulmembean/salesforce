/**
* Batch Class       : UpdateAccountAtEndOfAcedemicYear
* Created by        : ETMarlabs (12-08-2016)
* Version           : 1.0
* Description       : Batch class will update the all the Account record which are expireda and also update the custom setting to next Acedemic year
*                   : Inline comments are added to get specific details.
**/
global class UpdateAccountAtEndOfAcedemicYear implements 
    Database.Batchable<sObject> {
        
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Subscription_Status__c,Academic_End_Month__c, BillingCountry,Batch_Academic_month__c, Subscription_Years__c FROM Account ' + 
            'Where Subscription_Status__c = \'Customer\' OR Subscription_Status__c = \'Pilot\' OR Subscription_Status__c = \'Expired\' OR Subscription_Status__c = \'Pilot Expired\''
        );//Constants.ACC_SUBSCRIPTION_STATUS_CUSTOMER
    }

    global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
system.debug('scope in execute'+scope);
        Set<Id> accIds = Utility.getRecordIds(scope);
        system.debug('Account id-->1'+accIds);
        List<Contract> linkedContracts = ContractService.getSubscriptionsByAccountIds(accIds);
        Map<Id, List<Contract>> accContractsMap = new Map<Id, List<Contract>>();
        if(linkedContracts != null) {
            for(Contract con : linkedContracts) {
                if(accContractsMap.containsKey(con.AccountId)) {
                    accContractsMap.get(con.AccountId).add(con);
                } else {
                    accContractsMap.put(con.AccountId, new List<Contract> {con});
                }
            }   
        }
        
        List<Opportunity> linkedOpportunities = OpportunityService.getOpportunitiesByAccountIds(accIds);
        Map<Id, List<Opportunity>> accOpportunitiesMap = new Map<Id, List<Opportunity>>();
        if(linkedOpportunities != null) {
            for(Opportunity opp : linkedOpportunities) {
                if(accOpportunitiesMap.containsKey(opp.AccountId)) {
                    accOpportunitiesMap.get(opp.AccountId).add(opp);
                } else {
                    accOpportunitiesMap.put(opp.AccountId, new List<Opportunity> {opp});
                }
            }   
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Account acc : scope) {
            system.debug('Scope-->1'+scope);
            Integer nextStartYear = CountrySettingsService.getCurrentAcademicStartYear(acc.BillingCountry) + 1;
            system.debug('nextStartYear'+nextStartYear);
            //system.debug('acc.Subscription_Status__c'+acc.Subscription_Status__c+'acc.Academic_End_Month__c'+acc.Academic_End_Month__c+'id'+acc.id);
            if(acc.Subscription_Status__c == Constants.ACC_SUBSCRIPTION_STATUS_CUSTOMER ) {
                Boolean isCustomer = false;
                system.debug('acc.Subscription_Status__c'+acc.Subscription_Status__c);
                if(accContractsMap.get(acc.Id)!=NULL){
                for(Contract con : accContractsMap.get(acc.Id)) {
                    if(con.Subscription_Start_Year__c != NULL && Integer.valueOf(con.Subscription_Start_Year__c) == nextStartYear) {
                        isCustomer = true;
                        break;
                    }
                }
               }
                system.debug('isCustomer'+isCustomer);
                if(!isCustomer) {
                    //acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_EXPIRED;
                    acc.Subscription_Status__c ='Expired';
                    system.debug('acc.Subscription_Status__c'+acc.Subscription_Status__c);
                    accountsToUpdate.add(acc);
                }   
            } else if(acc.Subscription_Status__c == Constants.ACC_SUBSCRIPTION_STATUS_PILOT) {
                Boolean isPilot = false;
                if(accOpportunitiesMap.get(acc.Id)!=NULL){
                for(Opportunity opp : accOpportunitiesMap.get(acc.Id)) {
                    if(opp.Subscription_Start_Year__c != NULL && Integer.valueOf(opp.Subscription_Start_Year__c) == nextStartYear) {
                        isPilot = true;
                        break;
                    }
                }
               }
                if(!isPilot) {
                    if(acc.Subscription_Years__c == null) {
                        //acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_PILOT_EXPIRED;
                        acc.Subscription_Status__c = 'Expired';   
                    } else {
                        //acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_EXPIRED;
                        acc.Subscription_Status__c ='Expired';
                    }
                    
                    accountsToUpdate.add(acc);
                }                
            } else if(acc.Subscription_Status__c == Constants.ACC_SUBSCRIPTION_STATUS_EXPIRED) {
                system.debug('When Expired'+acc.Subscription_Status__c);
                acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_DISCONTINUED;
                accountsToUpdate.add(acc);
            } /* else if(acc.Subscription_Status__c == Constants.ACC_SUBSCRIPTION_STATUS_PILOT_EXPIRED) {
                system.debug('entered next'+acc.Subscription_Status__c);
                acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_PILOT_DISCONTINUED;
                accountsToUpdate.add(acc);
            } */ /** Commented on 21-09-2017 . Pilot Expired no more exists in picklist value of Subscription Status **/
        }
        
        update accountsToUpdate;
    }    

    global void finish(Database.BatchableContext bc){
    /*
        Country_Settings__c myCS2 = Country_Settings__c.getInstance('US');
        Date startYearDate = myCS2.Academic_Year_Start_Date__c;
        Date endYearDate =  myCS2.Academic_Year_End_Date__c;
        myCS2.Academic_Year_Start_Date__c= startYearDate.addYears(1);
        myCS2.Academic_Year_End_Date__c = endYearDate.addYears(1);
        System.debug('myCS2.Academic_Year_Start_Date__c' +myCS2.Academic_Year_Start_Date__c);
        System.debug('myCS2.Academic_Year_End_Date__c' +myCS2.Academic_Year_End_Date__c);
        update myCS2;*/
    }    

}