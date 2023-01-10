public class CityStateMapTriggerHandler {

    public static void insertTaxLineItem(List<City_State_Mapping__c> csm,Map<Id,City_State_Mapping__c> oldCsm){
        
        List<City_State_Mapping__c> mapList = new List<City_State_Mapping__c>();
        
        for(City_State_Mapping__c c:csm){
            if(c.Add_tax_for_county__c != oldCsm.get(c.Id).Add_tax_for_county__c || c.Tax__c != oldCsm.get(c.Id).Tax__c){                
                mapList.add(c);
            }
        }
        
        if(mapList.size()>0){           
           TaxLineItemUpdateBatch tli = new TaxLineItemUpdateBatch(mapList);        
           Database.executeBatch(tli); 
        }
                
    }
    
}