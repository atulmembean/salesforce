public class CustomLookUpGenericController {
	 @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName,Id AccountID) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        String accId = AccountID;
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name,AccountId from ' +ObjectName + ' where Name LIKE: searchKey and AccountId =:accId order by createdDate DESC';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}