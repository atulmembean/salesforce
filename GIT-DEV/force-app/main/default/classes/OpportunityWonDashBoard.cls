/******************
 * Created Date 	: 14/07/2017
 * Author       	: Sanjuna
 * Modified Date	: 02/01/2018
 * Modified By		: Pooja K
 * Description  	: This class contains the method to get the counts of School which are New, Renewal, Returning.
 					  Also to get the opportunity won this week, opportunity won today,gauge report and customers by state report.
 * Version       	: 40
 * Test Class Name	: OpportunityWonDashBoardTest
******************/ 
public class OpportunityWonDashBoard {
   public List<Opportunity> oppListtoday {get; set;}
   public List<Opportunity> oppwonList {get; set;}
    
    
   //public List<Account> customersByState {get; set;}
   public AggregateResult[] totalResult;
   public Integer contdd {get; set;}
   public Integer newCount  {get; set;}
   public Integer renewalCount  {get; set;}
   public Integer returningCount  {get; set;} 
   public Integer totalCountCustomers{get;set;}
   public Integer countOppListToday{get;set;}
   public Integer countOppwonList{get;set;}
    
   public Integer countAccount1{get;set;}
   public Integer NewSchoolCount{get;set;} 
   public Integer RenewalSchoolCount{get;set;} 
   public Integer ReturningSchoolCount{get;set;} 
    
   public AggregateResult[] newResult;
   public AggregateResult[] renewlResult ;
   public AggregateResult[] returningResult ;
   public AggregateResult[] aggregateOppListToday ;   
   public AggregateResult[] aggregateOppwonList;
    
   public AggregateResult[] NewSchoolResult;
   public AggregateResult[] RenewalSchoolResult;
   public AggregateResult[] ReturningSchoolResult;
    
   //public AggregateResult[] customersByState;
  /* public AggregateResult[] customersByState {
        get {
            return [Select BillingState billingstate,Count(id) counts from account where (RecordType.Name != 'Agency' And RecordType.Name != 'District') and BillingCountry = 'United States' and Subscription_Years__c includes ('2017') group by BillingState order by Count(id)  desc limit 10];
        }
    } */
    public AggregateResult[] customersByState{get;set;}
    
    
   public OpportunityWonDashBoard(){
        recordCount();  
    }
    public List<Data> getGaugeData(){
        Integer thisMonth = date.Today().month();
        string thisYear;
        if(thisMonth >= Integer.valueOf(System.Label.Month8)){
       		thisYear = string.valueof(date.Today().year());
        }else if(thisMonth >=Integer.valueOf(System.Label.Month1) && thisMonth <=Integer.valueOf(System.Label.Month7)){
            thisYear = string.valueof(date.Today().year()-1);
        }
     //   string subscriptionYear=String.value([select id,account.Subscription_Years__c from opportunity where account.Subscription_Years__c includes ('2017')]);
       // AggregateResult agregatedInvoices = [SELECT SUM(Amount) total, COUNT(Name) numberOfInvoices FROM Opportunity WHERE StageName='Close Won' and account.Subscription_Years__c includes(:thisYear) ];
        AggregateResult agregatedInvoices = [SELECT  COUNT(Name) numberOfInvoices FROM Account WHERE account.Subscription_Years__c includes(:thisYear) And (RecordType.name!='Agency' And RecordType.name!='District') AND Subscription_Status__c ='Customer'];
        //System.debug(agregatedInvoices.get('numberOfInvoices')); 
        //System.debug(agregatedInvoices.get('total')); 
        List<Data> data = new List<Data>();
        //data.add(new Data((String)agregatedInvoices.get('numberOfInvoices'),  (Integer)agregatedInvoices.get('total')));
       // data.add(new Data(Integer.valueOf(agregatedInvoices.get('numberOfInvoices')) + Invoices, Integer.valueOf(agregatedInvoices.get(total))));
    //   data.add(new Data((decimal)agregatedInvoices.get('numberOfInvoices'),  (decimal)agregatedInvoices.get('total')));
        data.add(new Data((decimal)agregatedInvoices.get('numberOfInvoices')));
        system.debug('the data *********'+data);
        return data;
    }
    /*******************************************Added on 22-02-2018 ******************************/
    public Integer getGaugeData2(){
        try{
        Integer thisMonth = date.Today().month();
        string thisYear;
       
        Integer countAccount=0;
        List<Account> acc1 = new List<Account>();
        acc1 = [select id,name,billingcountry,Subscription_Years__c,Academic_End_Month__c,Batch_Academic_month__c from account where Subscription_Years__c != null and Subscription_Status__c='Customer'];
        system.debug(acc1);
            for(account a: acc1){
                if(a.Academic_End_Month__c != null){
                    if(integer.Valueof(a.Batch_Academic_month__c) <= 7){
                        if(a.Subscription_Years__c.contains(string.valueof(date.Today().year()-1))){
                            countAccount+=1;
                        }                    
                    }
                    if(integer.Valueof(a.Batch_Academic_month__c) > 7 && integer.Valueof(a.Batch_Academic_month__c)<=12 ){
                        if(a.Subscription_Years__c.contains(string.valueof(date.Today().year()))){
                            countAccount+=1;
                        }                    
                    }
                }
             }
           /* for(account a: acc1){
            Country_Settings__c countList = new Country_Settings__c();
            system.debug(CountrySettingsService.getCountrySettingsByCountry(a.BillingCountry));
            countList= CountrySettingsService.getCountrySettingsByCountry(a.BillingCountry);
            if(countList != null){
            if(countList.Academic_Year_Start_Month_Num__c <=3){
                if(a.Subscription_Years__c.contains(string.valueof(date.Today().year()))){
                    countAccount+=1;
                }
            }
            if(countList.Academic_Year_Start_Month_Num__c >=4){
                if(thisMonth < countList.Academic_Year_Start_Month_Num__c){
                    system.debug('test here'+a.Subscription_Years__c +'year is' +string.valueof(date.Today().year()-1));
                    if(a.Subscription_Years__c.contains(string.valueof(date.Today().year()-1))){
                    countAccount+=1;
                    }else{
                        system.debug('Do nothing');
                    }
                }else{
                    if(a.Subscription_Years__c.contains(string.valueof(date.Today().year()))){
                    countAccount+=1;
                    }else{
                        System.debug('Do nothing');
                    }
                }
            }
          } 
        } */
        countAccount1=countAccount;
       
        system.debug('countAccount&&&&&&&&&&&'+countAccount);
        return countAccount;
        }catch(Exception e){
            system.debug('Exception' +e);
            system.debug('Exception mess'+e.getMessage());
            system.debug('Exception Line'+e.getLineNumber());
            return null;
        }
    }
    
