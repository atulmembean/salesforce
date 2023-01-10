/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TaskTriggerTest {

    public Static Lead Leadobj;
    public Static Lead Leadobj2;
    public Static Account AccountObj;
    public Static Account AccountObj1;
    public Static Task taskObj ;
    public Static Task taskObj2;
    public static Opportunity regularOpportunity;
    static Account publicAccount;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
@testSetup
    static void setup1(){
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
    }
    @testSetup 
    static void setupDataForQuoteAndTask(){
        newAccs = new List<Account>();
        if(AccountService.accRecordTypesByDevName != NULL) {
            
          publicAccount = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
           // publicAccount.BillingCountry='United States';
            newAccs.add(publicAccount);
        }
        insert newAccs;
        Contract CC = New Contract();
        cc.AccountId=publicAccount.Id;
        cc.Subscription_Start_Year__c='2017';
        cc.Subscription_End_Year__c='2018';
        insert cc;
        Contact con=new Contact();
        con.lastname='dddd';
        con.AccountId=publicAccount.Id;
        insert con;
        AccountObj = new Account(
          Name = 'Test Account',    
          IsActive__c = true,                           
          Type_of_School__c = 'Middle School',                         
          Category__c = 'School',                                     
          Low_Grade__c = '6',                                          
          High_Grade__c = '8',                                        
          Source__c = 'District - Email Blast',                        
          NCES_School_ID__c = '130255000000',                         
          Title_1_School_Wide__c = false,                              
          State_School_ID__c = '4058',                                 
          Title_1_School__c = false,                                  
          Population__c = 1172,                                       
          County_Name__c = 'GWINNETT COUNTY',                          
          Tuition__c = 0,                                              
          Student_Teacher_Ratio__c = 14,                              
          Charter__c = false,                                          
          Locale_Code__c = 21,                                         
          Magnet__c = false,                                           
          Free_Lunch__c = 0,                                           
          Zip_4_digit__c = '4223',                                    
          Teacher_Count__c = 81,                                       
          Used_before_2013__c = false,
          Academic_End_Month__c='July',  
          Students__c = 1172     
        );
        insert AccountObj;
       /* Leadobj = new Lead(
          LastName = 'LastName1',
          Company = 'Test Company',
          //School_Account__c = AccountObj.id ,       
          Status = 'New',                           
          Email = 'fran_m_adams@gwinnett123.com', 
          HasOptedOutOfEmail = false                        
        );
        insert Leadobj;
        taskObj = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhoID = Leadobj.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj; */
        
       taskObj2 = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          WhatID = AccountObj.id,                       
          Priority = 'Normal',                           
          Status = 'Completed'                          
        );
        insert taskObj2;
        taskobj2.Priority='High';
        update taskobj2;
         regularOpportunity = new Opportunity(
        Name = 'PublicOpp-1',
        AccountId = publicAccount.Id,
        StageName = 'Estimate',
        Subscription_Start_Year__c = '2016',
        Subscription_End_Year__c = '2017',
        CloseDate = Date.today(),
        Teacher__c=con.Id,
        No_of_Students__c = 10,
        No_of_Teachers__c = 5,
        Amount = 1000,
        Subscription__c=cc.id
       );
        insert regularOpportunity;
  }
    static testMethod void myUnitTest() {
        Contact con=new Contact();
        con.LastName='Test';
        insert con;
         Event  taskObj = new Event(
          Subject = 'Calendly-Call',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id,
          	StartDateTime=system.Date.today(),
             EndDateTime=system.Date.today()
          //Priority = 'Normal',                           
          //Status = 'Completed'                          
        );
        insert taskObj;
        
    }
   
    static testMethod void myUnitTest23() {
        Contact con=new Contact();
        con.LastName='Test';
        insert con;
         Event  taskObj = new Event(
          Subject = 'Calendly-Demo',                            
          ActivityDate = system.Date.today().addDays(-1), 
          //TaskSubtype = 'Call', 
          Whoid = con.id,
          	StartDateTime=system.Date.today(),
             EndDateTime=system.Date.today()
          //Priority = 'Normal',                           
          //Status = 'Completed'                          
        );
        insert taskObj;
        UpcomingEventsDashboard uu=new UpcomingEventsDashboard();
    }
    static testMethod void testlead(){
        setup1();
    }
     static testMethod void myUnitTestTaskType() {
         setupDataForQuoteAndTask();
         List<Task> tskList = new List<Task>();
          Contact con=new Contact();
        con.LastName='Test';
        insert con;
         Task  taskObj = new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id  	                        
        );
         tskList.add(taskobj);
         Task  taskObj2 = new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj2);
         /*Task  taskObj3 = new Task(
          Subject = 'Swag',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj3);
         Task  taskObj4 = new Task(
          Subject = 'Card',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj4); */
        /* Task  taskObj3 = new Task(
          Subject = 'Demo',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj3);
         Task  taskObj4 = new Task(
          Subject = 'Pilot',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj4);
         Task  taskObj5 = new Task(
          Subject = 'Send',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj5);
         Task  taskObj6 = new Task(
          Subject = 'Meeting',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj6);
          Task  taskObj7 = new Task(
          Subject = 'Sent',                            
          ActivityDate = Date.Today(), 
          //TaskSubtype = 'Call', 
          Whoid = con.id
             );
          tskList.add(taskobj7); */
         contact c1 = new Contact();
         c1.LastName='Testing 1';
         insert c1;
         Task  taskObj3= new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          Whoid = c1.id       
        );
         tskList.add(taskObj3);
         AccountObj1 = new Account(
          Name = 'Test Account1',    
          IsActive__c = true,                           
          Type_of_School__c = 'Middle School',                         
          Category__c = 'School',                                     
          Low_Grade__c = '6',                                          
          High_Grade__c = '8',                                        
          Source__c = 'District - Email Blast',                        
          NCES_School_ID__c = '130255000000',                         
          Title_1_School_Wide__c = false,                              
          State_School_ID__c = '4058',                                 
          Title_1_School__c = false,                                  
          Population__c = 1172,                                       
          County_Name__c = 'GWINNETT COUNTY',                          
          Tuition__c = 0,                                              
          Student_Teacher_Ratio__c = 14,                              
          Charter__c = false,                                          
          Locale_Code__c = 21,                                         
          Magnet__c = false,                                           
          Free_Lunch__c = 0,                                           
          Zip_4_digit__c = '4223',                                    
          Teacher_Count__c = 81,                                       
          Used_before_2013__c = false,
          Academic_End_Month__c='July',  
          Students__c = 1172     
        );
        insert AccountObj1;
         Task  taskObj4= new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          Whatid = AccountObj1.id       
        );
         tskList.add(taskObj4);
         Task  taskObj5= new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          Whatid = AccountObj1.id       
        );
         insert taskObj5;
       //  taskObj5.WhatId=AccountObj.id ;
		 taskObj5.ActivityDate=Date.Today()+1;
         update taskObj5;
         tskList.add(taskObj5);
         
          Task  taskObj6= new Task(
          Subject = 'Email',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Email', 
          Whatid = regularOpportunity.id       
        );
         insert taskObj6;
         tskList.add(taskObj6);
         Task  taskObj7= new Task(
          Subject = 'Call',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Call', 
          Whatid = regularOpportunity.id       
        );
         insert taskObj7;
         tskList.add(taskObj7);
        
         
         
         Task  taskObj8= new Task(
          Subject = 'Task',                            
          ActivityDate = Date.Today(), 
          TaskSubtype = 'Task', 
          Whatid = regularOpportunity.id       
        );
         insert taskObj8;
         taskObj8.Subject='Changed';
         update taskObj8;
         tskList.add(taskObj8);
 		
         TaskTriggerHandler t1=new TaskTriggerHandler();
            t1.taskTypeUpdate(tskList);
         TaskTriggerHandler.ChildAccCustomRollup(tskList);
                
    }
    static testMethod void testmethodForLeadstatus() {
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

}