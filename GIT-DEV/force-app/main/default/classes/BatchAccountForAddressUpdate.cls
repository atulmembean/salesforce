/*
Batch class: BatchAccountForAddressUpdate
Author:Pooja K
Date Created: 19/06/2018
Purpose: To update Account Address billing street and city.Also update the subscription Expiry month to August.
*/  
global class BatchAccountForAddressUpdate implements Database.Batchable<sObject>{
    
    global String query; 
    
    global database.querylocator start(Database.BatchableContext bc){
        
        
        query= 'select id,Name,BillingStreet,BillingCity,BillingCountry from Account';
        
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext bc, List<Account> allAccounts){
        
        /*** Logic to update the subscription expiry month on account***/
        List<Account> AccountList = new List<Account>();
        List<Account> updateAcc=new List<Account>();
        Set<Id> accId = new Set<Id>();
        Set<Id> accIdAddress = new Set<Id>();
        for(Account a:allAccounts){
            if(a.BillingCountry == 'United States' || a.BillingCountry =='Canada'){
                accId.add(a.id);
            }
        }
        AccountList=[select id,name,BillingCountry from Account where id in:accId];
        for(Account a:AccountList){
            a.Subscription_Expiry_Month__c ='August';
            updateAcc.add(a);
        }
        /***Ends***/
        
        /**Logic to camel case the account's Address correction**/
           
        List<Account> acc = new List<Account>();
        try
        {
        for(Account accLst:allAccounts){
            String fielddata1=accLst.BillingStreet;
            String fielddata2=accLst.BillingCity;
            String[] s1;
            if(fielddata1 != null){
                s1 = fielddata1.split(' ');
            }system.debug('s1 is'+s1);
            String[] s2;
            if(fielddata2 != null){
                s2 = fielddata2.split(' ');
            }system.debug('s2 is'+s2);
            Integer i=0;
            Integer j=0;
            List<String> newString1 =  new List<String>();
            List<String> newString2 =  new List<String>();
            
            if(s1 != null && !(s1.IsEmpty())){
            for(String str:s1)
            {
                i=str.length();
                system.debug('str is'+str +'***'+accLst.BillingStreet);
                system.debug(i);
                String x,y,finalstring;
                x= str.substring(0,1).toUpperCase();
                system.debug('x is'+x);
                y= str.substring(1,i).toLowerCase();
                system.debug('y is'+y);
                finalstring = x + y;
                newString1.add(finalstring);
                system.debug('the newstring1 is'+newString1);
            }
            String xyz= String.valueOf(newString1);
            String fxyz =xyz.replace(',','');
            system.debug('xyz is'+xyz);
            system.debug('fxyz is'+fxyz);
            fxyz = fxyz.replaceAll('\\p{P}','');
            accLst.BillingStreet=fxyz;
        }
            if(s2 != null && !(s2.IsEmpty())){
            for(String str:s2)
            {
                j=str.length();
                system.debug(j);
                String x,y,finalstring;
                x= str.substring(0,1).toUpperCase();
                system.debug('x is'+x);
                y= str.substring(1,j).toLowerCase();
                system.debug('y is'+y);
                finalstring = x + y ;
                newString2.add(finalstring);
                system.debug('the newstring2 is'+newString2);
            }
            String xyz2= String.valueOf(newString2);
            String fxyz2 =xyz2.replace(',','');
            system.debug('xyz2 is'+xyz2);
            system.debug('fxyz2 is'+fxyz2);
            fxyz2 = fxyz2.replaceAll('\\p{P}','');
            accLst.BillingCity=fxyz2;
            }
            
            system.debug(accLst.BillingStreet);
            system.debug(accLst.BillingCity);
            acc.add(accLst);
        }system.debug(acc);
        }catch(Exception e){
            system.debug('exception is'+e);
            system.debug('exception mess'+e.getMessage());
            system.debug('exception line'+e.getLineNumber());
        }
        /***Ends***/
        
        try{
            if(acc.size()>0){
                database.update(acc);
            }
            if(updateAcc.size()>0){
                database.update(updateAcc);
            }
        }catch(Exception e){
            system.debug('exception is'+e);
            system.debug('exception mess'+e.getMessage());
            system.debug('exception line'+e.getLineNumber());
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}