    /*************************Ends***********************************/
    
     //Wrapper class for the data
     public class Data {
        public Decimal name { get; set; }
       // public Decimal data1 { get; set; }
        public Data(Decimal name){
            this.name = name;
            //this.data1 = data1;
        }
    }
    
   
    public  void recordCount(){
        Integer thisMonth = date.Today().month();
        String thisYear;
        if(thisMonth >= Integer.valueOf(System.Label.Month8)){
       		thisYear = string.valueof(date.Today().year());
        }else if(thisMonth >=Integer.valueOf(System.Label.Month1) && thisMonth <=Integer.valueOf(System.Label.Month7)){
            thisYear = string.valueof(date.Today().year()-1);
        }
        string thisYearPlusNext = String.valueOf(Integer.valueof(thisYear)+1);
        string thisYearPlusNextNext = String.valueOf(Integer.valueof(thisYear)+2);
		string thisYearPlusNextNextNext = String.valueOf(Integer.valueof(thisYear)+3);
		string thisYearPlusNextNextNextNext = String.valueOf(Integer.valueof(thisYear)+4);
        string previousYear = String.valueOf(Integer.valueof(thisYear)-1);
        string yearBeforePreviousYear = String.valueOf(Integer.valueof(thisYear)-2);
        string yearBeforePreviousYearYear = String.valueOf(Integer.valueof(thisYear)-3);
        string yearBeforePreviousYearYearYear = String.valueOf(Integer.valueof(thisYear)-4);
        string yearBeforePreviousYearYearYearYear = String.valueOf(Integer.valueof(thisYear)-5);
        //thisYear = string.valueof(date.Today().year());
   /*     string thisYearPlusNext = string.valueof(date.Today().year()+1);
        string thisYearPlusNextNext = string.valueof(date.Today().year()+2);
		string thisYearPlusNextNextNext = string.valueof(date.Today().year()+3);
		string thisYearPlusNextNextNextNext = string.valueof(date.Today().year()+4);
        string previousYear = string.valueof(date.Today().year()-1);
        string yearBeforePreviousYear = string.valueof(date.Today().year()-2);
        string yearBeforePreviousYearYear = string.valueof(date.Today().year()-3);
        string yearBeforePreviousYearYearYear = string.valueof(date.Today().year()-4);
        string yearBeforePreviousYearYearYearYear = string.valueof(date.Today().year()-5); */
        
        oppListtoday=[Select id,Total_Users__c,Amount,Account.owner.name,Account.name from Opportunity where CloseDate=:system.Date.today() and stagename='Close Won' order by CloseDate desc];
        date Startdate=system.Date.today().toStartofWeek();
        date EndDate=Startdate+7;
        
        aggregateOppListToday=[Select Count(Account.name) counts from Opportunity where CloseDate=:system.Date.today()  and stagename='Close Won' ];
        countOppListToday=(Integer)aggregateOppListToday[0].get('counts');
        
        oppwonList=[Select id,Total_Users__c,Amount,Account.owner.name,Account.name from Opportunity where CloseDate>= :startDate and  CloseDate<= :endDate and stagename='Close Won' order by CloseDate desc];
        
        aggregateOppwonList=[Select Count(Account.name) counts from Opportunity where CloseDate>= :startDate and  CloseDate<= :endDate  and stagename='Close Won' ];
        countOppwonList=(Integer)aggregateOppwonList[0].get('counts');
        
        //system.debug('oppwonList'+oppwonList);
       // totalResult=[Select Count(id) counts from Opportunity where Account.Subscription_Status__c='Customer' ];
        totalResult=[Select Count(id) counts from Opportunity where (Subscription_Start_Year__c =:thisYear or Subscription_Start_Year__c =:thisYearPlusNext ) and StageName='Close Won' and Type!='Grouped'];
        contdd=(Integer)totalResult[0].get('counts');
        //system.debug('contdd'+contdd);
        //newResult=[Select Count(id) counts from Opportunity where Account.Subscription_Status__c='Customer' and recordtype.name='New' ];
        newResult=[Select Count(id) counts from Opportunity where Subscription_Start_Year__c =:thisYear and StageName='Close Won' and Type!='Grouped' and Type!='Grouped Multiyear' and recordtype.name='New' ];
        newCount=(Integer)newResult[0].get('counts');
        //renewlResult=[Select Count(id) counts from Opportunity where Account.Subscription_Status__c='Customer' and recordtype.name='Renewal'];
        renewlResult=[Select Count(id) counts from Opportunity where Subscription_Start_Year__c =:thisYear and StageName='Close Won' and Type!='Grouped' and Type!='Grouped Multiyear' and recordtype.name='Renewal'];
        renewalCount=(Integer)renewlResult[0].get('counts');
        //returningResult=[Select Count(id) counts  from Opportunity where Account.Subscription_Status__c='Customer' and recordtype.name='Returning'];
        returningResult=[Select Count(id) counts  from Opportunity where Subscription_Start_Year__c =:thisYear and StageName='Close Won' and Type!='Grouped' and Type!='Grouped Multiyear' and recordtype.name='Returning'];
        returningCount=(Integer)returningResult[0].get('counts');
        totalCountCustomers=newCount+renewalCount+returningCount;
        customersByState=[Select BillingState billingstate,Count(id) counts from account where (RecordType.Name != 'Agency' And RecordType.Name != 'District') and BillingCountry = 'United States' and Subscription_Years__c includes ('2017') group by BillingState order by Count(id)  desc limit 10];
    	
        set<id> setNewSchoolId = new Set<id>();
        list<Account> listNewSchool=new List<Account>([Select id,Subscription_Years__c  from Account where 
                                                     (Subscription_Years__c = :thisYear
                                                     or (Subscription_Years__c includes(:thisYear) 
                                                     and Subscription_Years__c includes (:thisYearPlusNext,:thisYearPlusNextNext,:thisYearPlusNextNextNext,:thisYearPlusNextNextNextNext)
                                                     and Subscription_Years__c excludes (:previousYear,:yearBeforePreviousYear)) ) 
                                                     and recordType.name != 'Agency' and recordType.name!='District']);
        for(Account lstSchool: listNewSchool){
          //  if(!(lstSchool.Subscription_Years__c.contains(';'))){
            	setNewSchoolId.add(lstSchool.id);
          // }
        }
        NewSchoolResult=[Select Count(id) counts from Account where id in :setNewSchoolId];
        NewSchoolCount=(Integer)NewSchoolResult[0].get('counts');
        
        RenewalSchoolResult=[Select Count(id) counts from Account where Subscription_Years__c includes (:thisYear) and Subscription_Years__c includes (:previousYear) and recordType.name != 'Agency' and recordType.name!='District'];
        RenewalSchoolCount=(Integer)RenewalSchoolResult[0].get('counts');
        
        ReturningSchoolResult=[Select Count(id) counts from Account
                              where Subscription_Years__c includes (:thisYear) 
                              and Subscription_Years__c includes (:yearBeforePreviousYear,:yearBeforePreviousYearYear,:yearBeforePreviousYearYearYear,:yearBeforePreviousYearYearYearYear) 
                              and Subscription_Years__c excludes(:previousYear)
                              and recordType.name != 'Agency' 
                              and recordType.name!='District'];
        ReturningSchoolCount=(Integer)ReturningSchoolResult[0].get('counts');
         
    }

}