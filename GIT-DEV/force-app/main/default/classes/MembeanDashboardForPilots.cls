/******************
 * Created Date 	: 11/09/2017
 * Author       	: Pooja K
 * Modified Date	: 04/01/2018
 * Description  	: This class contains the method to get the counts of pilots in different state and list of pilots in the present week.
 * Version       	: 40
 * Test Class Name	: OpportunityWonDashBoardTest
******************/ 
public class MembeanDashboardForPilots {
   public List<opportunity> pilotsThisWeek{get;set;}
   public List<Opportunity> pilotsExpiringThisWeek{get;set;}
   public List<Opportunity> pilotsExpiringThisWeek2{get;set;}
    
   public Integer countTotalActivePilots{get;set;}
   public Integer countTotalExpiredPilots{get;set;}
   public Integer countTotalConvertedPilots{get;set;}
   public Integer countTotalConvertedPilots2{get;set;}
   public Integer countPilotsThisWeek{get;set;}
   public Integer countTotalLostPilots{get;set;}
   public Integer countPilotsExpiringThisWeek{get;set;}
   public Integer countPilotsExpiringThisWeek2{get;set;}
   public Integer countTotalExpiredMinusLostCountPilots{get;set;}

   public AggregateResult[] TotalActivePilots;
   public AggregateResult[] TotalExpiredPilots;
   public AggregateResult[] TotalConvertedPilots;
   public AggregateResult[] TotalConvertedPilots2;
   public AggregateResult[] TotalLostPilots;
   public AggregateResult[] aggregatePilotsThisWeek;
   public AggregateResult[] aggregatePilotsExpiringThisWeek;
   public AggregateResult[] aggregatePilotsExpiringThisWeek2;
   
    public MembeanDashboardForPilots(){
        recordCount();    
    }
       
    public  void recordCount(){
       // string thisYear = string.valueof(date.Today().year());
       // string thisYearPlusNext = string.valueof(date.Today().year()+1);
        Integer thisMonth = date.Today().month();
        string thisYear;
        if(thisMonth >= Integer.valueOf(System.Label.Month8)){
       		thisYear = string.valueof(date.Today().year());
        }else if(thisMonth >=Integer.valueOf(System.Label.Month1) && thisMonth <=Integer.valueOf(System.Label.Month7)){
            thisYear = string.valueof(date.Today().year()-1);
        }
        Date todayDate= system.Today();
       // Date August1st=Date.newInstance(date.Today().year(),08,1);
       Date August1st=Date.newInstance(Integer.valueOf(thisYear),08,1);
        //TotalActivePilots=[Select Count(Account.name) counts from Opportunity where Pilot_End_Date__c >: todayDate]; //Previous Query
        //countTotalActivePilots=(Integer)TotalActivePilots[0].get('counts');
        
        TotalActivePilots=[Select Count(Account.name) counts from Opportunity where Stagename !='Close Lost' and Pilot_End_Date__c >:todayDate and Account.Subscription_Status__c != 'Customer' and Account.RecordType.Name != 'District']; //changed query based on report for active pilots
        countTotalActivePilots=(Integer)TotalActivePilots[0].get('counts');
        
        TotalExpiredPilots=[Select Count(Account.name) counts from Opportunity where Pilot_End_Date__c>=:August1st and Pilot_End_Date__c<:todayDate and Account.Subscription_Status__c != 'Customer'];
        countTotalExpiredPilots=(Integer)TotalExpiredPilots[0].get('counts');
       
        TotalConvertedPilots=[Select Count(Account.name) counts from Opportunity where StageName='Close Won' and Pilot_End_Date__c>:August1st];
        countTotalConvertedPilots=(Integer)TotalConvertedPilots[0].get('counts');
        
      //  TotalConvertedPilots2=[Select Count(Account.name) counts from Opportunity where (StageName='Close Won' OR StageName ='Cancelled') and Pilot_End_Date__c>:August1st and Account.Subscription_Years__c includes (:thisYear)];
      //  countTotalConvertedPilots2=(Integer)TotalConvertedPilots2[0].get('counts');
        
        TotalConvertedPilots2=[Select Count(Account.name) counts from Opportunity where Pilot_End_Date__c >:August1st and Account.Subscription_Years__c includes (:thisYear) and Account.Subscription_Status__c = 'Customer' and Account.RecordType.Name != 'District'];
        countTotalConvertedPilots2=(Integer)TotalConvertedPilots2[0].get('counts');
        
        TotalLostPilots=[Select Count(Account.name) counts from Opportunity where StageName='Close Lost' and Pilot_End_Date__c>=:August1st and Pilot_End_Date__c<:todayDate and Account.Subscription_Status__c != 'Customer'];
        countTotalLostPilots=(Integer)TotalLostPilots[0].get('counts');
                
        countTotalExpiredMinusLostCountPilots = countTotalExpiredPilots - countTotalLostPilots; //TotalExpiredPilots-TotalLostPilots
            
        date Startdate=system.Date.today().toStartofWeek();
        date EndDate=Startdate+7;
                       
        pilotsThisWeek=[Select id,Total_Users__c,Amount,Account.owner.name,Account.name from Opportunity where Pilot_Start_Date__c>= :startDate and Pilot_Start_Date__c<= :endDate order by Pilot_Start_Date__c desc];
        
        aggregatePilotsThisWeek=[Select Count(Account.name) counts from Opportunity where Pilot_Start_Date__c>= :startDate and  Pilot_Start_Date__c<= :endDate];
        countPilotsThisWeek=(Integer)aggregatePilotsThisWeek[0].get('counts'); 
        
        pilotsExpiringThisWeek=[Select id,Total_Users__c,Amount,Account.owner.name,Account.name,Pilot_Start_Date__c,Pilot_End_Date__c,stagename,Estimate_Status__c,Account.Membean_Student_Count__c,Account.recordtype.name from Opportunity where Pilot_End_Date__c >=:startDate and Pilot_End_Date__c <=:endDate and (stagename != 'Close Won' and stagename != 'Close Lost') and Account.recordtype.name != 'District' and Account.recordtype.name != 'Agency'];
		
        aggregatePilotsExpiringThisWeek=[Select Count(Account.name) counts from Opportunity where Pilot_End_Date__c >=:startDate and Pilot_End_Date__c <=:endDate and (stagename != 'Close Won' and stagename != 'Close Lost') and Account.recordtype.name != 'District' and Account.recordtype.name != 'Agency'];
        countPilotsExpiringThisWeek=(Integer)aggregatePilotsExpiringThisWeek[0].get('counts');
        
        
        pilotsExpiringThisWeek2=[Select id,Total_Users__c,Amount,Account.owner.name,Account.name,Pilot_Start_Date__c,Pilot_End_Date__c,stagename,Estimate_Status__c,Account.Membean_Student_Count__c,Account.recordtype.name from Opportunity where Pilot_End_Date__c >=:startDate and Pilot_End_Date__c <=:endDate and (stagename != 'Close Won' and stagename != 'Close Lost' and stagename!='Cancelled') and Account.recordtype.name != 'District' and Account.recordtype.name != 'Agency'];
		
        aggregatePilotsExpiringThisWeek2=[Select Count(Account.name) counts from Opportunity where Pilot_End_Date__c >=:startDate and Pilot_End_Date__c <=:endDate and (stagename != 'Close Won' and stagename != 'Close Lost' and stagename!='Cancelled') and Account.recordtype.name != 'District' and Account.recordtype.name != 'Agency'];
        countPilotsExpiringThisWeek2=(Integer)aggregatePilotsExpiringThisWeek2[0].get('counts');
    }  
}