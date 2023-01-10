/**
* Class Type     	: Service Class
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : All the Contract specific SOQLs and Operations are written in this class.
**/
public class ContractService {
    /*
	//Static variable to stop Before Trigger recursion
    public static boolean runBeforeTrigger = true;
    public static boolean runBeforeOnce() {
        if(runBeforeTrigger) {
            runBeforeTrigger = false;
            return true;
        } else {
            return runBeforeTrigger;
        }
    }*/
    
    //Static variable to stop After Trigger recursion
    public static boolean runAfterTrigger = true;
    public static boolean runAfterOnce() {
        if(runAfterTrigger) {
            runAfterTrigger = false;
            return true;
        } else {
            return runAfterTrigger;
        }
    }
    
    public static List<Contract> getSubscriptionsByIds(Set<Id> conIds) {
        if(conIds == NULL || conIds.isEmpty()) {
            return null;
        }
        return [Select Id, Name, Subscription_Start_Year__c, Subscription_End_Year__c, AccountId, No_of_Students__c, No_of_Teachers__c, Amount__c from Contract where Id in :conIds];
    }
    
    public static List<Contract> getSubscriptionsByAccountIds(Set<Id> accIds) {
        if(accIds == NULL || accIds.isEmpty()) {
            return null;
        }
        return [Select Id, Name, Subscription_Start_Year__c, Subscription_End_Year__c, AccountId, No_of_Students__c, No_of_Teachers__c, Amount__c from Contract where AccountId in :accIds];
    }
    
    public static Contract createContract(Opportunity opp) {
        if(opp == null)
            return null;
        
        Contract newCon = new Contract();
        newCon.AccountId = opp.AccountId;
        newCon.Subscription_Start_Year__c = opp.Subscription_Start_Year__c;
        newCon.Subscription_End_Year__c = opp.Subscription_End_Year__c;
        newCon.No_of_Students__c = opp.No_of_Students__c;
        newCon.No_of_Teachers__c = opp.No_of_Teachers__c;
        newCon.Amount__c = opp.Amount;
        system.debug('newCon is here &&&&&&'+newCon);
        return newCon;
    }
    
    public static Contract addOpportunityDetails(Contract con, Opportunity opp) {
       if(con != null && opp != null) {
           system.debug('Entered here'+opp);
           system.debug('Entered here'+con);
           system.debug('opp.Subscription__c value is addOpportunityDetails'+opp.Subscription__c );
            con.No_of_Students__c = con.No_of_Students__c != NULL ? con.No_of_Students__c : 0;
            con.No_of_Teachers__c = con.No_of_Teachers__c != NULL ? con.No_of_Teachers__c : 0;
            con.Amount__c = con.Amount__c != NULL ? con.Amount__c : 0;
            
            if(opp.No_of_Students__c != null && opp.Subscription__c == null)
                con.No_of_Students__c += opp.No_of_Students__c;
            if(opp.No_of_Teachers__c != null && opp.Subscription__c == null)
                con.No_of_Teachers__c += opp.No_of_Teachers__c;
            if(opp.Amount != null && opp.Subscription__c == null)
                con.Amount__c += opp.Amount;
        }
        return con; 
    }
    
    public static Contract removeOpportunityDetails(Contract con, Opportunity opp) {
        if(con != null && opp != null) {
           system.debug('Entered here removeOpportunityDetails'+opp);
           system.debug('Entered here removeOpportunityDetails'+con);
           system.debug('opp.Subscription__c value is removeOpportunityDetails'+opp.Subscription__c );
            if(con.No_of_Students__c != null && opp.No_of_Students__c != null && opp.Subscription__c != null){
             system.debug('entered in if students'+con.No_of_Students__c);
                con.No_of_Students__c -= opp.No_of_Students__c;
            }
            if(con.No_of_Teachers__c != null && opp.No_of_Teachers__c != null && opp.Subscription__c != null)
                con.No_of_Teachers__c -= opp.No_of_Teachers__c;
            if(con.Amount__c != null && opp.Amount != null && opp.Subscription__c != null)
                con.Amount__c -= opp.Amount;   
        }
        return con;
    }
}