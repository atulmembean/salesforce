/**
* Class Type        : Trigger Handler
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : Class contains all the Business logic for AccountTrigger trigger.
**/
public class AccountTriggerHandler {
    
    private static AccountTriggerHandler instance;
    public static AccountTriggerHandler getInstance() {
        if (instance == null) instance = new AccountTriggerHandler ();
        return instance;
    }
    //Update Account Address With District Address if Account Record Type is District
   /* public static void UpdateAccountAddressWithDistrictAddressWhenRecordtypeDistrict(List<Account> newAccounts,Map<Id, Account> oldAccountsMap,Map<Id, Account> newAccountsMap){
        if(Trigger.isBefore){
            Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
            if(Trigger.isInsert){
                for(Account newAcc : newAccounts){
                    if(newAcc.RecordTypeId != null){
                        String recordtypeName = rtMap.get(newAcc.RecordTypeId).getName();
                        if(recordtypeName == 'District' && newAcc.District__c != null){
                            newAcc=updateBilingAddessWithDistrictAddress(newAcc);
                        }  
                    }
                    
                }
            }else if(Trigger.isUpdate){
                for(Account newMap :newAccountsMap.values()){
                    if(oldAccountsMap.get(newMap.Id).District__c != newMap.District__c && newMap.District__c != null){
                        if(newMap.RecordTypeId != null){
                            String recordtypeName = rtMap.get(newMap.RecordTypeId).getName();
                            system.debug('@@ recordtypeName '+recordtypeName);
                            if(recordtypeName == 'District' && newMap.District__c != null){
                                newMap=updateBilingAddessWithDistrictAddress(newMap);
                                system.debug(newMap);
                            }
                        }  
                     }
                }                
            }
        }
    } 
   
    public static Account updateBilingAddessWithDistrictAddress(Account newAcc){
        District__c district = [select Id,City__c,Street_Address__c,Country__c,Zip__c,Locale_Code__c,Locale__c,Zip_4_digit__c from District__c where id= :newAcc.District__c limit 1];
        newAcc.BillingCity=district.City__c;
        newAcc.BillingStreet=district.Street_Address__c;
        newAcc.BillingCountry=district.Country__c;
        newAcc.BillingPostalCode=district.Zip__c;
        newAcc.Locale_Code__c= district.Locale_Code__c;
        newAcc.Locale__c=district.Locale__c;
        newAcc.Zip_4_digit__c=district.Zip_4_digit__c;
        
        return newAcc;
    } */
    
  //Set for Membean Pull when School ID or District is updated  
      /*  public static void setMembeanPullWhenSchoolOrDistrictUpdate(Map<Id, Account> oldAccountsMap,Map<Id, Account> newAccountsMap){
            if(Trigger.isBefore){
               
                 if(Trigger.isUpdate){
                            for(Account newMap :newAccountsMap.values()){
                                if(newMap.Subscription_Expiry_Date1__c != null &&
                                   ((oldAccountsMap.get(newMap.Id).School_ID__c != newMap.School_ID__c && newMap.School_ID__c != null)||
                                    (oldAccountsMap.get(newMap.Id).District__c != newMap.District__c && newMap.District__c != null))){
                                    newMap.Temp_Ready_for_Membean_Sync__c = true;
                                }
                            }
                     }
            } 
        } */
//Update Account when record is created using Lead conversion
  /*  public static void UpdateAccountWhenRecordCreateFromLeadConversion(List<Account> newAccounts){
            if(Trigger.isBefore){
               if(Trigger.isInsert){
                   for(Account newAccounr : newAccounts ){
                       if(newAccounr.Lead_Type__c != null){
                           if(newAccounr.Lead_Type__c == 'Public School'){
                               newAccounr.RecordTypeId = '012360000011rEyAAI';
                           }else if(newAccounr.Lead_Type__c == 'Private School'){
                               newAccounr.RecordTypeId = '012360000011rExAAI';
                           }else if(newAccounr.Lead_Type__c == 'District'){
                               newAccounr.RecordTypeId = '012360000011rEwAAI';
                           }else if(newAccounr.Lead_Type__c == 'Agency'){
                               newAccounr.RecordTypeId = '012360000011rEvAAI';
                           }else{
                               newAccounr.RecordTypeId = '012360000011rEyAAI';
                           }
                       }
                   }
               }
            }
    } */
    
