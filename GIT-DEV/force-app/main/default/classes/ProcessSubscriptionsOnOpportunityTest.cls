@isTest
public class ProcessSubscriptionsOnOpportunityTest {
    public static List<Opportunity> oppLst = new List<Opportunity>();
    public static List<Contract> contractLst = new List<Contract>();
    static testMethod void setup(){
        Account acc = new Account();
            acc.Name = 'Test School';
            acc.Low_Grade__c = 'K';
            acc.High_Grade__c = 'T';
             acc.Subscription_Years__c='2018;2019;2020';
            acc.Subscription_Expiry_Month__c = 'August';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('District').getRecordTypeId();
            
            insert acc;
        for(Integer i=0;i<1;i++){
        Opportunity opp = new Opportunity();
            opp.Name = 'PublicOpp-1';
            opp.AccountId = acc.Id;
            opp.StageName = 'Close Won';
            opp.Subscription_Processed__c = true;
            opp.Student_Pay__c = true;
            opp.Start_Pilot__c = true;
            opp.Pilot_Start_Date__c = system.Today();
            opp.Pilot_End_Date__c = system.Today().addDays(45);
            //opp.Subscription_Start_Year__c = '2021';
            //opp.Subscription_End_Year__c = '2022';
            opp.Status_set_date__c = Date.today(); 
            opp.CloseDate = Date.today();
            //Teacher__c=con.Id,
            opp.No_of_Students__c = 10;
            opp.No_of_Teachers__c = 5;
            opp.Amount = 1000;
            //opp.Estimate_Status__c = 'Estimated';          
            opp.Quote_Acknowledgement__c = False;  
            oppLst.add(opp);
         
        }
        insert oppLst;
        for(Integer i=0;i<1;i++){
        Contract CC = New Contract();
        cc.AccountId=acc.Id;
        cc.Subscription_Start_Year__c='2017';
        cc.Subscription_End_Year__c='2018';
        contractLst.add(cc);
        }
        insert contractLst;
        Quote QObj = new Quote();
          QObj.Name = 'Grouped_two';         
          QObj.OpportunityId = oppLst[0].id;
          QObj.Status = 'Draft';
          //QObj.Pricebook2Id = customPriceBookobj.Id;
                    
        insert QObj;
        //Test.startTest();
       // ProcessSubscriptionsOnOpportunity obj = New ProcessSubscriptionsOnOpportunity();
        //obj.execute(null);
        //Test.stopTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'PublicOppNew-1';
        opp.AccountId = acc.Id;
        opp.StageName = 'Closed Won';
        opp.Subscription_Processed__c = true;
        opp.Start_Pilot__c = true;
        opp.Pilot_Start_date__c = system.Today();
        opp.Pilot_End_Date__c =  System.Today().addDays(60);
        opp.Subscription_Processed__c=true;
        opp.Subscription_Start_Year__c='2020';
        opp.Subscription_End_Year__c='2021';
        opp.CloseDate =  System.Today().addDays(15);
        insert opp;
        Teachers_membean_usage__c usage=new Teachers_membean_usage__c();
        usage.Opportunity__c=opp.id;
        usage.Teacher_count__c=10;
        insert usage;
        Test.startTest();
        ProcessSubscriptionsOnOpportunity p = New ProcessSubscriptionsOnOpportunity();
        database.executebatch(p);
        opp.Subscription_Processed__c=true;
        opp.StageName = 'Close Lost';
        acc.Subscription_Years__c=null;
        acc.AnnualRevenue__c = 1000;
        acc.Subscription_Expiry_Month__c='October';
        opp.Lost_Reason__c='Curriculum change';
        opp.Pilot_End_Date__c=opp.Pilot_End_Date__c.addYears(2);
        update acc;
        upsert opp;
        System.debug('In Test Class Opp='+[select id,name,Pilot_End_Date__c from opportunity where id=:opp.id ].get(0));
        database.executebatch(p);
        opp.Pilot_End_Date__c=null;
        opp.Amount= 1000;
        opp.Subscription_Processed__c=true;
        update opp;
        database.executebatch(p);
        delete contractLst;
         database.executebatch(p);
         
         
        opp = new Opportunity();
        opp.Name = 'PublicOppNew-1';
        opp.AccountId = acc.Id;
        opp.StageName = 'Closed Won';
        opp.Subscription_Processed__c = true;
        opp.Subscription_Processed__c=true;
        opp.Subscription_Start_Year__c='2020';
        opp.Subscription_End_Year__c='2021';
        opp.CloseDate =  System.Today().addDays(15);
        insert opp;
        usage=new Teachers_membean_usage__c();
        usage.Opportunity__c=opp.id;
        usage.Teacher_count__c=10;
        insert usage;
 
        p = New ProcessSubscriptionsOnOpportunity();
        database.executebatch(p);
        opp.Subscription_Processed__c=true;
        opp.StageName = 'Close Lost';
        acc.Subscription_Years__c=null;
        acc.AnnualRevenue__c = 1000;
        acc.Subscription_Expiry_Month__c='October';
        opp.Lost_Reason__c='Curriculum change';
        update acc;
        upsert opp;
        System.debug('In Test Class Opp='+[select id,name,Pilot_End_Date__c from opportunity where id=:opp.id ].get(0));
        database.executebatch(p);
        opp.Amount= 1000;
        opp.Subscription_Processed__c=true;
        update opp;
        database.executebatch(p);
        Test.stopTest();
    }

}