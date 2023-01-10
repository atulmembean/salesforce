@isTest(SeeAllData=TRUE)
private class TaskTrigger_Test {
public Static Lead Leadobj2;
 public Static Task taskObj ;
    static testMethod void testmethodForLeadstatus(){
        Leadobj2 = new Lead(
          LastName = 'LastName1ABCCC',
          Company = 'Test Company test',
          //School_Account__c = AccountObj.id ,       
          Status = 'New',                           
          Email = 'fran_m_adams_tteesstt@gw0001.com', 
          HasOptedOutOfEmail = false                        
        );
        insert Leadobj2;
        taskObj = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhoID = Leadobj2.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj; 
        Leadobj2 = new Lead(
          LastName = 'LastName1ABCCCD',
          Company = 'Test Company testD',
          //School_Account__c = AccountObj.id ,       
          Status = 'New',                           
          Email = 'fran_m_adams_tteesstt@gw0001D.com', 
          HasOptedOutOfEmail = false                        
        );
        insert Leadobj2;
        taskObj = new Task(
          Subject = 'MassMailer Test',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhoID = Leadobj2.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj;
        taskObj.Subject = 'Test update';
        update taskObj;
    }
     static testMethod void testmethodForLeadstatus1() {
        Lead leadId2 = new Lead();
        List<Task> tskList = new List<Task>();
        leadId2 = new Lead(LastName='ABCD',Company='Test 1',LeadSource='Online',
                           Website='https://Abc.com',Role__c='Chair',Status='Nurturing');
        insert leadId2;
        Task  taskObj9= new Task(
            Subject = 'Task',                            
            ActivityDate = Date.Today(), 
            TaskSubtype = 'Task', 
            Whoid = leadId2.id       
        );
        insert taskObj9;
        tskList.add(taskObj9);
        TaskTriggerHandler.updateLeadStatus(tskList);
        
    }
    
    static testMethod void testmethodInboundEmailLeadUpdate() {
        List<Task> t= [Select Id,WhoId from Task where Who.Type='Lead' AND Type = 'Email' order by createddate DESC Limit 100];
        Set<Id> tId =  New Set<Id>();
        for (Task ta :t)
        {
            tId.add(ta.Id);
        }
        List<EmailMessage> emlst = [Select Id,ActivityId from EmailMessage where Incoming = TRUE And ActivityId in :tId];
        EmailMessage em = [Select Id,ActivityId from EmailMessage where Id = :emlst[0].Id];
        Task tnew= [Select Id,WhoId from Task where Id = :em.ActivityId];
        
        Lead l = [Select Id from Lead where Id = :tnew.whoId limit 1];
        Test.StartTest();
        Task t1 = New Task();
        t1 = tnew.clone(false, true, false, false);
        t1.Subject = 'New Test';
        insert t1;
        emailMessage inboundOne = new emailMessage(
        Subject = 'First inbound email subject',
        TextBody = 'First inbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = true
        );
        insert inboundOne;
        Test.StopTest();
    }
    
    static testMethod void testmethodOutboundEmailLeadUpdate() {
        List<Task> t= [Select Id,WhoId from Task where Who.Type='Lead' AND Type = 'Email' order by createddate DESC Limit 100];
        Set<Id> tId =  New Set<Id>();
        for (Task ta :t)
        {
            tId.add(ta.Id);
        }
        List<EmailMessage> emlst = [Select Id,ActivityId from EmailMessage where Incoming = FALSE And ActivityId in :tId];
        EmailMessage em = [Select Id,ActivityId from EmailMessage where Id = :emlst[0].Id];
        Task tnew= [Select Id,WhoId from Task where Id = :em.ActivityId];
        
        Lead l = [Select Id from Lead where Id = :tnew.whoId limit 1];
        Test.StartTest();
        Task t1 = New Task();
        t1 = tnew.clone(false, true, false, false);
        t1.Subject = 'New Test1';
        insert t1;
        emailMessage outboundOne = new emailMessage(
        Subject = 'First outbound email subject',
        TextBody = 'First outbound email textbody',
        ToAddress = l.Id,
        Status = '3',
        Incoming = false
        );
        insert outboundOne;
        Test.StopTest();
    }
    static testMethod void testmethodForLeadEmailTask(){
    Test.StartTest();
        Leadobj2 = new Lead(
          LastName = 'LastName1ABCCCCC',
          Company = 'Test Company test1',
          Status = 'New',                           
          Email = 'fran_m_adams_tteesstt@gw00001.com', 
          HasOptedOutOfEmail = false                        
        );
        insert Leadobj2;
        taskObj = new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          WhoID = Leadobj2.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj; 
        Test.StopTest();
    }
    static testMethod void testmethodForLeadCallTask(){
    Test.StartTest();
        Leadobj2 = new Lead(
          LastName = 'LastName1ABCCCCCC',
          Company = 'Test Company test2',
          Status = 'New',                           
          Email = 'fran_m_adams_tteesstt@gw000001.com', 
          HasOptedOutOfEmail = false                        
        );
        insert Leadobj2;
        taskObj = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhoID = Leadobj2.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj; 
        Test.StopTest();
    }
    static testMethod void testmethodForAccountTask(){
    Test.StartTest();
        Account a = [Select Id from Account order by CreatedDate DESC LIMIT 1];
        taskObj = new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          WhatID = a.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj;
        taskObj = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhatID = a.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj;
        taskObj = new Task(
          Subject = 'Task',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Task', 
          WhatID = a.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj; 
        Test.StopTest();
    }
    static testMethod void testmethodForOpptyTask(){
    Test.StartTest();
        Opportunity o = [Select Id from Opportunity order by CreatedDate DESC LIMIT 1];
        taskObj = new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          WhatID = o.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj;
        taskObj = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhatID = o.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj;
        taskObj = new Task(
          Subject = 'Task',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Task', 
          WhatID = o.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj; 
        Test.StopTest();
    }
    static testMethod void testmethodForAccountTask1(){
    Test.StartTest();
        Contact c = [Select Id from Contact order by CreatedDate DESC LIMIT 1];
        taskObj = new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          WhoID = c.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj;
        taskObj = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhoID = c.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj;
        taskObj = new Task(
          Subject = 'Task',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Task', 
          WhoID = c.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj; 
        Test.StopTest();
    }
}