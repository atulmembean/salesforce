@isTest(SeeAllData=False)
public class EventTriggerHandlerTest {
    static List<Lead> newLeads;
    static List<Event> newEvents;
    static Lead Lead1;
    static Event Event1;
    public static Opportunity regularOpportunity;
    static Account publicAccount;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
    public Static Account AccountObj;

	@testSetup
    static void setupDataForEventController() {
        newLeads = new List<Lead>();
        newEvents= new List<Event>();
        Lead1 = new Lead(LastName='ABC',Company='Test 1',LeadSource='Online',
                         Website='https://Abc.com',Role__c='Chair',Status='Prospecting');
        newLeads.add(Lead1);
        insert newLeads;
        Event1= new Event(Subject='Testing 1',WhoId=Lead1.id,StartDateTime=System.today(),
                          EndDateTime=System.today()+1);
        newEvents.add(Event1);
        insert newEvents;
        Lead1.Company='Test 2';
        update Lead1;
        
        Event1.Subject='Testing 2';
        update Event1;
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
    
     static testMethod void EvtTriggerTest() {
         setupDataForEventController();
     }
    static testMethod void myUnitTestTaskType(){
        setupDataForEventController();
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
        Contract CC = New Contract();
        cc.AccountId=publicAccount.Id;
        cc.Subscription_Start_Year__c='2017';
        cc.Subscription_End_Year__c='2018';
        insert cc;
        Contact con=new Contact();
        con.lastname='dddd';
        con.AccountId=publicAccount.Id;
        insert con;
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
    
    
         List<Event> evtList = new List<Event>();
         
         Event  evtObj = new Event(
         Subject = 'Calendly-Call',                            
         ActivityDate = Date.Today(), 
         //TaskSubtype = 'Call', 
         Whoid = con.id  	                        
        );
         evtList.add(evtObj);
         Event  evtObj2 = new Event(
         Subject = 'Calendly-Demo',                            
         ActivityDate = Date.Today(), 
         //TaskSubtype = 'Call', 
         Whoid = con.id
         );
         evtList.add(evtobj2);
         Event  evtObj3 = new Event(
         Subject = 'Calendly-Data Review',                            
         ActivityDate = Date.Today(), 
         //TaskSubtype = 'Call', 
         Whoid = con.id
         );
         evtList.add(evtobj3);
         Event  evtObj4 = new Event(
         Subject = 'Calendly-Training',                            
         ActivityDate = Date.Today(), 
         //TaskSubtype = 'Call', 
         Whoid = con.id
         );
         evtList.add(evtobj4);
        
        
        Event  evtObj5 = new Event(
         Subject = 'Calendly-Training',                            
         ActivityDate = Date.Today(), 
         //TaskSubtype = 'Call', 
         Type='Demo',
         Whoid = con.id
         );
         evtList.add(evtobj5);
        
        Event  evtObj6 = new Event(
         Subject = 'Calendly-Training',                            
         ActivityDate = Date.Today(), 
         //TaskSubtype = 'Call', 
         Whoid = Lead1.id
         );
         evtList.add(evtobj6);
        Event  evtObj7 = new Event(
         Subject = 'Calendly-Training',                            
         ActivityDate = Date.Today(), 
         Type = 'Meeting', 
         Whatid = AccountObj.id
         );
         evtList.add(evtobj7);
        
        Event  evtObj8 = new Event(
         Subject = 'Calendly-Training',                            
         ActivityDate = Date.Today(), 
         Type = 'Meeting', 
         Whatid = regularOpportunity.id
         );
         evtList.add(evtobj8);
       
         Event  evtObj9 = new Event(
         Subject = 'Calendly-Training',                            
         ActivityDate = Date.Today(), 
         Type = 'Other', 
         Whatid = regularOpportunity.id
         );
         evtList.add(evtobj9);
       // EventTriggerHandler e1=new EventTriggerHandler();
        EventTriggerHandler.updateEventType(evtList);
        EventTriggerHandler.ChildAccCustomRollup(evtList);

    }
    static testMethod void updateEventFieldTest(){
        setupDataForEventController();
        List<Event> evtList = new List<Event>();
        Lead leadId1 = new Lead();
 		leadId1 = new Lead(LastName='ABC',Company='Test 1',LeadSource='Online',
                         Website='https://Abc.com',Role__c='Chair',Status='Prospecting');
        
        insert leadId1;
       
        Event  evtObj6 = new Event(
            Subject = 'Calendly-Training',                            
            ActivityDate = Date.Today(), 
            //TaskSubtype = 'Call', 
            WhoId = leadId1.id
        );
        system.debug('@@@@@@@@^^^^^^^^^^'+evtObj6.WhoId);
        evtList.add(evtObj6);
       
        EventTriggerHandler.updateEventType(evtList);
        
    }
    static testMethod void testmesthodforLeadStatus(){
        Lead leadId2 = new Lead();
        List<Event> evtList = new List<Event>();
        
        leadId2 = new Lead(LastName='ABCD',Company='Test 1',LeadSource='Online',
                           Website='https://Abc.com',Role__c='Chair',Status='Nurturing');
        insert leadId2;
        Event  evtObj7 = new Event(
            Subject = 'Calendly-Training',                            
            ActivityDate = Date.Today(),
            Type='Demo',
            //TaskSubtype = 'Call', 
            WhoId = leadId2.id
        );
        evtList.add(evtObj7);
        EventTriggerHandler.updateLeadStatus(evtList);
        
    }
}