    public static void updateStateCountyMappping(List<Account> newAccounts){
        List<String> countyName = new List<String>();
        for(Account newAcc : newAccounts) {
            countyName.add(newAcc.County_Name__c);
        }
        system.debug('@@@@  countyName '+countyName);
        Map<String,String> nameVsId = new Map<String,String>();
        for(City_State_Mapping__c city_state : [Select Id,County__c from City_State_Mapping__c where County__c in :countyName]){
            nameVsId.put(city_state.County__c , city_state.Id);
        }
        system.debug('@@@  nameVsId '+nameVsId);
        for(Account acc : newAccounts){//
            if(nameVsId.containskey(acc.County_Name__c)){
                //acc.State_County_Mapping__c = nameVsId.get(acc.County_Name__c);
            }
        }
        system.debug('@@@@  newAccounts '+newAccounts);
    }
    public static void calculateKeyMetric(List<Account> newAccounts, Map<Id, Account> oldAccountsMap) {
        //updateStateCountyMappping(newAccounts);
        for(Account newAcc : newAccounts) {
            system.debug('newAccounts'+newAccounts);
            system.debug('oldAccountsMap'+oldAccountsMap);
            if(newAcc.RecordTypeId == AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PrivateSchool).Id) {
                Decimal totalNoOfStudents = 0;
                
                Integer lowGrade = 0;
                Integer highGrade = 0;
                
                if(newAcc.Low_Grade__c == NULL || !newAcc.Low_Grade__c.isNumeric() || Integer.valueOf(newAcc.Low_Grade__c) < Constants.ACC_LOWGRADE) {
                    lowGrade = Constants.ACC_LOWGRADE;
                } else {
                    system.debug('lowGrade'+lowGrade);
                    lowGrade = Integer.valueOf(newAcc.Low_Grade__c);
                }
                
                if(newAcc.High_Grade__c == NULL || !newAcc.High_Grade__c.isNumeric()) {
                    highGrade = Constants.ACC_HIGHGRADE;
                } else {
                    system.debug('highGrade'+highGrade);
                    highGrade = Integer.valueOf(newAcc.High_Grade__c);
                }
                
                if(newAcc.Enroll_1__c != NULL && lowGrade <= 1 && highGrade >= 1) {
                    totalNoOfStudents += newAcc.Enroll_1__c;
                    system.debug('newAcc.Enroll_1__c'+newAcc.Enroll_1__c);
                }
                if(newAcc.Enroll_2__c != NULL && lowGrade <= 2 && highGrade >= 2) {
                    totalNoOfStudents += newAcc.Enroll_2__c;
                    system.debug('newAcc.Enroll_2__c'+newAcc.Enroll_2__c);
                }
                if(newAcc.Enroll_3__c != NULL && lowGrade <= 3 && highGrade >= 3) {
                    totalNoOfStudents += newAcc.Enroll_3__c;
                    system.debug('newAcc.Enroll_3__c'+newAcc.Enroll_3__c);
                }
                if(newAcc.Enroll_4__c != NULL && lowGrade <= 4 && highGrade >= 4) {
                    totalNoOfStudents += newAcc.Enroll_4__c;
                    system.debug('newAcc.Enroll_4__c'+newAcc.Enroll_4__c);
                }
                if(newAcc.Enroll_5__c != NULL && lowGrade <= 5 && highGrade >= 5) {
                    totalNoOfStudents += newAcc.Enroll_5__c;
                    system.debug('newAcc.Enroll_5__c'+newAcc.Enroll_5__c);
                }
                if(newAcc.Enroll_6__c != NULL && lowGrade <= 6 && highGrade >= 6) {
                    totalNoOfStudents += newAcc.Enroll_6__c;
                    system.debug('newAcc.Enroll_6__c'+newAcc.Enroll_6__c);
                }
                if(newAcc.Enroll_7__c != NULL && lowGrade <= 7 && highGrade >= 7) {
                    totalNoOfStudents += newAcc.Enroll_7__c;
                    system.debug('newAcc.Enroll_7__c'+newAcc.Enroll_7__c);
                }
                if(newAcc.Enroll_8__c != NULL && lowGrade <= 8 && highGrade >= 8) {
                    totalNoOfStudents += newAcc.Enroll_8__c;
                    system.debug('newAcc.Enroll_8__c'+newAcc.Enroll_8__c);
                }
                if(newAcc.Enroll_9__c != NULL && lowGrade <= 9 && highGrade >= 9) {
                    totalNoOfStudents += newAcc.Enroll_9__c;
                    system.debug('newAcc.Enroll_9__c'+newAcc.Enroll_9__c);
                }
                if(newAcc.Enroll_10__c != NULL && lowGrade <= 10 && highGrade >= 10) {
                    totalNoOfStudents += newAcc.Enroll_10__c;
                    system.debug('newAcc.Enroll_10__c'+newAcc.Enroll_10__c);
                }
                if(newAcc.Enroll_11__c != NULL && lowGrade <= 11 && highGrade >= 11) {
                    totalNoOfStudents += newAcc.Enroll_11__c;
                    system.debug('newAcc.Enroll_11__c'+newAcc.Enroll_11__c);
                }
                if(newAcc.Enroll_12__c != NULL && lowGrade <= 12 && highGrade >= 12) {
                    totalNoOfStudents += newAcc.Enroll_12__c;
                    system.debug('newAcc.Enroll_12__c'+newAcc.Enroll_12__c);
                }
                system.debug('newAcc.No_of_Students__c $$$$$$'+newAcc.No_of_Students__c);
                if(newAcc.No_of_Students__c != NULL) {
                    if(totalNoOfStudents == 0) {
                        newAcc.Growth_Potential__c = null;
                        system.debug('Growth_Potential__c null'+newAcc.Growth_Potential__c);
                    } else {
                        newAcc.Growth_Potential__c = ((totalNoOfStudents - newAcc.No_of_Students__c) / totalNoOfStudents) * 100;
                        system.debug('Growth_Potential__c value is'+newAcc.Growth_Potential__c);
                    }
                }
            } else if(newAcc.RecordTypeId == AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id) {
                system.debug('newAcc.RecordTypeId  $$'+newAcc.RecordTypeId);
                if(newAcc.No_of_Students__c != NULL && newAcc.Students__c != NULL) {
                    system.debug('newAcc.No_of_Students__c is in else if ***'+newAcc.No_of_Students__c);
                    Decimal totalNoOfStudents = 0;
                    if(newAcc.Type_of_School__c == Constants.ACC_SCHOOL_TYPE_MIDDLE || newAcc.Type_of_School__c == Constants.ACC_SCHOOL_TYPE_HIGH) {
                        totalNoOfStudents = newAcc.Students__c;
                        system.debug('newAcc.Type_of_School__c ##'+newAcc.Type_of_School__c);
                    } else {
                        if(newAcc.Low_Grade__c != NULL && (!newAcc.Low_Grade__c.isNumeric() || Constants.ACC_LOWGRADE - Integer.valueOf(newAcc.Low_Grade__c) > 0)) {
                            Decimal lowGrade = newAcc.Low_Grade__c.isNumeric() ? Decimal.valueOf(newAcc.Low_Grade__c) : 1;
                            Decimal highGrade;
                            if(newAcc.High_Grade__c == NULL) {
                                highGrade = Decimal.valueOf(Constants.ACC_HIGHGRADE);
                                system.debug('highGrade in if !!'+highGrade);
                            } else {
                                highGrade = Decimal.valueOf(newAcc.High_Grade__c);
                                system.debug('highGrade in else !!'+highGrade);
                            }
                            if(highGrade == 0) {
                                totalNoOfStudents = 0;
                            } else {
                                totalNoOfStudents = newAcc.Students__c * ((highGrade - (Constants.ACC_LOWGRADE - lowGrade))/highGrade);
                            }
                        } else {
                            totalNoOfStudents = newAcc.Students__c;
                        }
                    }
                    system.debug('totalNoOfStudents !!'+totalNoOfStudents);
                    if(totalNoOfStudents == 0) {
                        newAcc.Growth_Potential__c = null; system.debug('Growth_Potential__c is null here'+ newAcc.Growth_Potential__c );
                        return;
                    } else {
                        newAcc.Growth_Potential__c = ((totalNoOfStudents - newAcc.No_of_Students__c) / totalNoOfStudents) * 100;
                        system.debug('Growth_Potential__c is @@'+ newAcc.Growth_Potential__c );
                    }  
                } else {
                    newAcc.Growth_Potential__c = null; system.debug('Growth_Potential__c is null here last else!!'+ newAcc.Growth_Potential__c );
                }
            }
        }
    }
    
    /*@Purpose: To handle Account after events
      @Param:newAccounts list of new Account
      @Param:newAccountsMap Map of new new Account
      @Param:oldAccounts List of old Account
      @Param:olAccountsMap Map of old Account
     */
    public void accountAfterUpdate(final List<Account> newAccounts, final Map<Id, Account> newAccountsMap,final List<Account> oldAccounts, final Map<Id, Account> olAccountsMap){
        updateDistrictYears(newAccounts, newAccountsMap,oldAccounts, olAccountsMap);
    }
    
    /*@Purpose: Update District's Pilot Year and Customer Year if any change in 
      Account Pilot year or Subscription Year
      @Param:newAccounts list of new Account
      @Param:newAccountsMap Map of new new Account
      @Param:oldAccounts List of old Account
      @Param:olAccountsMap Map of old Account
     */
    public void updateDistrictYears(List<Account> newAccounts, Map<Id, Account> newAccountsMap,List<Account> oldAccounts, Map<Id, Account> olAccountsMap){
        
        try{
            List<Id> distAccids = new List<Id>();
            
            for(String s : newAccountsMap.keySet()){
                
                if((olAccountsMap.get(s).Pilot_Years__c != newAccountsMap.get(s).Pilot_Years__c
                    && newAccountsMap.get(s).Pilot_Years__c != null) 
                   ||(olAccountsMap.get(s).Subscription_Years__c != newAccountsMap.get(s).Subscription_Years__c 
                      && newAccountsMap.get(s).Subscription_Years__c != null)){
                          
                          if(newAccountsMap.get(s).District__c != null){
                              distAccids.add(newAccountsMap.get(s).District__c);
                          }
                      }
            }

            if(distAccids.size() > 0){
                Map<Id,District__c> districtMap;
                
                try{
                    districtMap = new Map<Id,District__c>([Select id,Pilot_Years__c,Customer_Years__c from District__c where Id IN : distAccids]); 
                }catch(QueryException e){system.debug('QueryException::'+e.getMessage());}
                
                
                Map<Id,District__c> districtToUpdate    = new Map<Id,District__c>();
                
                for(String s : newAccountsMap.keySet()){
                    
                    
                    District__c dist    = new District__c();
                    dist                = districtMap.get(newAccountsMap.get(s).District__c);
                    
                    if(newAccountsMap.get(s).Pilot_Years__c != null 
                       && districtMap.ContainsKey(newAccountsMap.get(s).District__c)){
                           
                           string pilotYear = String.ValueOf(newAccountsMap.get(s).Pilot_Years__c);

                           // If Pilot Year is not blank
                           if(districtMap.get(newAccountsMap.get(s).District__c).Pilot_Years__c != null){   
                               
                               String[] pYears  = newAccountsMap.get(s).Pilot_Years__c.split(';');
                               for(integer i=0;i<pYears.size();i++){
                                   if(!districtMap.get(newAccountsMap.get(s).District__c).Pilot_Years__c.contains(pYears[i])){
                                       dist.Pilot_Years__c  += ';'+pYears[i];
                                   }
                               }
                           }else{
                               dist.Pilot_Years__c  =pilotYear;                 
                           }
                           
                           if(districtToUpdate.containsKey(newAccountsMap.get(s).District__c)){
                               districtToUpdate.get(newAccountsMap.get(s).District__c).Pilot_Years__c   = dist.Pilot_Years__c;
                           }else{
                               districtToUpdate.put(newAccountsMap.get(s).District__c,dist);
                           }
                       }
                    
                    if(newAccountsMap.get(s).Subscription_Years__c != null 
                       && districtMap.ContainsKey(newAccountsMap.get(s).District__c)){
                           
                           string subsYear  = String.ValueOf(newAccountsMap.get(s).Subscription_Years__c);
                           
                           // If Pilot Year is not blank
                           if(districtMap.get(newAccountsMap.get(s).District__c).Customer_Years__c != null){    
                               
                               String[] subYears    = newAccountsMap.get(s).Subscription_Years__c.split(';');
                               for(integer i=0;i<subYears.size();i++){
                                   if(!districtMap.get(newAccountsMap.get(s).District__c).Customer_Years__c.contains(subYears[i])){
                                       dist.Customer_Years__c   += ';'+subYears[i];
                                   }  
                               }
                               
                           }else{
                               dist.Customer_Years__c   =subsYear;                  
                           }
                           
                           if(districtToUpdate.containsKey(newAccountsMap.get(s).District__c)){
                               districtToUpdate.get(newAccountsMap.get(s).District__c).Customer_Years__c    = dist.Customer_Years__c;
                           }else{
                               districtToUpdate.put(newAccountsMap.get(s).District__c,dist);
                           }
                           
                       }
                    system.debug(' dist.Customer_Years__c'+ dist.Customer_Years__c);
                }
                
                if(districtToUpdate.values().size() >0){
                    try{system.debug('districtToUpdate.values()'+districtToUpdate.values());
                        update districtToUpdate.values();
                    }catch(DMLException e){system.debug('DML-Exception::'+e.getMessage());}
                    
                }
                
            }
        }catch(Exception ex){system.debug('Exception::'+ex.getMessage());}
    }
    
    public static void taxntimezoneUpdate(List<Account> newAccntMap, Map<Id,Account> oldAccntMap){
        
        List<Account> taxAcnt = new List<Account>();
        //List<Account> timezoneAcnt = new List<Account>();
        List<Account> taxAccountsToUpdate = new List<Account>();
        //List<Account> timezoneAccountsToUpdate = new List<Account>();
        Set<String> searchList = new Set<String>();
                              
        for(Account na:newAccntMap){
            
            if(oldAccntMap != Null){
              
            Account oldAcct = oldAccntMap.get(na.Id);
            
            if(na.BillingState != oldAcct.BillingState){
                if(na.BillingCity != oldAcct.BillingCity || na.BillingCity != Null){
                    //timezoneAcnt.add(na);
                    searchList.add(na.BillingState+' '+na.BillingCity);
                } 
                
                if(na.County_Name__c != oldAcct.County_Name__c || na.County_Name__c != Null){
                    taxAcnt.add(na);
                    searchList.add(na.BillingState+' '+na.County_Name__c);
                }
                                
            }
            else if(na.BillingState != Null){
                
                if(na.BillingCity != oldAcct.BillingCity){
                   // timezoneAcnt.add(na);
                    searchList.add(na.BillingState+' '+na.BillingCity);
                }
                                
                if(na.County_Name__c != oldAcct.County_Name__c){
                    taxAcnt.add(na);
                    searchList.add(na.BillingState+' '+na.BillingCity);
                }
                
            }
                
            }
            else if(oldAccntMap == Null){                
                if(na.BillingCity != Null && na.BillingState != Null && na.Tax__c == Null){
                   // timezoneAcnt.add(na);
                    searchList.add(na.BillingState+' '+na.BillingCity);    
                }                
            }
            
            }
        
            if(searchList.size() > 0){
                //List<City_State_Mapping__c> csm = [select Tax__c,Timezone__c,Pairing_for_tax__c,Pairing_for_timezone__c,Type__c from City_State_Mapping__c where Pairing_for_tax__c IN:searchList OR Pairing_for_timezone__c IN:searchList];
                List<City_State_Mapping__c> csm = [select Tax__c,/*Timezone__c,*/Pairing_for_tax__c,/*Pairing_for_timezone__c,*/Type__c from City_State_Mapping__c where Pairing_for_tax__c IN:searchList /*OR Pairing_for_timezone__c IN:searchList*/];
                
                for(City_State_Mapping__c c:csm){
                    for(Account t:taxAcnt){
                        String match = t.BillingState+' '+t.County_Name__c;
                        if(c.Pairing_for_tax__c == match && c.Type__c == 'Tax'){
                            
							Account acc = new Account(Id =t.Id,Tax__c = c.Tax__c);
							taxAccountsToUpdate.add(acc);                            
                        }
                    } 
                    
                   /* for(Account t:timezoneAcnt){
						String match = t.BillingState+' '+t.BillingCity;
						if(c.Pairing_for_timezone__c == match && c.Type__c == 'Timezone'){
                           
                            Account acc = new Account(Id =t.Id,Timezone__c = c.Timezone__c);
							timezoneAccountsToUpdate.add(acc);
                            
                        }                        
                    } */
                }
            }
            
        
                
        if(taxAccountsToUpdate.size()>0)
        update taxAccountsToUpdate;
        
       // if(timezoneAccountsToUpdate.size()>0)
        //update timezoneAccountsToUpdate;
    } 
    
}