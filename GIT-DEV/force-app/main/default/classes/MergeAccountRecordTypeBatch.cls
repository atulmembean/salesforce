global class MergeAccountRecordTypeBatch implements Database.Batchable<sObject>, System.Schedulable {
    global static void execute(SchedulableContext context){
        Database.executeBatch(new MergeAccountRecordTypeBatch());
    }
    global static Database.QueryLocator start(Database.BatchableContext context){
       String query='select id,name, recordTypeId,recordType.Name from account where recordType.Name in (\'Private School - Customer\',\'Private School - Pilot\',\'Public School - Customer\',\'Public School - Pilot\')';
        return Database.getQueryLocator(query);
        
    }
    global static void execute(Database.BatchableContext context, List<Account> lstAccounts){
        Id recordTypePublicSchool=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Public School').recordTypeId;
        Id recordTypePrivateSchool=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Private School').recordTypeId;
        for(Account ObjAccount:lstAccounts){
            if(objAccount.recordType.name.equalsIgnoreCase('Private School - Customer') || objAccount.recordType.name.equalsIgnoreCase('Private School - Pilot')){
               objAccount.recordTypeId= recordTypePrivateSchool;
            }else{
                objAccount.recordTypeId= recordTypePublicSchool;
            }
        }
        Database.update(lstAccounts,false);
    }
    global static void finish(Database.BatchableContext context){
        
    }
}