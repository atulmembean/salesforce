trigger EventTrigger on Event (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
     if(Trigger.isBefore){
         if(Trigger.isInsert && OpportunityService.runAfterOnce()){
             EventTriggerHandler.updateEventField(Trigger.New);
             EventTriggerHandler.updateEventType(Trigger.New);
             EventTriggerHandler.updateLeadStatus(Trigger.New);
         }
         if(Trigger.isUpdate && OpportunityService.runAfterOnce()){
             EventTriggerHandler.updateEventField(Trigger.New);
             EventTriggerHandler.updateEventType(Trigger.New);
             EventTriggerHandler.updateLeadStatus(Trigger.New);
             
             set<Id> lstConId = new set<Id>();
            set<Id> lstLeadId = new set<Id>();
            Date dt = System.Today().addDays(-1);
            String sub = '';
            //Date dtevt = New Date();
            for(Event e :trigger.new){
                Event oldEvent = Trigger.oldMap.get(e.ID);
                sub = e.Subject;
                
                //Date dtevt = date.newinstance(e.EndDateTime.year(), e.EndDateTime.month(), e.EndDateTime.day());
                Date dtevt = e.EndDateTime.date();
                if (e.whoId != Null && dtevt != Null && dtevt <= dt && sub.indexOf('Canceled:') == -1 && e.Cancelled__c == TRUE && oldEvent.Cancelled__c != e.Cancelled__c)
                {
                    if (e.whoId.getSObjectType().getDescribe().getName()=='Lead'  )
                        lstLeadId.add(e.whoId);
                    else if (e.whoId.getSObjectType().getDescribe().getName()=='Contact')
                        lstConId.add(e.whoId);
                }
            }
            List<Lead> ldlst = [Select Id,Total_Events_COnducted__c from Lead where Id in :lstLeadId];
            List<Contact> conlst = [Select Id,Total_Events_COnducted__c from Contact where Id in :lstConId];
            List<Lead> ldlstupd = New List<Lead>();
            List<Contact> conlstupd = New List<Contact>();
            for (Lead l :ldlst)
            {
                if (l.Total_Events_COnducted__c != Null)
                {
                    if (l.Total_Events_COnducted__c == 0)
                        l.Total_Events_COnducted__c = Null;
                    else if (l.Total_Events_COnducted__c > 0)
                        l.Total_Events_COnducted__c = l.Total_Events_COnducted__c  - 1;
                    ldlstupd.add(l);
                }
            }
            for (Contact c :conlst)
            {
                if (c.Total_Events_COnducted__c != Null)
                {
                    if (c.Total_Events_COnducted__c == 0)
                        c.Total_Events_COnducted__c = Null;
                    else if (c.Total_Events_COnducted__c > 0)
                        c.Total_Events_COnducted__c = c.Total_Events_COnducted__c  - 1;
                    conlstupd.add(c);
                }
            }
            if (ldlstupd.Size()>0)
                update ldlstupd;
            if (conlstupd.Size()>0)
                update conlstupd;
                 
                 
                 
                 
         }
     }
    
    
    /**For task types Count : Creation of custom rollup for capture count of child opportunitiessk types of Call ,Email and Task**/
     if (Trigger.isInsert){
         system.debug('entered trigger');
        if(trigger.isAfter && OpportunityService.runAfterOnce()){
            system.debug('Called method'+Trigger.new);
            EventTriggerHandler.ChildAccCustomRollup(Trigger.new);
        }        
    }
    if ((Trigger.isUpdate || Trigger.isDelete) ){
        if(trigger.isAfter && OpportunityService.runAfterOnce()){
            system.debug('entered update delete');
            EventTriggerHandler.ChildAccCustomRollup(Trigger.old);
        }
    } 
    
    if (Trigger.isDelete && Trigger.isAfter)
    {
        set<Id> lstConId = new set<Id>();
        set<Id> lstLeadId = new set<Id>();
        Date dt = System.Today().addDays(-1);
        String sub = '';
        //Date dtevt = New Date();
        for(Event e :trigger.old){
            sub = e.Subject;
            
            //Date dtevt = date.newinstance(e.EndDateTime.year(), e.EndDateTime.month(), e.EndDateTime.day());
            Date dtevt = e.EndDateTime.date();
            if (e.whoId != Null && dtevt != Null && dtevt <= dt && sub.indexOf('Canceled:') == -1 && e.Cancelled__c == FALSE)
            {
                if (e.whoId.getSObjectType().getDescribe().getName()=='Lead'  )
                    lstLeadId.add(e.whoId);
                else if (e.whoId.getSObjectType().getDescribe().getName()=='Contact')
                    lstConId.add(e.whoId);
            }
        }
        List<Lead> ldlst = [Select Id,Total_Events_COnducted__c from Lead where Id in :lstLeadId];
        List<Contact> conlst = [Select Id,Total_Events_COnducted__c from Contact where Id in :lstConId];
        List<Lead> ldlstupd = New List<Lead>();
        List<Contact> conlstupd = New List<Contact>();
        for (Lead l :ldlst)
        {
            if (l.Total_Events_COnducted__c != Null)
            {
                if (l.Total_Events_COnducted__c == 0)
                    l.Total_Events_COnducted__c = Null;
                else if (l.Total_Events_COnducted__c > 0)
                    l.Total_Events_COnducted__c = l.Total_Events_COnducted__c  - 1;
                ldlstupd.add(l);
            }
        }
        for (Contact c :conlst)
        {
            if (c.Total_Events_COnducted__c != Null)
            {
                if (c.Total_Events_COnducted__c == 0)
                    c.Total_Events_COnducted__c = Null;
                else if (c.Total_Events_COnducted__c > 0)
                    c.Total_Events_COnducted__c = c.Total_Events_COnducted__c  - 1;
                conlstupd.add(c);
            }
        }
        if (ldlstupd.Size()>0)
            update ldlstupd;
        if (conlstupd.Size()>0)
            update conlstupd;    
    }
    /**********Ends here*************/
}