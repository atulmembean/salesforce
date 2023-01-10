@isTest(SeeAllData=TRUE)
private class OpportunityTriggerTest {
    
    static Account publicAccount;
    static Account publicAccount1;
    static Account districtAccount;
    static Opportunity regularOpportunity;
    static Opportunity regularOpportunity1;
    static Opportunity regularOpportunity2;
    static Opportunity groupedOpportunity;
    static List<Account> newAccs;
    static List<Opportunity> newOpps;
    static Map<id,Opportunity> newMapOpp;

    static testMethod void setup(){
         
            Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('District').getRecordTypeId();
            
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Estimate',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False  
           );
        
          insert opp;
    }
    
    static testMethod void updateChildOpportunityEstimatedStage(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Estimate',
            Pilot_End_Date__c = system.today(),
            Start_Pilot__c = true,
            Loss_Reason__c = 'No Budget / Lost Funding',
            Lost_Reason__c = 'No Budget / Lost Funding',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
      Id  Renewal = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Opportunity renewalopp = new Opportunity(
            Name = 'PublicOpp-1',
            RecordTypeId =Renewal,
            AccountId = acc.Id,
            StageName = 'Estimate',
            Pilot_End_Date__c = system.today(),
            Start_Pilot__c = true,
            Loss_Reason__c = 'No Budget / Lost Funding',
            Lost_Reason__c = 'No Budget / Lost Funding',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        
         insert renewalopp;
        opp.Parent_Opportunity__c = renewalopp.id;
        Test.startTest();
        upsert opp;
        Map<String,Opportunity> parentOpportunityList = new Map<String,Opportunity>();
        parentOpportunityList.put(renewalopp.id,renewalopp);
       OpportunityTriggerHandler.updateChildOpportunityEstimatedStage (parentOpportunityList);
       OpportunityTriggerHandler.updateChildOpportunityPilotEndDate(parentOpportunityList);
        OpportunityTriggerHandler.updateChildOpportunityPilotStarted(parentOpportunityList);
        OpportunityTriggerHandler.updateChildOpportunityStage(parentOpportunityList);
        Test.stopTest();
        
    }
    
    static testMethod void updateAccountStatusToPilot(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Estimate',
            Pilot_End_Date__c = system.today(),
            Start_Pilot__c = true,
            Loss_Reason__c = 'No Budget / Lost Funding',
            Lost_Reason__c = 'No Budget / Lost Funding',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
      
          Opportunity opp2 = new Opportunity(
            Name = 'PublicOpp-2',
            AccountId = acc.Id,
            StageName = 'Estimate',
            Pilot_End_Date__c = system.today() + 10,
            Start_Pilot__c = true,
            Loss_Reason__c = 'No Budget / Lost Funding',
            Lost_Reason__c = 'No Budget / Lost Funding',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
      
       
        Test.startTest();
       
        insert opp;
         insert opp2;
        List<Opportunity> newOpps = new List<Opportunity>();
        newOpps.add(opp);
        Map<Id, Opportunity> oldOppsMap = new Map<Id, Opportunity>();
        oldOppsMap.put(opp2.id,opp2);
        OpportunityTriggerHandler.updateAccountStatusToPilot(newOpps,oldOppsMap);
        Test.stopTest();
        
    }
    
    static testMethod void UpdateAccountMembeanExpiresOn(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Estimate',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        
          
        Test.startTest();
        opp.Teacher__c =con.Id;
        insert opp;
        acc = [select id,Membean_Expires_On__c from account where id = :acc.id limit 1];
        acc.Membean_Expires_On__c = null;
        update acc;
 
        //Test.stopTest();
        opp = [Select id,Temporary_Membean_Extension_Date__c,account_Membean_Expires_On__c from Opportunity limit 1];
        //Test.startTest();
         opp.Temporary_Membean_Extension_Date__c = date.today()+15  ;
        opp.Teacher__c =replacement_con.Id;
       // opp.account_Membean_Expires_On__c = null;
        update opp;
         Test.stopTest();
    }
    static testMethod void captureMembeanStudentCountWhenOppConvertsFromPilotToCloseWon(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Membean_Student_Count__c = 100;
            acc.Membean_Teacher_Count__c = 10;
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Close Won',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Pilot_End_Date__c = date.today()+10,
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        
          
        Test.startTest();
        insert opp;
    //  acc = [select id,Membean_Expires_On__c from account where id = :acc.id limit 1];
     // acc.Membean_Expires_On__c = null;
    //  update acc;
        Test.stopTest();
       
       
    }
    
    static testMethod void pilotRecordsCreationWhenPilotEndDateOnOppChanges(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Membean_Student_Count__c = 100;
            acc.Membean_Teacher_Count__c = 10;
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Close Won',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Start_Pilot__c = true,
            Type ='Regular',
           //PT_Membean_Student_Count__c = date.today(),
            //Is_Parent__c = true,
            Pilot_End_Date__c = date.today()+10,
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        
          
        Test.startTest();
        insert opp;
    //  acc = [select id,Membean_Expires_On__c from account where id = :acc.id limit 1];
     // acc.Membean_Expires_On__c = null;
    //  update acc;
        opp.Pilot_End_Date__c = date.today()+15;
        
        update opp;
        Test.stopTest();
       
       
    }
    
    static testMethod void updatePilotYearsInAccountWhenOppPilotIsStarted(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Membean_Student_Count__c = 100;
            acc.Membean_Teacher_Count__c = 10;
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Close Won',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Start_Pilot__c = true,
            Type ='Regular',
           //PT_Membean_Student_Count__c = date.today(),
            //Is_Parent__c = true,
            Pilot_Start_Date__c = date.today()-200,
            Pilot_End_Date__c = date.today()+10,
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        
          
        Test.startTest();
        insert opp;
    
      opp.Pilot_End_Date__c = date.today()-150;
        
      update opp;
        Test.stopTest();
       
       
    }
    
    static testMethod void updateClosedDateToTodaysDateifOppisCloseWon(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Membean_Student_Count__c = 100;
            acc.Membean_Teacher_Count__c = 10;
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Close Won',
              Prior_Stage__c = 'Close Lost',
              IsCloseWon__c = false,
              Loss_Reason__c = 'No Budget / Lost Funding',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Start_Pilot__c = true,
            Type ='Regular',
           //PT_Membean_Student_Count__c = date.today(),
            //Is_Parent__c = true,
            Pilot_End_Date__c = date.today()+10,
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        
          
        Test.startTest();
        insert opp;
        /*system.debug('@@opp'+opp);
        opp.Loss_Reason__c = 'No Budget / Lost Funding';
        opp.StageName = 'Close Lost';
        //opp.Loss_Reason__c = 'No Budget / Lost Funding';
     opp.IsCloseLost__c = false;
        system.debug('@@opp before update'+opp);
        update opp;
        system.debug('@@opp after update'+opp);*/
       /*opp.Loss_Reason__c = 'No Budget / Lost Funding'; 
      opp.StageName = 'Cancelled';
        //opp.Loss_Reason__c = 'No Budget / Lost Funding';
       opp.IsCloseLost__c = false;
        update opp;*/
        Test.stopTest();
       
       
    }
    
    /*static testMethod void updateClosedDateToTodaysDateifOppisCloseWon1(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Membean_Student_Count__c = 100;
            acc.Membean_Teacher_Count__c = 10;
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Close Lost',
            Loss_Reason__c = 'No Budget / Lost Funding',
              IsCloseLost__c = false,
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Start_Pilot__c = true,
            Type ='Regular',
           //PT_Membean_Student_Count__c = date.today(),
            //Is_Parent__c = true,
            Pilot_End_Date__c = date.today()+10,
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        
          
        Test.startTest();
        insert opp;
        system.debug('@@opp'+opp);
        opp.StageName = 'Cancelled';
        system.debug('@@opp before'+opp);
        update opp;
        system.debug('@@opp after'+opp);
        Test.stopTest();
       
       
    }*/
    
   /* static testMethod void contactRoleCreationOnOpportunityIfTeacherIsTagged(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Membean_Student_Count__c = 100;
            acc.Membean_Teacher_Count__c = 10;
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Close Lost',
            Loss_Reason__c = 'No Budget / Lost Funding',
              IsCloseLost__c = false,
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Start_Pilot__c = true,
            Type ='Regular',
           //PT_Membean_Student_Count__c = date.today(),
            //Is_Parent__c = true,
            Pilot_End_Date__c = date.today()+10,
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
        OpportunityContactRole oppConRole = new OpportunityContactRole();
                oppConRole.ContactId = con.Id;
                oppConRole.OpportunityId = opp.Id;
                oppConRole.IsPrimary = true;
                oppConRole.Role = 'Influential User';
        
          
        Test.startTest();
        insert opp;
        insert oppConRole;
        Test.stopTest();
       
       
    }*/
    
    //@testSetup 
    static void setupDataForController() {
        newAccs = new List<Account>();
        newOpps = new List<Opportunity>();
        if(AccountService.accRecordTypesByDevName != NULL) {
            
          publicAccount = TestClassUtility.createAccount('PublicAcc-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
           // publicAccount.BillingCountry='United States';
            newAccs.add(publicAccount);
            publicAccount1 = TestClassUtility.createAccount('PublicAcc-2', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_PublicSchool).Id);
            newAccs.add(publicAccount1);
            districtAccount = TestClassUtility.createAccount('Grouped-1', AccountService.accRecordTypesByDevName.get(Constants.RT_Account_District).Id);
            newAccs.add(districtAccount);
            insert newAccs;
        }
        Contract CC = New Contract();
        cc.AccountId=publicAccount.Id;
        cc.Subscription_Start_Year__c= '2017';
        cc.Subscription_End_Year__c= '2018';
        insert cc;
        Contract CC2 = New Contract();
        cc2.AccountId=publicAccount.Id;
        cc2.Subscription_Start_Year__c= '2018';
        cc2.Subscription_End_Year__c= '2019';
        insert cc2;
        Contact con=new Contact();
        con.lastname='dddd';
        con.AccountId=publicAccount.Id;
        insert con;
        Contact con2=new Contact();
        con2.lastname='dddd2';
        con2.AccountId=districtAccount.Id;
        insert con2;
       // regularOpportunity = TestClassUtility.createOpportunity('PublicOpp-1', publicAccount.Id, 'Estimate', '2016', '2017');
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
        newOpps.add(regularOpportunity);
        /* added here*/
        regularOpportunity2 = new Opportunity(
        Name = 'PublicOpp-1',
        AccountId = publicAccount.Id,
        StageName = 'Estimate',
        Subscription_Start_Year__c = '2018',
        Subscription_End_Year__c = '2019',
        CloseDate = Date.today(),
        Teacher__c=con.Id,
        No_of_Students__c = 10,
        No_of_Teachers__c = 5,
        Amount = 1000,
        Subscription__c=cc2.id
       );
        newOpps.add(regularOpportunity2);
        
       // delete cc2;
        
        /* */
       // groupedOpportunity = TestClassUtility.createOpportunity('GroupedOpp-1', districtAccount.Id, 'Pilot', '2016', '2017');
        groupedOpportunity = new opportunity(
        Name = 'objName',
        AccountId = districtAccount.Id,
        StageName = 'Pilot',
        Subscription_Start_Year__c = '2016',
        Subscription_End_Year__c = '2017',
        CloseDate = Date.today(),
        Teacher__c=con2.Id
       );
        newOpps.add(groupedOpportunity);
        insert newOpps;
        
        //Added
        districtAccount.Pilot_Years__c = '';
        Update districtAccount;
        
        districtAccount.Pilot_Years__c = ';2016';
        Update districtAccount;
        
        districtAccount.Pilot_Years__c = '2016;';
        Update districtAccount;
        
        GroupedOpportunityAddSchoolsController.save(groupedOpportunity, new List<Account> {publicAccount});
        
        newMapOpp = new Map<Id,Opportunity>();
        Opportunity opp1 = new Opportunity(
        Name = 'PublicOpp-1',
        AccountId = publicAccount.Id,
        StageName = 'Estimate',
        Subscription_Start_Year__c = '2018',
        Subscription_End_Year__c = '2019',
        CloseDate = Date.today(),
        Teacher__c=con.Id,
        No_of_Students__c = 10,
        No_of_Teachers__c = 5,
        Amount = 1000,
        Subscription__c=cc2.id
        );
        newMapOpp.put(opp1.id, opp1);
       
        upsert newMapOpp.values();
        publicAccount.Pilot_Years__c='2017;2018;2019;2020';
        update publicAccount;
        OpportunityTriggerHandler.updatePilotYearsOnDeletion(newMapOpp);
       
    }

    
    static void initializeTriggerParams() {
        ContractService.runAfterTrigger = true;
        OpportunityService.runBeforeTrigger = true;
        OpportunityService.runAfterTriggerCount = 0;
        OpportunityService.runAfterTrigger = true;
    }
    
  static testMethod void oppTriggerTest() {
        /*setupDataForController();
        
        initializeTriggerParams();
        regularOpportunity.Subscription_End_Year__c = '2019';
        groupedOpportunity.Subscription_End_Year__c = '2019';
        update newOpps;
        
        initializeTriggerParams();
        regularOpportunity.Subscription_End_Year__c = '2018';
        groupedOpportunity.Subscription_End_Year__c = '2017';
        update newOpps;
        
        initializeTriggerParams();
        regularOpportunity.Subscription_End_Year__c = '2017';
        regularOpportunity.StageName = Constants.OPP_STAGE_Won;
        try{
        update regularOpportunity;
        }catch(Exception e){}*/
        /*
        initializeTriggerParams();
        regularOpportunity.No_of_Students__c = 15;
        groupedOpportunity.Subscription_Start_Year__c = '2016';
        groupedOpportunity.Subscription_End_Year__c = '2020';
        groupedOpportunity.StageName = Constants.OPP_STAGE_Won;
        update newOpps;
                
        initializeTriggerParams();
        delete newOpps;*/
    }
    
    static testMethod void oppTriggerTest2() {
        setupDataForController();
        
       initializeTriggerParams();
        publicAccount.Subscription_Years__c='2016;2017';
        
        update publicAccount;
        //added
         publicAccount.Pilot_Years__c='2015';
        update publicAccount;
        
        regularOpportunity.No_of_Students__c = 15;
        groupedOpportunity.Subscription_Start_Year__c = '2017';
        groupedOpportunity.Subscription_End_Year__c = '2020';
        groupedOpportunity.StageName = Constants.OPP_STAGE_Won;
        try{
             update newOpps;
        }catch(Exception e){
            system.debug('Exception' +e);
            system.debug('Exception Message' +e.getMessage());
            system.debug('Exception Line Number' +e.getLineNumber());
        }
        
       
       initializeTriggerParams();
        //delete newOpps;
    }
    static testMethod void opportunityTriggerTestMethod(){
        setupDataForController();
        //OpportunityTriggerHandler.updateChildOppsOnChangeParentOpp(newOpps, newMapOpp);
        OpportunityTriggerHandler.updateSubscriptionOnDelete(newMapOpp);
        OpportunityTriggerHandler.createUpdateSubscription(newMapOpp,newMapOpp);
        
    }
    
    static testMethod void oppTriggerTest1() {
        setupDataForController();
        
        initializeTriggerParams();
        publicAccount.Subscription_Years__c= '2016;2017;2018;2019;2020;2021;2022';//'2015';
        Test.startTest();
        update publicAccount;
        regularOpportunity.Subscription_Start_Year__c = '2018';
        groupedOpportunity.Subscription_Start_Year__c = '2018';
        regularOpportunity.Subscription_End_Year__c = '2019';
        groupedOpportunity.Subscription_End_Year__c = '2019';
        //regularOpportunity.StageName = Constants.OPP_STAGE_Won;
        groupedOpportunity.StageName = Constants.OPP_STAGE_Won;
        try{
             update newOpps;
        }catch(Exception e){
            
        }
       
        
        initializeTriggerParams();
        regularOpportunity.StageName = Constants.OPP_STAGE_PILOT;
        groupedOpportunity.StageName = Constants.OPP_STAGE_PILOT;
        /*regularOpportunity.Subscription_Start_Year__c = '2018';
        groupedOpportunity.Subscription_Start_Year__c = '2018';
        regularOpportunity.Subscription_End_Year__c = '2019';
        groupedOpportunity.Subscription_End_Year__c = '2019';*/
        //update newOpps;
        
        initializeTriggerParams();
        Contract CC = New Contract();
        cc.AccountId=publicAccount.Id;
        cc.Subscription_Start_Year__c='2017';
        cc.Subscription_End_Year__c='2018';
        insert cc;
        
        //Added
        set <id> scont = new Set<id>();
        scont.add(cc.id);
       
        List<Opportunity> oppList=new List<Opportunity>();
        oppList.add(regularOpportunity);
        ContractService.runAfterOnce();
        ContractService.addOpportunityDetails(cc,regularOpportunity);
        OpportunityService.getOpportunityById(regularOpportunity.id);
        OpportunityService.isGroupedOpp(regularOpportunity,publicAccount);
        OpportunityService.createChildOpportunitiesForMultiyear(regularOpportunity,publicAccount);
        OpportunityService.getChildOpportunitiesSchoolsMapByParent(oppList);
        delete newOpps;
       //Added
        delete cc;
        Test.stopTest();
    }
    
    static testMethod void validateStageChangeLogUpdate(){
        
        Opportunity opp = [select Id,Key_Activity_Log__c,Teacher__c,StageName from Opportunity where Subscription_Start_Year__c!=null and Subscription_End_Year__c!=null  order by createdDate DESC limit 1];
        Contact c = [select Id,Name from Contact where Role__c = 'Teacher' LIMIT 1];
        
        opp.Teacher__c = c.Id;
        opp.StageName = 'Prospecting';
        opp.Subscription_Start_Year__c = '2019';
        opp.Subscription_End_Year__c = '2020';
        
        Test.startTest();
        //insert acc;
        update opp; 
        Test.stopTest();
        
        
    }
    
   /* static testMethod void validateAcknowledgementUpdate(){

        Opportunity opp = [select Id,Key_Activity_Log__c from Opportunity  order by createdDate DESC limit 1];
        opp.Key_Activity_Log__c = 'abcd';
        
        Test.startTest();
        update opp;
        Test.stopTest();
        
    } */
    
    static testMethod void TestMethodAccountMembeanExpiresOn()
    {
        Test.startTest();
        /*Opportunity o = [Select Id,Subscription_End_Year__c,AccountId from Opportunity where StageName = 'Close Won' AND Account.RecordType.Name = 'Public School' ORDER BY CreatedDate DESC LIMIT 1];
        Account a = [Select Id,Membean_Expires_On__c,School_ID__c from Account where ID = :o.AccountId];
        a.School_ID__c = 'est';
        a.Membean_Expires_On__c = Null;
        update a;
        o.Temporary_Membean_Extension_Date__c = system.Today();
        update o;*/
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
            acc.School_ID__c = 'cccccc';
            acc.Subscription_Expiry_Month__c = 'August';
            acc.Timezone_UI__c = 'GMT-11:00 American Samoa';
            acc.Pilot_Years__c = '2016;2021';
            acc.Subscription_Years__c = '2016;2017;2018;2019;2020;2021;2022';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').getRecordTypeId();
            acc.Membean_Expires_On__c = date.today();
            insert acc;
        
          Contact con=new Contact();
          con.lastname='testContact1';
          con.AccountId=acc.Id;
          insert con;
         
          Contact replacement_con=new Contact();
          replacement_con.lastname='testContact2';
          replacement_con.AccountId=acc.Id;
          insert replacement_con;
        

                 
          Opportunity opp = new Opportunity(
            Name = 'PublicOpp-1',
            AccountId = acc.Id,
            StageName = 'Estimate',
            Pilot_End_Date__c = system.today(),
            Start_Pilot__c = true,
            Loss_Reason__c = 'No Budget / Lost Funding',
            Lost_Reason__c = 'No Budget / Lost Funding',
            Subscription_Start_Year__c = '2021',
            Subscription_End_Year__c = '2022',
            Status_set_date__c = Date.today(),  
            CloseDate = Date.today(),
            Teacher__c=con.Id,
            No_of_Students__c = 10,
            No_of_Teachers__c = 5,
            Amount = 1000,
            Estimate_Status__c = 'Estimated',           
            Quote_Acknowledgement__c = False,
            Temporary_Membean_Extension_Date__c = date.today()+10  
           );
           insert opp;
        Test.stopTest();
    }
    
    static testMethod void validateCreateUsageFidelityOnPilot(){
        Opportunity opp = [select Id,Key_Activity_Log__c,Pilot_End_Date__c from Opportunity order by createdDate DESC limit 1];
        opp.Start_Pilot__c = TRUE;
        
        opp.Pilot_End_Date__c = system.today();
        Test.startTest();
        update opp;
        Test.stopTest();    
    }
    }