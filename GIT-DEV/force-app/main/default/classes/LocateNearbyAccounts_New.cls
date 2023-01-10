public class LocateNearbyAccounts_New{
    
    public id currentId {get; set;}
    public id currentObjectGoBackId {get; set;}
    public integer radius {get; set;}
    public List<Account> acclist;
    public String selectedItem { get; set; }
    public String selectedRecordType { get; set; }
    public Account acc;
    public String pq;
    public Integer counter=0;
    public Integer listSize=50;
    public Integer totalSize;
    public List<SelectOption> options { get;  set; }
     {
            options = new List<SelectOption>();
            options.add(new SelectOption('None','None'));
            options.add(new SelectOption('All','All'));
            options.add(new SelectOption('Customer','Customer'));
            options.add(new SelectOption('Prior_Customer','Prior Customer'));
            options.add(new SelectOption('Pilot_Schools','Pilot'));
            options.add(new SelectOption('Past_Pilot_Schools','Past Pilots'));
         
    }
    public List<SelectOption> recordoptions { get;  set; }
     {
         recordoptions = new List<SelectOption>();
         recordoptions.add(new SelectOption('All','All'));
         recordoptions.add(new SelectOption('Public','Public'));
         recordoptions.add(new SelectOption('Private','Private')); 
         
    }
    public LocateNearbyAccounts_New(ApexPages.StandardController controller){
        currentId = ApexPages.currentPage().getParameters().get('id');
        currentObjectGoBackId =currentId;
        system.debug('currentId'+currentId);
        if(radius==null){
            radius= Integer.valueOf(System.Label.Miles);
        }
        getschoolDetails();
    }
    public void getschoolDetails(){
        if(currentId.getSObjectType().getDescribe().getName()=='Lead'){
            Lead l = new Lead();
            l=[select id,name,school_Account__c from Lead where id =: currentId];
            currentId=l.school_Account__c;
        }else if(currentId.getSobjectType().getDescribe().getName() == 'Contact'){
            Contact c = new Contact();
            c=[select id,name,AccountId from Contact where id =: currentId];
            currentId=c.AccountId;
        }else{
            system.debug('Is an account');
            currentId = currentId;
        }
       
        Set<String> selectedValue=new Set<String>();
        String regExp = '[]';
        if(selectedItem!=null){
             String xyz=selectedItem;
             pq=xyz.substring(1, xyz.length()-1);
             system.debug('xyz'+pq);
            for(String s:pq.split('[,]')){
                selectedValue.add(s.trim());
            }
            System.debug('selectedValue'+selectedValue);
            System.debug('selectedRecordType'+selectedRecordType);
        }
        Account acc=[select id,GeocodeLatitude__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name from Account where id=:currentId];
        Decimal lat=acc.GeocodeLatitude__latitude__s;
        Decimal longi=acc.GeocodeLatitude__Longitude__s;
       if(selectedRecordType==null){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius];
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,Population__c,No_of_Students__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,RecordType.Name, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi')   limit :listSize offset :counter];
                 System.debug('acclist'+acclist+'totalSize'+totalSize);
            }  else if(pq=='Customer' && selectedRecordType=='All' ) {
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Customer'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Customer' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi')  limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(pq=='Prior_Customer' && selectedRecordType=='All'){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Expired'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Expired' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(pq=='Pilot_Schools' && selectedRecordType=='All'){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Started'];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Started' limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(pq=='Past_Pilot_Schools' && selectedRecordType=='All'){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Ended' and Subscription_Years__c= null /*ORDER BY LatestPilotEndDate1__c DESC*/];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Ended' and Subscription_Years__c=null ORDER BY LatestPilotEndDate1__c DESC limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Public' && selectedValue.contains('Past_Pilot_Schools')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Ended' and Subscription_Years__c=null and RecordType.Name='Public School'];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Ended' and Subscription_Years__c=null and RecordType.Name='Public School' ORDER BY LatestPilotEndDate1__c DESC limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }//else if(pq=='Past_Pilot_Schools' && selectedRecordType=='Private'){
                else if(selectedRecordType=='Private' && selectedValue.contains('Past_Pilot_Schools')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Ended' and Subscription_Years__c=null and RecordType.Name='Private School'];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Ended'and RecordType.Name='Private School' and Subscription_Years__c=null ORDER BY LatestPilotEndDate1__c DESC limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }
        /*else if(pq=='Public'){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School'];
                
                 acclist=[select id,Pilot_Status__c, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School' limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
        }else if(pq=='Private'){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Private School'];
                
                 acclist=[select id,Pilot_Status__c, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Private School' limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
        }*/else if(selectedRecordType=='All' && selectedValue.contains('Pilot_Schools')&& selectedValue.contains('Prior_Customer')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Expired') and  (RecordType.Name='Public School' or RecordType.Name='Private School' )];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Expired') and  (RecordType.Name='Public School' or RecordType.Name='Private School') Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }
            else if(selectedRecordType=='All' && selectedValue.contains('Customer')&& selectedValue.contains('Pilot_Schools')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Pilot_Status__c='Started') and  (RecordType.Name='Public School' or RecordType.Name='Private School')];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Pilot_Status__c='Started') and  (RecordType.Name='Public School' or RecordType.Name='Private School') Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }
            else if(selectedRecordType=='Public' && selectedValue.contains('Customer')&& selectedValue.contains('Prior_Customer')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Subscription_Status__c='Expired') and  RecordType.Name='Public School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Subscription_Status__c='Expired') and  RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Public' && selectedValue.contains('Customer')&& selectedValue.contains('Pilot_Schools')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Pilot_Status__c='Started') and  RecordType.Name='Public School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Pilot_Status__c='Started') and  RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Private' && selectedValue.contains('Customer')&& selectedValue.contains('Pilot_Schools')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Pilot_Status__c='Started') and  RecordType.Name='Private School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Pilot_Status__c='Started') and  RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }
            else if(selectedRecordType=='Public' && selectedValue.contains('Pilot_Schools')&& selectedValue.contains('Prior_Customer')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Expired') and  RecordType.Name='Public School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Expired') and  RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Private' && selectedValue.contains('Pilot_Schools')&& selectedValue.contains('Prior_Customer')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Expired') and  RecordType.Name='Private School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Expired') and  RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Private' && selectedValue.contains('Pilot_Schools')&& selectedValue.contains('Customer')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Customer') and  RecordType.Name='Private School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Subscription_Status__c='Customer') and  RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }
            else if(selectedRecordType=='Private' && selectedValue.contains('Customer')&& selectedValue.contains('Prior_Customer')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Subscription_Status__c='Expired') and  RecordType.Name='Private School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Subscription_Status__c='Customer' or Subscription_Status__c='Expired') and  RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='All'  && selectedValue.contains('Prior_Customer') && selectedValue.contains('Customer')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius  and (RecordType.Name='Private School' or RecordType.Name='Public School' ) and (Subscription_Status__c='Customer' or Subscription_Status__c='Expired')];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (RecordType.Name='Private School' or RecordType.Name='Public School' ) and (Subscription_Status__c='Customer' or Subscription_Status__c='Expired') Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Public' && selectedValue.contains('Customer')){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Customer'  and  RecordType.Name='Public School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name, name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Customer' and  RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Private' && selectedValue.contains('Customer')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Customer' and RecordType.Name='Private School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Subscription_Status__c,Subscription_Years__c from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Customer' and RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Public'  && selectedValue.contains('Prior_Customer')){
                   totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Expired' and   RecordType.Name='Public School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Expired' and  RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            } else if( selectedRecordType=='Private' && selectedValue.contains('Prior_Customer')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Expired' and RecordType.Name='Private School'];
                
                acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Subscription_Status__c='Expired' and RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            } else if(selectedRecordType=='Public'  && selectedValue.contains('Pilot_Schools')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Started' and RecordType.Name='Public School'];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Started' and  RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            } else if(selectedRecordType=='Private'  && selectedValue.contains('Pilot_Schools')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Started' and RecordType.Name='Private School'];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and Pilot_Status__c='Started' and  RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            } else if(selectedRecordType=='All'  && selectedValue.contains('Pilot_Schools') && selectedValue.contains('Past_Pilot_Schools')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Pilot_Status__c='Ended') and (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District')];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Pilot_Status__c='Ended') and  (RecordType.Name='Public School' or RecordType.Name='Private School'or RecordType.Name='District') Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Public'  && selectedValue.contains('Pilot_Schools') && selectedValue.contains('Past_Pilot_Schools')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Pilot_Status__c='Ended') and RecordType.Name='Public School'];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Pilot_Status__c='Ended') and  RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            } else if(selectedRecordType=='Private'  && selectedValue.contains('Pilot_Schools') && selectedValue.contains('Past_Pilot_Schools')){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Pilot_Status__c='Ended') and RecordType.Name='Private School'];
                
                 acclist=[select id,Pilot_Status__c,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,RecordType.Name,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s, name,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (Pilot_Status__c='Started' or Pilot_Status__c='Ended') and  RecordType.Name='Private School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }
            /* else if(selectedValue.contains('Public')&&selectedValue.contains('Private')) {
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (RecordType.Name='Public School' or RecordType.Name='Private School')];
                
                 acclist=[select id, name,Pilot_Status__c,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (RecordType.Name='Public School' or  RecordType.Name='Private School') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
             }*/
            else if(selectedRecordType=='Public'  && pq=='ALL' ){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' )];
                
                 acclist=[select id,RecordType.Name, name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' ) Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            } else if(selectedRecordType=='Public' && pq=='None'){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School'];
                
                 acclist=[select id,RecordType.Name, name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School' Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            } else if(selectedRecordType=='Private' && pq=='None'){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and  RecordType.Name='Private School'];
                
                 acclist=[select id,RecordType.Name, name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and   RecordType.Name='Private School'  Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi')limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Private' && pq=='All'){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and  RecordType.Name='Private School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started')];
                
                 acclist=[select id, name,RecordType.Name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and   RecordType.Name='Private School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' ) Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='All' && pq=='All'){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and ( RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started')];
                
                 acclist=[select id, name,RecordType.Name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' )  Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi')limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='All' && pq=='None'){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and ( RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District')];
                
                 acclist=[select id, name,RecordType.Name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi')limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='All'){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and ( RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started')];
                
                 acclist=[select id, name,RecordType.Name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' )  Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi')limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Private'){
                totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and  RecordType.Name='Private School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started')];
                
                 acclist=[select id, name,RecordType.Name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and   RecordType.Name='Private School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' ) Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }else if(selectedRecordType=='Public'){
                 totalSize=[select count() from Account where Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' )];
                
                 acclist=[select id,RecordType.Name, name,Pilot_Years__c,Catholic_School__c,No_of_Students__c,Population__c,Pilot_Status__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s,Subscription_Status__c,Subscription_Years__c, GeocodeLatitude__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account  where  Distance(GeocodeLatitude__c,GEOLOCATION(:acc.GeocodeLatitude__latitude__s, :acc.GeocodeLatitude__Longitude__s), 'mi') < :radius and RecordType.Name='Public School' and (Subscription_Status__c='Expired' or Subscription_Status__c='Customer' or Pilot_Status__c='Started' ) Order By Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi),'mi') limit :listSize offset :counter];
                 System.debug('acclist'+acclist);
            }
        accWrapper=new List<myAccountWrapper>();
        for(Account accs:acclist){
            myAccountWrapper wrap=new myAccountWrapper();
            wrap.accountName=accs.id;
            wrap.recordtype=accs.RecordType.Name; 
            wrap.catholicSchool = accs.Catholic_School__c;
            wrap.subscriptionStatus=accs.Subscription_Status__c;
            wrap.subscriptionYears=accs.Subscription_Years__c;
            wrap.subcriptionsPurchased = Integer.valueOf(accs.No_of_Students__c);
            wrap.population =  Integer.valueOf(accs.Population__c);
            wrap.pilotStatus=accs.Pilot_Status__c;
            wrap.pilotYears=accs.Pilot_Years__c;
            wrap.billingState=accs.BillingState;
            wrap.billingCountry=accs.BillingCountry;
            //wrap.distance=Distance(GEOLOCATION(accs.GeocodeLatitude__latitude__s,acc.GeocodeLatitude__Longitude__s),GEOLOCATION(acc.GeocodeLatitude__latitude__s, acc.GeocodeLatitude__Longitude__s), 'mi');
            Location loc1 = Location.newInstance(accs.GeocodeLatitude__latitude__s,accs.GeocodeLatitude__Longitude__s);
            Location loc2 = Location.newInstance(acc.GeocodeLatitude__latitude__s,acc.GeocodeLatitude__Longitude__s);
            wrap.distance=Math.round(Location.getDistance(loc1,loc2, 'mi'));
            wrap.Name=accs.Name;
            accWrapper.add(wrap);
            system.debug('wrap.distance--'+wrap.distance);
        }
        
        
    }
    public PageReference goBack(){
        PageReference pg=new PageReference('/'+currentObjectGoBackId);
        pg.setRedirect(true);
        return pg;
    }
    
     public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }
   public PageReference Previous() { //user clicked previous button
      counter -= listSize;
       getschoolDetails();
      return null;
   } 
   public PageReference Next() { //user clicked next button
      counter += listSize;
       getschoolDetails();
      return null;
   }
   public PageReference End() { //user clicked end
      counter = totalSize - math.mod(totalSize, listSize);
       getschoolDetails();
      return null;
   } 
    public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }
   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + listSize < totalSize) return false; else return true;
   }
   
   public Integer getTotal_size() {
      return totalSize;
   } 
    
   public Integer getPageNumber() {
      return counter/listSize + 1;
   }
    
   public Integer getTotalPages() {
      if (math.mod(totalSize, listSize) > 0) {
         return totalSize/listSize + 1;
      } else {
         return (totalSize/listSize);
      }
   }
    
    public List<myAccountWrapper> accWrapper {get; set;}

    public class myAccountWrapper{
        public String Name {get;set;}
        public String accountName {get;set;}
        public String recordtype {get;set;}
        public Boolean catholicSchool {get;set;}
        public String subscriptionStatus {get;set;}
        public String subscriptionYears {get;set;}
        public decimal subcriptionsPurchased {get;set;}
        public Integer population {get;set;}
        public String pilotStatus {get;set;}
        public String pilotYears {get;set;}
        public String billingState {get;set;}
        public String billingCountry {get;set;}
        public Decimal distance {get;set;}
        public myAccountWrapper(){
            
        }
    }

}