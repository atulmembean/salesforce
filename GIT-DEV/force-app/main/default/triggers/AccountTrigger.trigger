/**
* Trigger           : AccountTrigger
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : Business logic is written in ContractTriggerHandler.
**/
trigger AccountTrigger on Account (before insert,after insert, before update,after update) {
    if (Trigger.isBefore && Trigger.isUpdate)
    {
        for (Account acc : Trigger.new)
        {
        Account oldacc = Trigger.oldMap.get(acc.Id);
        if (acc.Subscription_Expiry_Date1__c != oldacc.Subscription_Expiry_Date1__c)
             acc.Previous_Subscription_Expiry_Date__c = oldacc.Subscription_Expiry_Date1__c;
         if (acc.Membership_Expires_On__c != oldacc.Membership_Expires_On__c)
             acc.Previous_Membership_Expires_On__c = oldacc.Membean_Expires_On__c;
        }
    }
    if(Trigger.isBefore && AccountService.runBeforeOnce()) { 
        if(Trigger.isInsert) {
            AccountTriggerHandler.calculateKeyMetric(Trigger.new, null);
            AccountTriggerHandler.updateStateCountyMappping(Trigger.new);
            //AccountTriggerHandler.UpdateAccountWhenRecordCreateFromLeadConversion(Trigger.new);
           // AccountTriggerHandler.UpdateAccountAddressWithDistrictAddressWhenRecordtypeDistrict(Trigger.new,null,null);
        }
        
        if(Trigger.isUpdate) {
            AccountTriggerHandler.calculateKeyMetric(Trigger.new, Trigger.oldMap);
            AccountTriggerHandler.updateStateCountyMappping(Trigger.new);
            //AccountTriggerHandler.setMembeanPullWhenSchoolOrDistrictUpdate(Trigger.oldMap,Trigger.newMap);
            //AccountTriggerHandler.UpdateAccountAddressWithDistrictAddressWhenRecordtypeDistrict(Trigger.new,Trigger.oldMap,Trigger.newMap);
            Set<Id> Ids = New Set<Id>();
            for (Account a : Trigger.New)
            {
                If (a.Subscription_Status__c != 'Customer' && Trigger.oldMap.get(a.Id).Invite_Token__c != a.Invite_Token__c)
                    Ids.add(a.Id);
            }
            List<Contact> conlst = [Select Id,Role__C,AccountId from Contact where AccountId IN :Ids AND Role__c IN ('Teacher','Chair')];
            List<Lead> leadlst = [Select Id,Role__C,School_Account__c  from Lead where School_Account__c in :Ids AND Role__c IN ('Teacher','Chair')];
            String conflg = 'N';
            String leadflg = 'N';
            Integer cntcon = 0;
            Integer cntlead = 0;
            Integer cnttotal = 0;
            for (Account a : Trigger.New)
            {
                conflg = 'N';
                leadflg = 'N';
                cntcon = 0;
                cntlead = 0;
                cnttotal = 0;
                if(Trigger.oldMap.get(a.Id).Invite_Token__c != a.Invite_Token__c)
                {
                     for(Contact con :conlst)
                     {
                         if (con.AccountId == a.Id)
                         {
                             ++cntcon;
                         }
                     }
                     for(Lead l :leadlst)
                     {
                         if (l.School_Account__c == a.Id)
                         {
                             ++cntlead;
                         }
                     }   
                }
                cnttotal = cntcon + cntlead;
                if (cnttotal > 1)
                    a.Ready_to_Invite_via_Email__c = TRUE;
            }
            
        }
    }
    
    AccountTriggerHandler accHandler    = AccountTriggerHandler.getInstance();
    if(Trigger.isAfter && AccountService.runAfterOnce()) { 
        if(Trigger.isUpdate){
           accHandler.accountAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap); 
        }
        
    }
    
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate ||  Trigger.isDelete)) {
        system.debug('IN::::');
        
      Set<id> districtIds = new Set<id>();
            List<District__c> discrictsToUpdate= new List<District__c>();
            Id publicSchoolRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            for (Account acc : Trigger.new)
                districtIds.add(acc.District__c);
        
            if (Trigger.isUpdate || Trigger.isDelete) {
                for (Account acc : Trigger.old)
                    districtIds.add(acc.District__c);
            }
        
            // get a map of the shipments with the number of items
            Map<id,District__c> districtMap = new Map<id,District__c>([select id, name from District__c where id IN :districtIds]);
        
            // query the shipments and the related inventory items and add the size of the inventory items to the shipment's items__c
            for (District__c dst: [select Id, Name ,Total_Customers__c,Membean_Presence__c,Total_Middle_High_Schools__c,Schools__c, (select id,District__c,RecordTypeId,High_Grade__c,Subscription_Status__c from Accounts__r) from District__c where Id IN :districtIds for Update]) {
                Integer totalSchools = 0;
                Integer totalMidSizeSchools = 0;
                Integer totalCustomers = 0;
                for(Account acc : dst.Accounts__r){
                    if(acc.RecordTypeId == publicSchoolRecTypeId){
                        
                        if(acc.Subscription_Status__c == 'Customer'){
                            totalCustomers++;
                        }
                        if(acc.High_Grade__c != null && acc.High_Grade__c.isNumeric() && Integer.valueOf(acc.High_Grade__c) >= 7){
                            totalMidSizeSchools++;
                        }
                        totalSchools++;
                    }
                    
                }
                if(totalCustomers > 0){
                    dst.Membean_Presence__c = true;
                }
                dst.Schools__c = totalSchools;
                dst.Total_Middle_High_Schools__c = totalMidSizeSchools;
                dst.Total_Customers__c = totalCustomers;
                    
                //districtMap.get(dst.Id).items__c = dst.Inventory_Items__r.size();
                // add the value/shipment in the map to a list so we can update it
                discrictsToUpdate.add(dst);
            }        
            update discrictsToUpdate;  
        
            /*****************
             * Account trigger
             * for tax and
             * timezone update           
             *****************/
                
             AccountTriggerHandler.taxntimezoneUpdate(Trigger.new,Trigger.oldMap);
        
    }    
}