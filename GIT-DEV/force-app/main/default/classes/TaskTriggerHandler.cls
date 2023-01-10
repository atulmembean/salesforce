/**
* Handler Class     : TaskTriggerHandler
* Created by        : ETMarlabs (16-08-2016)
* Version           : 1.0
* Description       : Trigger Handler contains all the Business logic for TaskTrigger trigger.
*                   : Inline comments are added to get specific details.
* Modified Date    : 03-01-2018
**/

public with sharing class TaskTriggerHandler extends TriggerHandler{
    /*Variable declaration */
    public List<Task> newTaskList;
    public List<Task> oldTaskList;
    public map<id,Task> newTaskMap;
    public map<id,Task> oldTaskMap;
    
    /*Default Constructor*/
    public TaskTriggerHandler(){
        //nothing
    }
    /*parameterized constructor*/
    public TaskTriggerHandler(List<Task> newList , List<Task> oldList, map<id,Task> newMap , map<id,Task> oldMap){
        
        newTaskList = (newList != null && !newList.isEmpty())? newList : new List<Task>();
        oldTaskList = (oldList != null && !oldList.isEmpty())? oldList : new List<Task>();
        newTaskMap = (newMap != null && !newMap.isEmpty())? newMap : new map<id,Task>();
        oldTaskMap = (oldMap != null && !oldMap.isEmpty())? oldMap : new map<id,Task>();
    }
    /*Override afterInsert Method*/
    
    public override void afterInsert(){
        this.updateRelatedLeadRecords();
    }
    
    public override void beforeInsert(){
        this.taskTypeUpdate(newTaskList);
    }
    
    /*
* Method Name   : updateRelatedLeadRecords
* Description   : Method contains all the business logic for updating the Lead record     
* @param        : None
* @returns      : None
*/
    
    @testVisible
    private void updateRelatedLeadRecords(){
        
        List<ID> ListOfLeadIDS = new List<ID>();
        List<Lead> LeadListToBeUpdated =  new List<Lead>();
        for(Task taskObj : newTaskList){
            if(taskObj.WhoId != null && String.valueOf(taskObj.WhoId).substring(0,3) == Constants.LEAD_ID_INITIALS_3_LETTERS && taskObj.status == Constants.TASK_STATUS_COMPLETED  && (taskObj.TaskSubtype == Constants.TASK_SUBTYPE_EMAIL || taskObj.TaskSubtype == Constants.TASK_SUBTYPE_CALL)){
                ListOfLeadIDS.add(taskObj.WhoId);
            }
        }
        if(ListOfLeadIDS.size()>0){
            LeadListToBeUpdated = getRelatedLeadRecords(ListOfLeadIDS);
            
            if(LeadListToBeUpdated.size()>0){
                updateLeadRecordsWithStatusAsContacted(LeadListToBeUpdated);
            }
        }
    }
    
    /*
* Method Name   : getRelatedLeadRecords
* Description   : Method will be used get related lead records which have status as New.     
* @param        : ListOfLeadRecords -- List Of Lead Ids associated with Task
* @returns      : leadList <Lead>  -- Lead records
*/
    
    @testVisible
    private List<Lead> getRelatedLeadRecords(List<ID> ListOfLeadRecords){
        System.debug('#$#$#$#$ ListOfLeadRecords '+ListOfLeadRecords);
        List<Lead> LeadList = new List<Lead>();
        if(ListOfLeadRecords.size()>0){
            LeadList = [Select id,Status from lead where id IN : ListOfLeadRecords and Status = :Constants.LEAD_STATUS_NEW];
            
        }
        return LeadList;
    }
    
    /*
* Method Name   : updateLeadRecordsWithStatusAsContacted.
* Description   : Method will be used update lead records with status as 'Contacted'     
* @param        : LeadListToBeUpdated -- List Of Lead records
* @returns      : None
*/
    
    @testVisible
    private void updateLeadRecordsWithStatusAsContacted(List<Lead> LeadListToBeUpdated){
        for(Lead leadObj : LeadListToBeUpdated){
            leadObj.status = Constants.LEAD_STATUS_CONTACTED ;
        }
        try{
            if(LeadListToBeUpdated.size()>0)
                Database.update(LeadListToBeUpdated);
        }
        Catch(Exception e){
            System.debug('Exception --> '+e);
        }
    }
    /* public void typeUpdate(List<Task> taskList){
for(Task tsk:taskList){ 
if(tsk.Subject.containsIgnoreCase('Demo')){
tsk.Type='Demo';

}else if(tsk.Subject.containsIgnoreCase('Data Review')){
tsk.Type='Data Review';
}else if(tsk.Subject.containsIgnoreCase('Call')){
tsk.Type='Meeting';
}
}
} */
    
    /*   public void taskTypeUpdate(List<Task> taskList){
Set <String> arrayOfTypes  = new Set<String>{'call','email','demo','pilot setup','send','meeting'}; 
for(Task tsk:taskList){
String subject=tsk.Subject;
boolean check=false;
String ss;
List<String> lsttest=subject.split(' ');
for(String s: lsttest){
if(arrayOfTypes.contains(s.tolowercase())){
check=true;
ss=s;
tsk.Type=ss;
system.debug('its check true'+s);                 
break;
}
system.debug(check);
}  
} 
} */
    
    
    public void taskTypeUpdate(List<Task> taskList){
        //  Set <String> arrayOfTypes  = new Set<String>{'call','email','demo','pilot setup','send','meeting'}; 
        //   {Cal, Email, Swag, Card, and Others}
        system.debug(taskList);
        for(Task tsk:taskList){
            String subject=tsk.Subject;
            boolean check=false;
            String ss;
            List<String> lsttest=subject.split(' ');
            for(String s: lsttest){
                if(s.containsIgnoreCase('Call')){
                    check=true;
                    ss=s;
                    tsk.Type='Call';
                    system.debug('its check true'+s);                 
                    break;
                }else if(s.containsIgnoreCase('Email')){
                    check=true;
                    ss=s;
                    tsk.Type='Email';
                    system.debug('its check true'+s);                 
                    break;
                } /*else if(s.containsIgnoreCase('Swag')){
check=true;
ss=s;
tsk.Type='Swag';
system.debug('its check true'+s);                 
break;
}else if(s.containsIgnoreCase('Card')){
check=true;
ss=s;
tsk.Type='Card';
system.debug('its check true'+s);                 
break;
} */
                /*  }else if(s.containsIgnoreCase('Demo')){
check=true;
ss=s;
tsk.Type='Demo';
system.debug('its check true'+s);                 
break;
}else if(s.containsIgnoreCase('pilot')){
check=true;
ss=s;
tsk.Type='Pilot Setup';
system.debug('its check true'+s);                 
break;
}else if(s.containsIgnoreCase('send')){
check=true;
ss=s;
tsk.Type='Email';
system.debug('its check true'+s);                 
break;
}else if(s.containsIgnoreCase('sent')){
check=true;
ss=s;
tsk.Type='Email';
system.debug('its check true'+s);                 
break;
}else if(s.containsIgnoreCase('meeting')){
check=true;
ss=s;
tsk.Type='Meeting';
system.debug('its check true'+s);                 
break;
} */
                system.debug(check);
            }  
        }
    }
    public static void updateTaskField(List<Task> newtask){
        try{
            system.debug('newtask99'+newTask);
            system.debug('its task trigger --> 1');
            Set<Id> LeadId = new Set<Id>();
            
            List<Task> tasks;
            tasks = (newtask);
            for (Task taskLst: newtask){
                system.debug('Firstcheck1'+taskLst.whoId.getSObjectType().getDescribe().getName());
                if( taskLst.whoId.getSObjectType().getDescribe().getName()=='Lead'){
                    LeadId.add(taskLst.WhoId);
                }
            }
            
            List<Lead> LeadList = [select id,School_Account__c,School_Account__r.name,School_Account__r.id,
                                   (select Subject,ActivityDate from tasks
                                    order by ActivityDate 
                                   )from Lead
                                   where id in :LeadId 
                                  ];
            system.debug('LeadList11--->'+LeadList);
            //List<Event> TaskToUpdate = new List<Event>();
            for (Task tsk: newTask){
                for(Lead ld : LeadList){
                    system.debug('check1'+tsk.whoId.getSObjectType().getDescribe().getName());
                    if(tsk.whoId == ld.id){
                        system.debug('ld.School_Account__c-->>2222'+ld.School_Account__c);
                        tsk.Rpt_Account__c=ld.School_Account__c;
                        system.debug('tsk.Rpt_Account__c --->333'+tsk.Rpt_Account__c);
                        /*  ld.School_Account__c = String.valueOf(ld.Id).substring(0, 15);
system.debug('ld.School_Account__c --->>>111'+ld.School_Account__c);
tsk.SchoolAccountName__c = ld.School_Account__c;
tsk.LeadAccountName__c  = ld.School_Account__r.name;*/
                        String leadid1=String.valueOf(ld.Id).substring(0, 15);
                        system.debug('leadid----> 22'+leadid1);
                        tsk.SchoolAccountName__c = leadid1;
                        tsk.LeadAccountName__c  = ld.School_Account__r.name;
                        
                    }
                }
            }
            /*  if (!EventToUpdate.isEmpty()){
system.debug('$$$$$$$-->'+EventToUpdate);
update EventToUpdate;
} */
        }catch(Exception e){
            system.debug('exception'+e);
            system.debug('excep mess'+e.getMessage());
            system.debug('excep line'+e.getLineNumber());
        }
    }
    /*======================================================================
Method Name : ChildAccCustomRollup
Purpose     : This method is for counting Tasks to display Rollup on Account/Lead/Contact
======================================================================== */
    public static void ChildAccCustomRollup(List<Task> newObjectList){  
        Set<id> accIds = new Set<id>();
        Set<id> leadIds = new Set<id>();
        Set<id> conIds = new Set<id>();
        Set<id> oppIds = new Set<id>();
        List<Account> AccountToUpdate = new List<Account>();
        List<Account> AccountToUpdate2 = new List<Account>();
        List<Account> AccountToUpdate3 = new List<Account>();
        
        List<Lead> LeadToUpdate = new List<Lead>();
        List<Lead> LeadToUpdate2 = new List<Lead>();
        List<Lead> LeadToUpdate3 = new List<Lead>();
        
        List<Contact> ContactToUpdate = new List<Contact>();
        List<Contact> ContactToUpdate2 = new List<Contact>();
        List<Contact> ContactToUpdate3 = new List<Contact>();
        
        List<Opportunity> OpportunityToUpdate = new List<Opportunity>();
        List<Opportunity> OpportunityToUpdate2 = new List<Opportunity>();
        List<Opportunity> OpportunityToUpdate3 = new List<Opportunity>();
        
        for (Task item : newObjectList){
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
        if(!accIds.IsEmpty())
        {
            Map<Id,Account> accMap = new Map<Id,Account>([Select No_of_Task_Account__c,No_of_Email_Account__c,No_of_Call_Account__c from Account where id in :accIds]);
            //Map<Id,Task> accTaskMap = new Map<Id,Task>([Select Id from Task where TaskSubType='Task' AND WhatId in :accIds]);
            //Map<Id,Task> accEmailMap = new Map<Id,Task>([Select Id from Task where TaskSubType='Email' AND WhatId in :accIds]);
            //Map<Id,Task> accCallMap = new Map<Id,Task>([Select Id from Task where TaskSubType='Call' AND WhatId in :accIds]);
            for (Task t : newObjectList)
            {
                 if(accMap.containsKey(t.WhatId))
                 {
                    if (t.TaskSubType=='Task')
                    {
                        if(accMap.get(t.WhatId).No_of_Task_Account__c == null){
                            accMap.get(t.WhatId).No_of_Task_Account__c = 1;
                        }
                        else{
                            accMap.get(t.WhatId).No_of_Task_Account__c = accMap.get(t.WhatId).No_of_Task_Account__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Email')
                    {
                        if(accMap.get(t.WhatId).No_of_Email_Account__c == null){
                            accMap.get(t.WhatId).No_of_Email_Account__c = 1;
                        }
                        else{
                            accMap.get(t.WhatId).No_of_Email_Account__c = accMap.get(t.WhatId).No_of_Email_Account__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Call')
                    {
                        if(accMap.get(t.WhatId).No_of_Call_Account__c == null){
                            accMap.get(t.WhatId).No_of_Call_Account__c = 1;
                        }
                        else{
                            accMap.get(t.WhatId).No_of_Call_Account__c = accMap.get(t.WhatId).No_of_Call_Account__c + 1;
                        }
                    }       
                }
            }
            update accMap.values();
        }
        
        if(!oppIds.IsEmpty())
        {
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select No_of_Task_Opportunity__c,No_of_Email_Opportunity__c,No_of_Call_Opportunity__c from Opportunity where id in :oppIds]);
            for (Task t : newObjectList)
            {
                 if(oppMap.containsKey(t.WhatId))
                 {
                    if (t.TaskSubType=='Task')
                    {
                        if(oppMap.get(t.WhatId).No_of_Task_Opportunity__c == null){
                            oppMap.get(t.WhatId).No_of_Task_Opportunity__c= 1;
                        }
                        else{
                            oppMap.get(t.WhatId).No_of_Task_Opportunity__c = oppMap.get(t.WhatId).No_of_Task_Opportunity__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Email')
                    {
                        if(oppMap.get(t.WhatId).No_of_Email_Opportunity__c == null){
                            oppMap.get(t.WhatId).No_of_Email_Opportunity__c = 1;
                        }
                        else{
                            oppMap.get(t.WhatId).No_of_Email_Opportunity__c = oppMap.get(t.WhatId).No_of_Email_Opportunity__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Call')
                    {
                        if(oppMap.get(t.WhatId).No_of_Call_Opportunity__c == null){
                            oppMap.get(t.WhatId).No_of_Call_Opportunity__c = 1;
                        }
                        else{
                            oppMap.get(t.WhatId).No_of_Call_Opportunity__c = oppMap.get(t.WhatId).No_of_Call_Opportunity__c + 1;
                        }
                    }      
                }
            }
            update oppMap.values();
        }
        
        if(!conIds.IsEmpty())
        {
            Map<Id,Contact> conMap = new Map<Id,Contact>([Select No_of_Task_Contact__c,No_of_Email_Contact__c,No_of_Call_Contact__c from Contact where id in :conIds]);
            for (Task t : newObjectList)
            {
                 if(conMap.containsKey(t.WhoId))
                 {
                    if (t.TaskSubType=='Task')
                    {
                        if(conMap.get(t.WhoId).No_of_Task_Contact__c == null){
                            conMap.get(t.WhoId).No_of_Task_Contact__c = 1;
                        }
                        else{
                            conMap.get(t.WhoId).No_of_Task_Contact__c = conMap.get(t.WhoId).No_of_Task_Contact__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Email')
                    {
                        if(conMap.get(t.WhoId).No_of_Email_Contact__c == null){
                            conMap.get(t.WhoId).No_of_Email_Contact__c = 1;
                        }
                        else{
                            conMap.get(t.WhoId).No_of_Email_Contact__c = conMap.get(t.WhoId).No_of_Email_Contact__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Call')
                    {
                        if(conMap.get(t.WhoId).No_of_Call_Contact__c == null){
                            conMap.get(t.WhoId).No_of_Call_Contact__c = 1;
                        }
                        else{
                            conMap.get(t.WhoId).No_of_Call_Contact__c = conMap.get(t.WhoId).No_of_Call_Contact__c + 1;
                        }
                    }       
                }
            }
            update conMap.values();
        }
        
        if(!leadIds.IsEmpty())
        {
            Map<Id,Lead> leadMap = new Map<Id,Lead>([Select No_of_Task_Lead__c,No_of_Email_Lead__c,No_of_Call_Lead__c from Lead where id in :leadIds]);
            for (Task t : newObjectList)
            {
                 if(leadMap.containsKey(t.WhoId))
                 {
                    if (t.TaskSubType=='Task')
                    {
                        if(leadMap.get(t.WhoId).No_of_task_Lead__c == null){
                            leadMap.get(t.WhoId).No_of_task_Lead__c = 1;
                        }
                        else{
                            leadMap.get(t.WhoId).No_of_Task_Lead__c = leadMap.get(t.WhoId).No_of_Task_Lead__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Email')
                    {
                        if(leadMap.get(t.WhoId).No_of_Email_Lead__c == null){
                            leadMap.get(t.WhoId).No_of_Email_Lead__c = 1;
                        }
                        else{
                            leadMap.get(t.WhoId).No_of_Email_Lead__c = leadMap.get(t.WhoId).No_of_Email_Lead__c + 1;
                        }
                    }
                    if (t.TaskSubType=='Call')
                    {
                        if(leadMap.get(t.WhoId).No_of_Call_Lead__c == null){
                            leadMap.get(t.WhoId).No_of_Call_Lead__c = 1;
                        }
                        else{
                            leadMap.get(t.WhoId).No_of_Call_Lead__c = leadMap.get(t.WhoId).No_of_Call_Lead__c + 1;
                        }
                    }       
                }
            }
            update leadMap.values();
        }
        
        // get a map of the Account with the count of task type
        /*if(!accIds.IsEmpty()){        
            Map<id,Account> AccountMap = new Map<id,Account>([select id,name,No_of_Email_Account__c from Account where id IN : accIds]);
            // query Account and the related Task and add the size of the Task items to the Account
            for (Account ship : [select Id, Name,No_of_Task_Account__c,(select id from Tasks where TaskSubType='Task') from Account where Id IN :accIds FOR UPDATE]) {
                AccountMap.get(ship.Id).No_of_Task_Account__c = ship.Tasks.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate.add(AccountMap.get(ship.Id));
            } 
            for (Account ship2 : [select Id, Name,No_of_Email_Account__c,(select id from Tasks where TaskSubType='Email') from Account where Id IN :accIds FOR UPDATE]) {
                AccountMap.get(ship2.Id).No_of_Email_Account__c = ship2.Tasks.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate2.add(AccountMap.get(ship2.Id));
            }    
            for (Account ship3 : [select Id, Name,No_of_Call_Account__c,(select id from Tasks where TaskSubType='Call') from Account where Id IN :accIds FOR UPDATE]) {
                AccountMap.get(ship3.Id).No_of_Call_Account__c = ship3.Tasks.size();
                // add the value/Account in the map to a list so we can update it
                AccountToUpdate3.add(AccountMap.get(ship3.Id));
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
        }
        
        // get a map of the Lead with the number of Task
        if(!leadIds.IsEmpty()){  
            system.debug('Entered lead' +leadIds);
            Map<id,Lead> LeadMap = new Map<id,Lead>([select id,name,No_of_Task_Lead__c,No_of_Email_Lead__c,No_of_Call_Lead__c from Lead where id IN : leadIds]);
            // query Lead and the related Task and add the size of the Task items to the Lead
            for (Lead ship : [select Id, Name,No_of_Task_Lead__c,(select id from Tasks where TaskSubType='Task') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship.Id).No_of_Task_Lead__c = ship.Tasks.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate.add(LeadMap.get(ship.Id));
            } 
            for (Lead ship2 : [select Id, Name,No_of_Email_Lead__c,(select id from Tasks where TaskSubType='Email') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship2.Id).No_of_Email_Lead__c = ship2.Tasks.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate2.add(LeadMap.get(ship2.Id));
            }    
            for (Lead ship3 : [select Id, Name,No_of_Call_Lead__c,(select id from Tasks where TaskSubType='Call') from Lead where Id IN :leadIds FOR UPDATE]) {
                LeadMap.get(ship3.Id).No_of_Call_Lead__c = ship3.Tasks.size();
                // add the value/Lead in the map to a list so we can update it
                LeadToUpdate3.add(LeadMap.get(ship3.Id));
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
        }
        
        // get a map of the Contact with the number of Task
        if(!conIds.IsEmpty()){        
            Map<id,Contact> ContactMap = new Map<id,Contact>([select id,name,No_of_Task_Contact__c,No_of_Email_Contact__c,No_of_Call_Contact__c from Contact where id IN : conIds]);
            // query Contact and the related Task and add the size of the Task items to the Contact
            for (Contact ship : [select Id, Name,No_of_Task_Contact__c,(select id from Tasks where TaskSubType='Task') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship.Id).No_of_Task_Contact__c = ship.Tasks.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate.add(ContactMap.get(ship.Id));
            } 
            for (Contact ship2 : [select Id, Name,No_of_Email_Contact__c,(select id from Tasks where TaskSubType='Email') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship2.Id).No_of_Email_Contact__c = ship2.Tasks.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate2.add(ContactMap.get(ship2.Id));
            }    
            for (Contact ship3 : [select Id, Name,No_of_Call_Contact__c,(select id from Tasks where TaskSubType='Call') from Contact where Id IN :conIds FOR UPDATE]) {
                ContactMap.get(ship3.Id).No_of_Call_Contact__c = ship3.Tasks.size();
                // add the value/Contact in the map to a list so we can update it
                ContactToUpdate3.add(ContactMap.get(ship3.Id));
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
        }
        
        // get a map of the Opportunity with the number of Task
        if(!oppIds.IsEmpty()){        
            Map<id,Opportunity> OpportunityMap = new Map<id,Opportunity>([select id,name,No_of_Email_Opportunity__c,No_of_Task_Opportunity__c,No_of_Call_Opportunity__c from Opportunity where id IN : oppIds]);
            // query Opportunity and the related Task and add the size of the Task items to the Opportunity
            for (Opportunity ship : [select Id, Name,No_of_Task_Opportunity__c,(select id from Tasks where TaskSubType='Task') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship.Id).No_of_Task_Opportunity__c = ship.Tasks.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate.add(OpportunityMap.get(ship.Id));
            } 
            for (Opportunity ship2 : [select Id, Name,No_of_Email_Opportunity__c,(select id from Tasks where TaskSubType='Email') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship2.Id).No_of_Email_Opportunity__c = ship2.Tasks.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate2.add(OpportunityMap.get(ship2.Id));
            }    
            for (Opportunity ship3 : [select Id, Name,No_of_Call_Opportunity__c,(select id from Tasks where TaskSubType='Call') from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship3.Id).No_of_Call_Opportunity__c = ship3.Tasks.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate3.add(OpportunityMap.get(ship3.Id));
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
        }*/
    }
    /**************Ends here*******************/
       /*======================================================================
    Method Name : updateLeadStatus
    Purpose     : This method is for updating lead status of lead which the task belongs to.
        ======================================================================== */
    public static void updateLeadStatus(List<Task> newObjectList){ 
        
    system.debug('newObjectList'+newObjectList);
        Set<id> leadIds = new Set<id>();
        List<Lead> LeadList = new List<Lead>();
        List<Lead> LeadToUpdate = new List<Lead>();
        
        for (Task item : newObjectList){
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