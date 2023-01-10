public class OpportunityContactRoleTriggerHandler {

    public static void UpdateOppActivityLog(List<OpportunityContactRole> oppContactRole){
                
        List<String> contactIds = new List<String>{};
        List<String> oppIds = new List<String>{};    
        
        for(OpportunityContactRole ocr:oppContactRole){
            
            contactIds.add(ocr.ContactId);
            oppIds.add(ocr.OpportunityId);
            
        }
        
        List<Contact> contacts = getContacts(contactIds);
        List<Opportunity> opportunities = getOpportunities(oppIds);
        
        for(OpportunityContactRole oc:oppContactRole){
            String contactName = '';
        	String prependData = '';
            
            for(Contact c:contacts){
                if(oc.ContactId == c.Id){
                    contactName = c.Name;
                }
            }
            
            for(Opportunity o:opportunities){
                if(oc.OpportunityId == o.Id){
                    prependData = '-> {'+oc.CreatedDate.format('YYYY-MM-dd HH:mm:ss')+'}: New Contact Role: Added a new contact role {'+contactName+'} {'+oc.Role+'}.';
                    o.Key_Activity_Log__c = prependData + '\n' + o.Key_Activity_Log__c;
                }
            }
			            
        }
        
        update opportunities;
        
    }
    
    public static List<Contact> getContacts(List<String> contactIdList){
        
        List<Contact> contacts = [Select Name from Contact where Id IN:contactIdList];
        
        return contacts;
    }
    
    public static List<Opportunity> getOpportunities(List<String> oppIds){
        
        List<Opportunity> keyActivityLog = [select Key_Activity_Log__c from Opportunity where Id IN:oppIds];
        
        return keyActivityLog;
    }
    
}