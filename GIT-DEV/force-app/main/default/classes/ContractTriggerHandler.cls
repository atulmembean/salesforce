/**
* Class Type        : Trigger Handler
* Created by        : Swayam Arora
* Version           : 37.0
* Modified By		: Pooja K
* Modified Date 	: 30-08-2018
* Description       : Class contains all the Business logic for ContractTrigger trigger.
**/
public class ContractTriggerHandler {
    public static void updateSchoolDetails(List<Contract> newContracts, Map<Id, Contract> oldContractsMap) {
        
        Map<Id, Id> conAccIdMap = new Map<Id, Id>();
        Map<Id, Account> linkedAccountsMap;
        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Account> accountsToUpdateMap = new Map<Id, Account>();
        
        for(Contract newCon : newContracts) {
            Boolean isInsertCon = oldContractsMap == NULL || !oldContractsMap.containsKey(newCon.Id);
            Boolean isUpdateCon = oldContractsMap != NULL && oldContractsMap.containsKey(newCon.Id);
            Boolean changeInNoOfStudents = isUpdateCon && newCon.No_Of_Students__c != oldContractsMap.get(newCon.Id).No_Of_Students__c;
            Boolean changeInNoOfTeachers = isUpdateCon && newCon.No_Of_Teachers__c != oldContractsMap.get(newCon.Id).No_Of_Teachers__c;
            Boolean changeInAmount = isUpdateCon && newCon.Amount__c != oldContractsMap.get(newCon.Id).Amount__c;
            //Boolean isAcademicYear = Integer.valueOf(newCon.Subscription_Start_Year__c) == CountrySettingsService.getCurrentAcademicStartYear(acc.BillingCountry);
            system.debug('updateSubscriptionYears');
            if(isInsertCon || (isUpdateCon && changeInNoOfStudents || changeInNoOfTeachers || changeInAmount)) {
                conAccIdMap.put(newCon.Id, newCon.AccountId);
            }
        }
        
        linkedAccountsMap = new Map<Id, Account>(AccountService.getSchoolsByIds(conAccIdMap.values()));
        
        for(Contract newCon : newContracts) {
            if(conAccIdMap.containsKey(newCon.Id)) {
                Account acc = linkedAccountsMap.get(newCon.AccountId);
                Boolean isAcademicYear = Integer.valueOf(newCon.Subscription_Start_Year__c) == CountrySettingsService.getCurrentAcademicStartYear(acc.BillingCountry);
                
                if(isAcademicYear) {
                    acc.No_of_Students__c = newCon.No_of_Students__c;
                    acc.No_of_Teachers__c = newCon.No_of_Teachers__c;
                    acc.AnnualRevenue = newCon.Amount__c;
                    acc.AnnualRevenue__c = newCon.Single_Year_Amount__c; /*Amount__c/No of subscription years*/
                    accountsToUpdate.add(acc);
                    accountsToUpdateMap.put(acc.Id, acc);
                }
                 List<String> dates1=new List<String>();
                        for(Integer k= Integer.valueOf(newCon.Subscription_End_Year__c); k-Integer.valueOf(newCon.Subscription_Start_Year__c)!=0;k--){
                            dates1.add(String.valueOf(k-1));
                        }
                for(integer j=0;j<dates1.size();j++){
                    if(acc.Subscription_Years__c!=null&&!acc.Subscription_Years__c.contains(dates1[j])){
                        acc.Subscription_Years__c +=';'+ dates1[j];
                    }
                } 
                 accountsToUpdateMap.put(acc.Id, acc);
                if(acc.Subscription_Years__c == null) {
                     if((Integer.valueOf(newCon.Subscription_End_Year__c)-Integer.valueOf(newCon.Subscription_Start_Year__c))>1){
                                List<String> dates=new List<String>();
                        for(Integer k= Integer.valueOf(newCon.Subscription_End_Year__c); k-Integer.valueOf(newCon.Subscription_Start_Year__c)!=0;k--){
                            dates.add(String.valueOf(k-1));
                        }
                         for(Integer i=0;i<dates.size();i++){
                             if(acc.Subscription_Years__c != null)acc.Subscription_Years__c+=dates[i]+';';
                            if(acc.Subscription_Years__c == null)acc.Subscription_Years__c=dates[i]+';';
                               system.debug('acc.Subscription_Years__c--1'+acc.Subscription_Years__c);
                         }
                     } else{
                      acc.Subscription_Years__c = newCon.Subscription_Start_Year__c;
                     }
                    system.debug('acc.Subscription_Years__c'+acc.Subscription_Years__c);
                    accountsToUpdateMap.put(acc.Id, acc);
                } else if(!acc.Subscription_Years__c.contains(newCon.Subscription_Start_Year__c)){
                    if((Integer.valueOf(newCon.Subscription_End_Year__c)-Integer.valueOf(newCon.Subscription_Start_Year__c))>1){
                        List<String> dates=new List<String>();
                        for(Integer k= Integer.valueOf(newCon.Subscription_End_Year__c); k-Integer.valueOf(newCon.Subscription_Start_Year__c)!=0;k--){
                            dates.add(String.valueOf(k-1));
                        }
                        system.debug(dates);
                        for(Integer i=0;i<dates.size();i++)
                            acc.Subscription_Years__c+=dates[i]+';';
                               system.debug('acc.Subscription_Years__c--1'+acc.Subscription_Years__c);
                    }else{
                        acc.Subscription_Years__c += ';' + newCon.Subscription_Start_Year__c;
                         system.debug('acc.Subscription_Years__c--2'+acc.Subscription_Years__c);
                      }
                      system.debug('acc.Subscription_Years__c'+acc.Subscription_Years__c);
                    accountsToUpdateMap.put(acc.Id, acc);
                }
            }
        }
        
        try {
            update accountsToUpdateMap.values();
        } catch(Exception e) { }
    }
    
   
    public static void updateSubscriptionYears(Map<Id, Contract> oldContractsMap) {
        Map<Id, Id> conAccIdMap = new Map<Id, Id>();
        Map<Id, Account> linkedAccountsMap;
        List<Account> accountsToUpdate = new List<Account>();
        
        for(Contract oldCon : oldContractsMap.values()) {
            conAccIdMap.put(oldCon.Id, oldCon.AccountId);
        }
        
        linkedAccountsMap = new Map<Id, Account>(AccountService.getSchoolsByIds(conAccIdMap.values()));
        
        for(Contract oldCon : oldContractsMap.values()) {
            if(conAccIdMap.containsKey(oldCon.Id)) {
                Account acc = linkedAccountsMap.get(oldCon.AccountId);
                System.debug('acc.Subscription_Years__c'+acc.Subscription_Years__c);
                if(acc.Subscription_Years__c != null) {
                    Set<String> testlist=new Set<String>();
                    if(acc.Subscription_Years__c.contains(';'+oldCon.Subscription_Start_Year__c)) {
                        
                        system.debug('oldCon.Subscription_Start_Year__c'+oldCon.Subscription_Start_Year__c);
                        String[] str = acc.Subscription_Years__c.split(';'+oldCon.Subscription_Start_Year__c);
                        String[] str1=acc.Subscription_Years__c.split(';');
                        testlist.addAll(str1);
                        system.debug('testlist'+testlist+'Str--'+str1+'Str'+str);
                        //delete years
                        if((Integer.valueOf(oldCon.Subscription_End_Year__c)-Integer.valueOf(oldCon.Subscription_Start_Year__c))>1){
                        List<String> dates=new List<String>();
                           List<String> str2 = new List<string>();
                          
							for(Integer k= Integer.valueOf(oldCon.Subscription_End_Year__c);k-Integer.valueOf(oldCon.Subscription_Start_Year__c)!=0;k--){
								str2.add(string.valueOf(k-1));
								
							}
                            //System.debug('str1---'+str1);
							testlist.removeAll(str2);
                          
                            acc.Subscription_Years__c='';
                            for(String ss:testlist){
                                acc.Subscription_Years__c +=ss+';';
                                system.debug('acc.Subscription_Years__c');
                            }
                            //Integer[] inter=testlist;
                            //acc.Subscription_Years__c =String.valueOf(testlist);
                            system.debug('After acc.Subscription_Years__c'+acc.Subscription_Years__c);
                        }else{
							acc.Subscription_Years__c = '';
							for(Integer i=0; i<str.size(); i++) {
								acc.Subscription_Years__c += str[i];
							}
                        }    
                        system.debug('acc.Subscription_Years__c'+acc.Subscription_Years__c);
                        accountsToUpdate.add(acc);
                    } else if(acc.Subscription_Years__c.contains(oldCon.Subscription_Start_Year__c + ';')) {
                        //Set<String> testList=new Set<String>();
                        String[] str = acc.Subscription_Years__c.split(oldCon.Subscription_Start_Year__c + ';');
                        String[] str1=acc.Subscription_Years__c.split(';');
                        testlist.addAll(str1);
                        system.debug('testlist'+testlist+'Str--'+str1+'Str'+str);
                        if((Integer.valueOf(oldCon.Subscription_End_Year__c)-Integer.valueOf(oldCon.Subscription_Start_Year__c))>1){
                            List<String> dates=new List<String>();
                           List<String> str2 = new List<string>();
                          
							for(Integer k= Integer.valueOf(oldCon.Subscription_End_Year__c);k-Integer.valueOf(oldCon.Subscription_Start_Year__c)!=0;k--){
								str2.add(string.valueOf(k-1));
								
							}
                            //System.debug('str1---'+str1);
							testlist.removeAll(str2);
                          
                            acc.Subscription_Years__c='';
                            for(String ss:testlist){
                                acc.Subscription_Years__c +=ss+';';
                                system.debug('acc.Subscription_Years__c');
                            }
                        }else{
                        acc.Subscription_Years__c = '';
                        for(Integer i=0; i<str.size(); i++) {
                            acc.Subscription_Years__c += str[i];
                        }
                        }    
                        accountsToUpdate.add(acc);
                        system.debug('acc.Subscription_Years__c'+acc.Subscription_Years__c);
                    } else if(acc.Subscription_Years__c == oldCon.Subscription_Start_Year__c) {
                        acc.Subscription_Years__c = null;
                        accountsToUpdate.add(acc);
                        system.debug('acc.Subscription_Years__c'+acc.Subscription_Years__c);
                    }
                } 
            }
        }
        
        try {
            update accountsToUpdate;
        } catch(Exception e) {
            system.debug('exception'+e);
            system.debug('exception message' +e.getMessage());
            system.debug('exception line number' +e.getLineNumber());
        }
    }
    /*public void deleteSubscriptionYears(){
        
    }*/
}