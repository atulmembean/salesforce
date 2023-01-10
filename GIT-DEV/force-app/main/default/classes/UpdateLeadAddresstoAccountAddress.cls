global class UpdateLeadAddresstoAccountAddress implements Database.Batchable<sObject>, Database.Stateful {

global Integer recordsProcessed = 0;


global database.QueryLocator start(Database.BatchableContext BC) {
    system.debug('Start called');
    return Database.getQueryLocator([Select Id,AddressUpdatedCheck__c,City,Country,State,statecode,Street,PostalCode,School_Account__r.BillingCity,School_Account__r.BillingCountry,School_Account__r.BillingCountryCode,School_Account__r.BillingState,School_Account__r.BillingStreet,School_Account__r.BillingPostalCode  from Lead where Status = 'Prospecting']);
}
global void execute(Database.BatchableContext bc,List<Lead> scope){
 
    system.debug('Entered in Execute');
    List <Lead> leads = new List<Lead>();       
    for(Lead lead : scope)
    {
        try{
            system.debug('scope'+scope);
            system.debug('Entered in for loop');
            lead.City = lead.School_Account__r.BillingCity;
            lead.Country = lead.School_Account__r.BillingCountry;
            system.debug('############'+lead.School_Account__r.BillingState );
            if( lead.School_Account__r.BillingState == null){
                lead.CountryCode = lead.School_Account__r.BillingCountryCode;
            	lead.StateCode= '';
            } else if( lead.School_Account__r.BillingState.length() <= 2) {
            	system.debug('Entered &&&&'+lead.School_Account__r.BillingState);
           	    lead.CountryCode = lead.School_Account__r.BillingCountryCode;
                lead.StateCode= lead.School_Account__r.BillingState;
      	    } else {
    			lead.State= lead.School_Account__r.BillingState;
   		    }   
		//lead.State = lead.School_Account__r.BillingState;
		lead.Street = lead.School_Account__r.BillingStreet;
        lead.PostalCode = lead.School_Account__r.BillingPostalCode;
        lead.AddressUpdatedCheck__c=true;
       // recordsProcessed = recordsProcessed + 1;
		leads.add(lead);
    }Catch(Exception e){
        system.debug('exception'+e);
        system.debug('exception message'+e.getMessage());
        system.debug('exception line number'+e.getLineNumber());
    }
    }
    try{
        database.saveresult[] ds =  Database.update(leads,false);
        for(database.SaveResult d : ds){
            if(d.issuccess()){
                recordsProcessed++;
                system.debug('Records are Processed'+recordsProcessed);
            } else {
                system.debug('The error leads ids are'+d.getId());
                system.debug('errors are'+d.getErrors());
            }
        }
  }catch(Exception e){
        system.debug('exception'+e);
        system.debug('exception message'+e.getMessage());
        system.debug('exception line number'+e.getLineNumber());
    }
     
}
    global void finish(Database.BatchableContext BC){
        system.debug(recordsProcessed);
        //Send an email to the User after your batch completes
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'poojakadam710@gmail.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Apex Job is done');
        mail.setPlainTextBody('Total' +'  '+ recordsProcessed +'  '+ 'Records updated sucessfully');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}