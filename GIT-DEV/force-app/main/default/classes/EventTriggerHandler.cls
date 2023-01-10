/*********************
* Handler Class     : EventTriggerHandler
* Created by        : Pooja K (11-09-2017)
* Version           : 40.0
* Description       : EventTriggerHandler contains all the Business logic for EventTrigger trigger.
* Modified Date		: 03-01-2018
* Test Class		: EventTriggerHandlerTest
**********************/

public class EventTriggerHandler {
    /* Method to update the field which keeps track of the schoolname tagged to the lead */
    public static void updateEventField(List<Event> newEvent){
        try{
            Set<Id> LeadId = new Set<Id>();
            
            List<Event> events;
            events = (newEvent);
            for (Event eventLst: newEvent){
                system.debug('eventLst'+eventLst);
               // if(eventLst.WhoId != null && eventLst.WhoId != ' '){
                if(eventLst.WhoId != null){			//is the correct check
                    system.debug('inside if whoid null@@');
                    if( eventLst.whoId.getSObjectType().getDescribe().getName()=='Lead'){
                        system.debug('its inside @@');
                        LeadId.add(eventLst.WhoId);
                        system.debug('LeadId'+LeadId);
                    }
                }
            }
            List<Lead> LeadList = new List<Lead>();
            if(!LeadId.isEmpty()){
                system.debug('isempty if');
                LeadList = [
                    select id,School_Account__c,School_Account__r.name,School_Account__r.id,
                    (select Subject,ActivityDate,EndDateTime from events
                     order by ActivityDate 
                    )from Lead
                    where id in :LeadId 
                ];
            }
            
            List<Event> EventToUpdate = new List<Event>();
            for (Event evt: newEvent){
                for(Lead ld : LeadList){
                    if(evt.whoId == ld.id){
                        system.debug('ld.School_Account__c-->>2222'+ld.School_Account__c);
                        evt.Rpt_Account__c=ld.School_Account__c;
                        system.debug('evt.Rpt_Account__c --->333'+evt.Rpt_Account__c);
                        /*	ld.School_Account__c = String.valueOf(ld.Id).substring(0, 15);
system.debug('ld.School_Account__c --->>>111'+ld.School_Account__c);
evt.SchoolAccountName__c = ld.School_Account__c;
evt.LeadAccountName__c  = ld.School_Account__r.name;*/
                        String leadid1=String.valueOf(ld.Id).substring(0, 15);
                        system.debug('leadid----> 22'+leadid1);
                        evt.SchoolAccountName__c = leadid1;
                        evt.LeadAccountName__c  = ld.School_Account__r.name;
                        
                    }
                }
            }
            /*	if (!EventToUpdate.isEmpty()){
system.debug('$$$$$$$-->'+EventToUpdate);
update EventToUpdate;
} */
        }catch(Exception e){
            system.debug('exception'+e);
            system.debug('excep mess'+e.getMessage());
            system.debug('excep line'+e.getLineNumber());
        }
    } 
    public static void updateEventType(List<Event> newEvent){
        try{
            for(Event tsk:newEvent){
                if(tsk.Subject.containsIgnoreCase('Calendly')){
                    if(tsk.Subject.containsIgnoreCase('Demo')){
                        tsk.Type='Demo';
                    }else if(tsk.Subject.containsIgnoreCase('Data Review')){
                        tsk.Type='Data Review';
                    }else if(tsk.Subject.containsIgnoreCase('Call')){
                        tsk.Type='Meeting';
                    }else if(tsk.Subject.containsIgnoreCase('Training')){
                        tsk.Type='Training';
                    }
                }
                /*if(tsk.Subject.containsIgnoreCase('Email')){
tsk.Type='Email';
} */
            }
        }Catch(exception e){
            system.debug('exception'+e);
            system.debug('exception message'+e.getMessage());
            system.debug('exception line number'+e.getLineNumber());
        }
    }
    /*======================================================================
Method Name : ChildAccCustomRollup
Purpose     : This method is for counting Tasks to display Rollup on Account/Lead/Contact
======================================================================== */
    public static void ChildAccCustomRollup(List<Event> newObjectList){  
        system.debug('its newObjectList'+newObjectList);
        Set<id> accIds = new Set<id>();
        Set<id> leadIds = new Set<id>();
        Set<id> conIds = new Set<id>();
        Set<id> oppIds = new Set<id>();
        List<Account> AccountToUpdate = new List<Account>();
        List<Account> AccountToUpdate2 = new List<Account>();
        List<Account> AccountToUpdate3 = new List<Account>();
        List<Account> AccountToUpdate4 = new List<Account>();
        List<Account> AccountToUpdate5 = new List<Account>();
        
        List<Lead> LeadToUpdate = new List<Lead>();
        List<Lead> LeadToUpdate2 = new List<Lead>();
        List<Lead> LeadToUpdate3 = new List<Lead>();
        List<Lead> LeadToUpdate4 = new List<Lead>();
        List<Lead> LeadToUpdate5 = new List<Lead>();
        
        List<Contact> ContactToUpdate = new List<Contact>();
        List<Contact> ContactToUpdate2 = new List<Contact>();
        List<Contact> ContactToUpdate3 = new List<Contact>();
        List<Contact> ContactToUpdate4 = new List<Contact>();
        List<Contact> ContactToUpdate5 = new List<Contact>();
        
        List<Opportunity> OpportunityToUpdate = new List<Opportunity>();
        List<Opportunity> OpportunityToUpdate2 = new List<Opportunity>();
        List<Opportunity> OpportunityToUpdate3 = new List<Opportunity>();
        List<Opportunity> OpportunityToUpdate4 = new List<Opportunity>();
        List<Opportunity> OpportunityToUpdate5 = new List<Opportunity>();
        
        for (Event item : newObjectList){
            if(item.WhatId != null){
                system.debug('item.WhatId.getSObjectType().getDescribe().getName()'+item.WhatId.getSObjectType().getDescribe().getName());
                if(item.WhatId.getSObjectType().getDescribe().getName()=='Account'){
                    accIds.add(item.WhatId); 
                    system.debug('accIds -->3'+accIds);
                }
            }
            
            if(item.WhoId != null){
                if(item.WhoId.getSObjectType().getDescribe().getName()=='Lead'){
                    leadIds.add(item.whoId);
                    system.debug('leadIds -->1'+leadIds);
                }
            }
            if(item.WhoId != null){
                if(item.WhoId.getSObjectType().getDescribe().getName()=='Contact'){
                    conIds.add(item.whoId);
                    system.debug('conIds -->2'+conIds);
                }
            }
            if(item.WhatId != null){
                if(item.WhatId.getSObjectType().getDescribe().getName()=='Opportunity'){
                    oppIds.add(item.whatId);
                    system.debug('oppIds -->2'+oppIds);
                }
            }
            
        }
        // get a map of the Account with the count of task type
        if(!accIds.IsEmpty()){        
            Map<id,Account> AccountMap = new Map<id,Account>([select id,name,No_of_Meeting_Account__c,No_of_Demo_Account__c,No_of_Data_Review_Account__c,No_of_Training_Account__c,No_of_Others_Account__c from Account where id IN : accIds]);
            // query Account and the related Task and add the size of the Task items to the Account
            for (Account ship : [select Id, Name,No_of_Meeting_Account__c,(select id from Events where Type='Meeting') from Account where Id IN :accIds FOR UPDATE]) {
                AccountMap.get(ship.Id).No_of_Meeting_Account__c = ship.Events.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate.add(AccountMap.get(ship.Id));
            } 
            for (Account ship2 : [select Id, Name,No_of_Demo_Account__c,(select id from Events where Type='Demo') from Account where Id IN :accIds FOR UPDATE]) {
                system.debug('demo entered');
                AccountMap.get(ship2.Id).No_of_Demo_Account__c = ship2.Events.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate2.add(AccountMap.get(ship2.Id));
            }    
            for (Account ship3 : [select Id, Name,No_of_Data_Review_Account__c,(select id from Events where Type='Data Review') from Account where Id IN :accIds FOR UPDATE]) {
                system.debug('data review entered');
                AccountMap.get(ship3.Id).No_of_Data_Review_Account__c = ship3.Events.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate3.add(AccountMap.get(ship3.Id));
            }   
            for (Account ship4 : [select Id, Name,No_of_Training_Account__c,(select id from Events where Type='Training') from Account where Id IN :accIds FOR UPDATE]) {
                system.debug('Training entered');
                AccountMap.get(ship4.Id).No_of_Training_Account__c = ship4.Events.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate4.add(AccountMap.get(ship4.Id));
            }   
            for (Account ship5 : [select Id, Name,No_of_Others_Account__c,(select id from Events where Type='Other') from Account where Id IN :accIds FOR UPDATE]) {
                system.debug('other entered');
                AccountMap.get(ship5.Id).No_of_Others_Account__c = ship5.Events.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate5.add(AccountMap.get(ship5.Id));
            }   
            if (AccountToUpdate.size()>0) { 
                try {
                    update AccountToUpdate;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (AccountToUpdate2.size()>0) { 
                try {                    
                    update AccountToUpdate2;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (AccountToUpdate3.size()>0) { 
                try {                    
                    update AccountToUpdate3;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (AccountToUpdate4.size()>0) { 
                try {                    
                    update AccountToUpdate4;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (AccountToUpdate5.size()>0) { 
                try {                   
                    update AccountToUpdate5;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
        }
        
        // get a map of the Lead with the number of Task
        if(!leadIds.isEmpty()){  
            system.debug('Entered lead' +leadIds);
            Map<id,Lead> LeadMap = new Map<id,Lead>([select id,name,No_of_Meeting_Lead__c,No_of_Demo_Lead__c,No_of_Traning_Lead__c,No_of_Others_Lead__c	 from Lead where id IN : leadIds]);
            // query Lead and the related Task and add the size of the Task items to the Lead
            for (Lead ship : [select Id, Name,No_of_Meeting_Lead__c,(select id from Events where Type='Meeting') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship.Id).No_of_Meeting_Lead__c = ship.Events.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate.add(LeadMap.get(ship.Id));
            } 
            for (Lead ship2 : [select Id, Name,No_of_Demo_Lead__c,(select id from Events where Type='Demo') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship2.Id).No_of_Demo_Lead__c = ship2.Events.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate2.add(LeadMap.get(ship2.Id));
            }    
            for (Lead ship3 : [select Id, Name,No_of_Data_Review_Lead__c,(select id from Events where Type='Data Review') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship3.Id).No_of_Data_Review_Lead__c = ship3.Events.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate3.add(LeadMap.get(ship3.Id));
            } 
            for (Lead ship4 : [select Id, Name,No_of_Traning_Lead__c,(select id from Events where Type='Training') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship4.Id).No_of_Traning_Lead__c = ship4.Events.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate4.add(LeadMap.get(ship4.Id));
            }
            for (Lead ship5 : [select Id, Name,No_of_Others_Lead__c	,(select id from Events where Type='Other') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship5.Id).No_of_Others_Lead__c	 = ship5.Events.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate5.add(LeadMap.get(ship5.Id));
            }
            if (LeadToUpdate.size()>0) { 
                try {
                    system.debug('Update lead task');
                    update LeadToUpdate;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (LeadToUpdate2.size()>0) { 
                try {
                    update LeadToUpdate2;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (LeadToUpdate3.size()>0) { 
                try {
                    update LeadToUpdate3;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (LeadToUpdate4.size()>0) { 
                try {
                    update LeadToUpdate4;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (LeadToUpdate5.size()>0) { 
                try {
                    update LeadToUpdate5;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
        }
        
        // get a map of the Contact with the number of Task
        if(!conIds.IsEmpty()){        
            Map<id,Contact> ContactMap = new Map<id,Contact>([select id,name,No_of_Meeting_Contact__c,No_of_Demo_Contact__c,No_of_Data_Review_Contact__c,No_of_Training_Contact__c,No_of_Others_Contact__c from Contact where id IN : conIds]);
            // query Contact and the related Task and add the size of the Task items to the Contact
            for (Contact ship : [select Id, Name,No_of_Meeting_Contact__c,(select id from Events where Type='Meeting') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship.Id).No_of_Meeting_Contact__c = ship.Events.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate.add(ContactMap.get(ship.Id));
            } 
            for (Contact ship2 : [select Id, Name,No_of_Demo_Contact__c,(select id from Events where Type='Demo') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship2.Id).No_of_Demo_Contact__c = ship2.Events.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate2.add(ContactMap.get(ship2.Id));
            }    
            for (Contact ship3 : [select Id, Name,No_of_Data_Review_Contact__c,(select id from Events where Type='Data Review') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship3.Id).No_of_Data_Review_Contact__c = ship3.Events.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate3.add(ContactMap.get(ship3.Id));
            }
            for (Contact ship4 : [select Id, Name,No_of_Training_Contact__c,(select id from Events where Type='Training') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship4.Id).No_of_Training_Contact__c = ship4.Events.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate4.add(ContactMap.get(ship4.Id));
            }
            for (Contact ship5 : [select Id, Name,No_of_Others_Contact__c,(select id from Events where Type='Other') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship5.Id).No_of_Others_Contact__c = ship5.Events.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate5.add(ContactMap.get(ship5.Id));
            }
            if (ContactToUpdate.size()>0) { 
                try {
                    update ContactToUpdate;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (ContactToUpdate2.size()>0) { 
                try {
                    update ContactToUpdate2;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (ContactToUpdate3.size()>0) { 
                try {
                    update ContactToUpdate3;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (ContactToUpdate4.size()>0) { 
                try {
                    update ContactToUpdate4;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (ContactToUpdate5.size()>0) { 
                try {
                    update ContactToUpdate5;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
        }
        
        // get a map of the Opportunity with the number of Task
        if(!oppIds.IsEmpty()){        
            Map<id,Opportunity> OpportunityMap = new Map<id,Opportunity>([select id,name,No_of_Meeting_Opportunity__c,No_of_Demo_Opportunity__c,No_of_Data_Review_Opportunity__c,No_of_Training_Opportunity__c,No_of_Others_Opportunity__c from Opportunity where id IN : oppIds]);
            // query Opportunity and the related Task and add the size of the Task items to the Opportunity
            for (Opportunity ship : [select Id, Name,No_of_Meeting_Opportunity__c,(select id from Events where Type='Meeting') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship.Id).No_of_Meeting_Opportunity__c = ship.Events.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate.add(OpportunityMap.get(ship.Id));
            } 
            for (Opportunity ship2 : [select Id, Name,No_of_Demo_Opportunity__c,(select id from Events where Type='Demo') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship2.Id).No_of_Demo_Opportunity__c = ship2.Events.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate2.add(OpportunityMap.get(ship2.Id));
            }    
            for (Opportunity ship3 : [select Id, Name,No_of_Data_Review_Opportunity__c,(select id from Events where Type='Data Review') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship3.Id).No_of_Data_Review_Opportunity__c = ship3.Events.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate3.add(OpportunityMap.get(ship3.Id));
            }   
            for (Opportunity ship4 : [select Id, Name,No_of_Training_Opportunity__c,(select id from Events where Type='Training') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship4.Id).No_of_Training_Opportunity__c = ship4.Events.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate4.add(OpportunityMap.get(ship4.Id));
            }
            for (Opportunity ship5 : [select Id, Name,No_of_Others_Opportunity__c,(select id from Events where Type='Other') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship5.Id).No_of_Others_Opportunity__c = ship5.Events.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate5.add(OpportunityMap.get(ship5.Id));
            }
            if (OpportunityToUpdate.size()>0) { 
                try {                    
                    update OpportunityToUpdate;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (OpportunityToUpdate2.size()>0) { 
                try {                    
                    update OpportunityToUpdate2;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (OpportunityToUpdate3.size()>0) { 
                try {
                    update OpportunityToUpdate3;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (OpportunityToUpdate4.size()>0) { 
                try {                    
                    update OpportunityToUpdate4;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
            if (OpportunityToUpdate5.size()>0) { 
                try {
                    update OpportunityToUpdate5;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                }
            }
        }
    } 
    /**************Ends here*******************/
    /*======================================================================
		Method Name : updateLeadStatus
		Purpose     : This method is for updating lead status of lead which the task belongs to.
        ======================================================================== */
     public static void updateLeadStatus(List<Event> newObjectList){ 
        
		system.debug('newObjectList'+newObjectList);
        Set<id> leadIds = new Set<id>();
        List<Lead> LeadList = new List<Lead>();
        List<Lead> LeadToUpdate = new List<Lead>();
        
        for (Event item : newObjectList){
            if(item.WhoId != null){
                if(item.WhoId.getSObjectType().getDescribe().getName()=='Lead'){
                    leadIds.add(item.whoId);
                    system.debug('leadIds -->1'+leadIds);
                }
            }
        }
        LeadList = [select id,name,Status from Lead where id in:leadIds];
        system.debug('LeadList'+LeadList);
        for(Lead l:LeadList){
            if(l.Status=='Nurturing'){
                system.debug('its the nurturing lead'+l.id);
                l.Status='Prospecting';
                LeadToUpdate.add(l);
            }
        }try{
            update LeadToUpdate;
        }catch(Exception e){
            system.debug('Exception is'+e);
            system.debug('Exception mess'+e.getMessage());
            system.debug('Exception line'+e.getLineNumber());
        }
    }
}