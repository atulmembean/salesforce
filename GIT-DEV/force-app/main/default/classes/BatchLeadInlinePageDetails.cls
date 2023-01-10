/**
* Batch Class   	: BatchLeadInlinePageDetails
* Created by        : ETMarlabs (27-12-2017)
* Version           : 41.0
* Description       : batch class 'BatchLeadInlinePageDetails' to update the fields on lead for reporting purpose
*					: Captures the values shown in the leadInlinePage on the lead fields
**/
global class BatchLeadInlinePageDetails implements Database.Batchable<sObject>{
    global String query; 
    
    global database.querylocator start(Database.BatchableContext bc){
        query= 'Select Id,name,School_Account__c from Lead where School_Account__c != null AND (School_Account__r.RecordType.Name = \'Public School\' or School_Account__r.RecordType.Name = \'Private School\') and School_Account__r.GeocodeLatitude__latitude__s != null and School_Account__r.GeocodeLatitude__Longitude__s != null and IsConverted = false';
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext bc, List<Lead> leadListAll){
        system.debug('first $$$$$$$$$'+leadListAll);
        Integer totalCountCustomer25;
        Integer totalCountPilot25;
        AggregateResult[] TotalCustomer25;
        AggregateResult[] TotalPilot25;
        
        Integer totalCountCustomer50;
        Integer totalCountPilot50;
        AggregateResult[] TotalCustomer50;
        AggregateResult[] TotalPilot50;
        
        AggregateResult[] TotalNumberOfSchool;
        AggregateResult[] TotalNumberOfCustomer;
        AggregateResult[] TotalNumberOfPilots;
        Integer  countTotalNumberOfSchool;
        Integer  countTotalNumberOfCustomer;
        Integer  countTotalNumberOfPilots;
        
        List<Lead> leadList = new List<Lead>();
        Map<Id,Id> LeadAccMap = new Map<Id,Id>();
        for (Lead s : leadListAll){
            LeadAccMap.put(s.Id,s.School_Account__c);
        }
        system.debug('LeadAccMap%%%%%%%%%%'+LeadAccMap);
        Map<Id, Account> acc = new Map<Id,Account>([select id,District__c,Name,Subscription_Status__c,Pilot_Status__c,GeocodeLatitude__c,GeocodeLatitude__latitude__s,GeocodeLatitude__Longitude__s from Account where id in:LeadAccMap.Values()]);   
      
        Map <ID,Lead> finalLeadMapUpdate = new Map<Id,Lead>();
        List<Lead> leadListfinal = new List<Lead>();
        integer radius1 =25;
        integer radius2 =50;
        system.debug('Keyset is:'+LeadAccMap.keySet());
        for(Id l:LeadAccMap.keySet()){
            system.debug('Lead came in'+LeadAccMap.get(l));
            Decimal lat=acc.get(LeadAccMap.get(l)).GeocodeLatitude__latitude__s;
            Decimal longi=acc.get(LeadAccMap.get(l)).GeocodeLatitude__Longitude__s;
            system.debug(acc.get(LeadAccMap.get(l)));
            Account a = new Account();
            a=acc.get(LeadAccMap.get(l));
            system.debug('a is here' +a);
            
            Lead leadRec = new Lead();
            if(a.District__c != null){
                TotalNumberOfSchool=[Select Count(Account.name) counts from Account where District__c =: a.District__c ]; 
                countTotalNumberOfSchool=(Integer)TotalNumberOfSchool[0].get('counts');
                leadRec.Total_Schools_in_District__c=countTotalNumberOfSchool;
                
                TotalNumberOfCustomer=[Select Count(Account.name) counts from Account where District__c =:a.District__c and Subscription_Status__c ='Customer'];
                countTotalNumberOfCustomer=(Integer)TotalNumberOfCustomer[0].get('counts');
                leadRec.Customer_in_District__c=countTotalNumberOfCustomer;
                
                TotalNumberOfPilots=[Select Count(Account.name) counts from Account where District__c =:a.District__c and Pilot_Status__c = 'Started' ];
                countTotalNumberOfPilots=(Integer)TotalNumberOfPilots[0].get('counts');
                leadRec.Pilots_in_District__c=countTotalNumberOfPilots;
            }
            TotalCustomer25 =[select Count(Account.name) counts from Account  where Subscription_Status__c='Customer' and  Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi), 'mi') < :radius1 and  (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') ];
            totalCountCustomer25=(Integer)TotalCustomer25[0].get('counts');
            leadRec.Total_Customers_25_Miles__c=totalCountCustomer25;
            
            TotalPilot25=[select  Count(Account.name) counts from Account  where Pilot_Status__c='Started' and  Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi), 'mi') < :radius1 and  (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District')];
            totalCountPilot25=(Integer)TotalPilot25[0].get('counts');
            leadRec.Total_Pilots_25_miles__c=totalCountPilot25;
            
            TotalCustomer50 =[select Count(Account.name) counts from Account  where  Subscription_Status__c='Customer' and  Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi), 'mi') < :radius2 and  (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District') ];
            totalCountCustomer50=(Integer)TotalCustomer50[0].get('counts');
            leadRec.Total_Customers_50_miles__c=totalCountCustomer50;
            
            TotalPilot50=[select  Count(Account.name) counts from Account  where Pilot_Status__c='Started' and  Distance(GeocodeLatitude__c,GEOLOCATION(:lat,:longi), 'mi') < :radius2 and  (RecordType.Name='Public School' or RecordType.Name='Private School' or RecordType.Name='District')];
            totalCountPilot50=(Integer)TotalPilot50[0].get('counts');
            leadRec.Total_Pilots_50_Miles__c=totalCountPilot50;
            
            leadRec.Id = l;
            finalLeadMapUpdate.put(l,leadRec);
        }
        system.debug('finalLeadMapUpdate **********'+finalLeadMapUpdate);
      
        try{
            update finalLeadMapUpdate.values();
        }catch(Exception e){
            system.debug('exception is'+e);
            system.debug('exception mess'+e.getMessage());
            system.debug('exception line'+e.getLineNumber());
        }
    }
    global void finish(Database.BatchableContext bc){
        
    }
    
}