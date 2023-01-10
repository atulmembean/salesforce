/**
* Batch Class       : UpdateAccountSubscriptionAtEnd 
* Created by        : ETMarlabs (24-03-2017)
* Version           : 1.0
* Description       : Batch class will update the all the Account record which are expired.
**/
global class UpdateAccountSubscriptionAtEnd implements  Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date dt = Date.today();
        Integer currentYear = dt.year()-1;
        String years = String.Valueof(currentYear);
        if(dt.month() == 1) years = String.Valueof(currentYear-1);
        //String month = String.Valueof(Date.today().month()-1);
        String qry ='SELECT Id, Subscription_Status__c,Academic_End_Month__c, BillingCountry,Batch_Academic_month__c, Subscription_Years__c FROM Account where Subscription_Status__c=\'Customer\' and Academic_End_Month__c!=null  and Subscription_Years__c includes (:years) ' ;
        //system.debug('qry---'+qry);
        return Database.getQueryLocator(qry);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        //system.debug(scope);
        List<Account> accountsToUpdate = new List<Account>();
        List<Integer> dates=new List<Integer>();
        Map<Id,Opportunity> oppmap=new Map<Id,Opportunity>();
        Set<Id> idset=new Set<Id>();
        Date dt = Date.today().addDays(-1);
        Integer TodayYear=dt.Year()-1;
        Integer Todaymonth=dt.month();
        for(Account acc : scope){
            //system.debug('acc.Subscription_Status__c'+acc.Subscription_Status__c+'Subscription_Years__c'+acc.Subscription_Years__c+'acc.Academic_End_Month__c'+acc.Academic_End_Month__c+'acc.Batch_Academic_month__c'+acc.Batch_Academic_month__c);
            string[] str=acc.Subscription_Years__c.split(';');
            dates=new List<Integer>();
            //system.debug(str);
            for(Integer i=0;i<str.size();i++){
                dates.add(Integer.valueOf(str[i]));
            }
            dates.sort();
            Integer monthVal = Integer.Valueof(acc.Batch_Academic_month__c)+1;
            Integer yearVal = TodayYear+1;
            if(monthVal == 13) {
                monthVal = 1;
                yearVal += 1; 
            } 
            if(TodayYear==dates[dates.size()-1]
               && Integer.Valueof(acc.Batch_Academic_month__c)==Todaymonth
               && System.Date.Today()==Date.newInstance(yearVal, monthVal, 1)){
                   
                   
                   //system.debug('acc.Subscription_Status__c'+acc.Subscription_Status__c+'Subscription_Years__c'+acc.Subscription_Years__c);
                   
                   
                   acc.Subscription_Status__c ='Expired';
                   system.debug('acc.Subscription_Status__c'+acc.Subscription_Status__c);
                   accountsToUpdate.add(acc);
                   
               }
        }
        update accountsToUpdate;
        
    }
    global void finish(Database.BatchableContext bc){
        //system.debug([Select Id, Subscription_Status__c, Subscription_Years__c, Batch_Academic_month__c from Account]);
    }
}