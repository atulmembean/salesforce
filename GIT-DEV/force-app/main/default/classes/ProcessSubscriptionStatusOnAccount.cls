global class ProcessSubscriptionStatusOnAccount implements Database.Batchable<sObject>, system.Schedulable  {
    global static void execute(SchedulableContext context){
        Database.executeBatch(new ProcessSubscriptionStatusOnAccount());
    }
    public static Database.QueryLocator start(Database.BatchableContext context){
        if (Test.isRunningTest())
            return Database.getQueryLocator('select id,name,Subscription_Expiry_Date1__c,Membership_Expires_On__c,Membean_Expires_On__c from Account where Subscription_Status__c=\'Customer\' AND Membean_Expires_On__c != Null AND Subscription_Expiry_Date1__c != Null LIMIT 1');
        else
            return Database.getQueryLocator('select id,name,Subscription_Expiry_Date1__c,Membership_Expires_On__c,Membean_Expires_On__c from Account where (RecordType.Name = \'Public School\' OR RecordType.Name = \'Private School\') AND Subscription_Status__c=\'Customer\'');
        // Database.getQueryLocator('select id,name,Subscription_Expiry_Date1__c,Membership_Expires_On__c,Membean_Expires_On__c from Account where Subscription_Status__c=\'Customer\' AND (Id = \'0013600000ZVspyAAD\' OR Id = \'0013600000ZWKylAAH\')');
    }
    public static void execute(database.BatchableContext context,List<Account>lstAcc){
        for(Account acc : lstAcc){
            if (acc.Membean_Expires_On__c != Null && acc.Subscription_Expiry_Date1__c != Null)
            {
                if (Test.isRunningTest())
                {
                    acc.Membean_Expires_On__c = system.Today() + 1;
                    acc.Subscription_Expiry_Date1__c = system.Today() + 365;
                    update acc;
                }
                System.debug('Condition 1: '+acc.Membean_Expires_On__c+' '+acc.Subscription_Expiry_Date1__c +' '+(acc.Membean_Expires_On__c<acc.Subscription_Expiry_Date1__c ));
                System.debug('Condition 2:'+System.Today().daysBetween(acc.Membean_Expires_On__c));
                if(acc.Membean_Expires_On__c<acc.Subscription_Expiry_Date1__c && System.Today().daysBetween(acc.Membean_Expires_On__c) <= 30){
                    acc.Membean_Expires_On__c =acc.Membean_Expires_On__c.addYears(1);// Date.newInstance(acc.Membean_Expires_On__c.Year()+1, acc.Membean_Expires_On__c.month(), acc.Membean_Expires_On__c.day());
                    acc.Membership_Expires_On__c =acc.Membership_Expires_On__c.addYears(1);// Date.newInstance(acc.Membership_Expires_On__c.Year()+1, acc.Membership_Expires_On__c.month(), acc.Membership_Expires_On__c.day());
                    acc.Ready_for_Membean_Sync__c = true;
                }
            }
            
        }
        update lstAcc;
        
    }
    public static void finish(Database.BatchableContext context){
        
    }

}