/******************
* Created Date 	: 21/12/2017
* Author       	: Pooja K
* Modified Date	: 08/01/2018
* Description  	: This class contains the method to get the counts of pilots,Schools,Customer in different District and the near by schools.
* Version       	: 40
* Test Class Name	: LocateNearbyAccountsTest
******************/ 
public class LeadInlinePageController {
    
    public id currentId {get; set;}
    public integer radius {get; set;}
    public Account acc;
    public Integer totalCountCustomer {get;set;}
    public Integer totalCountPilot {get;set;}
    public AggregateResult[] TotalCustomer;
    public AggregateResult[] TotalPilot;
    
    public AggregateResult[] TotalNumberOfSchool;
    public AggregateResult[] TotalNumberOfCustomer;
    public AggregateResult[] TotalNumberOfPilots;
    public Integer  countTotalNumberOfSchool {get;set;}
    public Integer  countTotalNumberOfCustomer {get;set;}
    public Integer  countTotalNumberOfPilots {get;set;}
    
    // public List<Account> acclist;
    public List<District__c> districtAcclist;
    public Lead leadAcc = new Lead();
    public Contact ContactAcc = new Contact();
    public LeadInlinePageController(ApexPages.StandardController controller){
        currentId = ApexPages.currentPage().getParameters().get('id');
        system.debug('currentId'+currentId);
        if(radius==null){
            radius= Integer.valueOf(System.Label.Miles25);
            //radius = 25;
        }
        if(currentId.getSObjectType().getDescribe().getName()=='Lead'){
            leadAcc = [select id,name,School_Account__c,School_Account__r.GeocodeLatitude__latitude__s,School_Account__r.GeocodeLatitude__Longitude__s from Lead where id =:currentId];
            if(leadAcc.School_Account__c != null && leadAcc.School_Account__r.GeocodeLatitude__latitude__s != null && leadAcc.School_Account__r.GeocodeLatitude__Longitude__s != null){
                getschoolDetails();
            }
        }
        if(currentId.getSObjectType().getDescribe().getName()=='Contact'){
            ContactAcc = [select id,AccountId,Account.GeocodeLatitude__latitude__s,Account.GeocodeLatitude__Longitude__s from contact where id =:currentId];
            if(ContactAcc.AccountId != null && ContactAcc.Account.GeocodeLatitude__latitude__s != null && ContactAcc.Account.GeocodeLatitude__Longitude__s != null){
                getschoolDetails();
            }
        }
    }
    
    public void getschoolDetails(){
        //try{
        if(currentId.getSObjectType().getDescribe().getName()=='Lead'){
            Lead l = new Lead();
            l=[select id,name,school_Account__c from Lead where id =: currentId];
            currentId=l.school_Account__c;
        }else if(currentId.getSobjectType().getDescribe().getName() == 'Contact'){
            Contact c = new Contact();
            c=[select id,name,AccountId from Contact where id =: currentId];
            currentId=c.AccountId;
        }else{
            system.debug('Do nothing');
        }
        Account acc=[select id,GeocodeLatitude__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,District__c from Account where id=:currentId];
        Decimal lat=acc.GeocodeLatitude__latitude__s;
        Decimal longi=acc.GeocodeLatitude__Longitude__s;
        
        /** Get information based on District for Public School **/
        if(acc.District__c != null){
            TotalNumberOfSchool=[Select Count(Account.name) counts from Account where District__c =: acc.District__c ]; 
            countTotalNumberOfSchool=(Integer)TotalNumberOfSchool[0].get('counts');
        }
        TotalNumberOfCustomer=[Select Count(Account.name) counts from Account where district__c =:acc.District__c and Subscription_Status__c ='Customer'];
        countTotalNumberOfCustomer=(Integer)TotalNumberOfCustomer[0].get('counts');
        
        TotalNumberOfPilots=[Select Count(Account.name) counts from Account where district__c =:acc.District__c and Pilot_Status__c = 'Started' ];
        countTotalNumberOfPilots=(Integer)TotalNumberOfPilots[0].get('counts');
        
        /** Ends Here **/
        
        
        
        /*** For getting the Near By School Customer and Pilot based on radius **/
        //totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and  (RecordType.Name='Public School' or RecordType.Name='Private School' )];
        
        //Commented here
        /* acclist=[select id,Pilot_Status__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and  (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') ];
system.debug('size' +acclist.size()+''+ 'acclist'+acclist);
// count from acclist = how many Customers and pilots
Integer countCustomer=0;
Integer countPilot=0;
for(Account a:acclist){
if(a.Subscription_Status__c == 'Customer'){
countCustomer = countCustomer + 1;
system.debug('Customer'+ a.id+ ''+a.name);
}
if(a.Pilot_Status__c == 'Started'){
countPilot += 1;
system.debug('Pilots'+ a.id+ ''+a.name);
}
}
totalCountCustomer = countCustomer;
totalCountPilot = countPilot; */
        
        TotalCustomer =[select Count(Account.name) counts from Account  where Subscription_Status__c='Customer' and  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and  (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District')];
        totalCountCustomer=(Integer)TotalCustomer[0].get('counts');
        
        TotalPilot=[select  Count(Account.name) counts from Account  where Pilot_Status__c='Started' and  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and  (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District')];
        totalCountPilot=(Integer)TotalPilot[0].get('counts');
        
        /** Ends Here **/
        /*}/*catch(Exception e){
            system.debug('Please enter account');
        } */
    }
}