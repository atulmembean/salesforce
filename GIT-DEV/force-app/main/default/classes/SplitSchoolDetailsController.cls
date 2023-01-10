global with sharing class SplitSchoolDetailsController {
    
    public static ID oppId ;
    public ID quoteID  {get;set;}
    public static Opportunity parentOppRecord ;
    
    public SplitSchoolDetailsController(){
        quoteID = ApexPages.currentPage().getParameters().get('id'); 
        Quote quoteObj = [select id,OpportunityId from Quote where id=:quoteID];
        oppId = quoteObj.OpportunityId;
        parentOppRecord = [select name,No_of_Students__c, No_of_Teachers__c,RecordTypeId,Parent_Opportunity__c,Subscription_End_Year__c,Subscription_Start_Year__c
                           from opportunity where id = :oppId];
    }
    
    global static String getParentOpp() {
        return JSON.serialize(parentOppRecord);    
    }    
    
    global static String getChildOpps() {
        if(parentOppRecord.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_Grouped).getRecordTypeId()){
            return JSON.serialize([select id, name, No_of_Students__c, No_of_Teachers__c,AccountID ,Subscription_Start_Year__c,Subscription_End_Year__c
                                   from opportunity where Parent_Opportunity__c = :oppId]);
        }
        else if(parentOppRecord.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_GroupedMultiyear).getRecordTypeId()){
            
            Map<id,Opportunity> mapOfChildOpp = new Map<id,Opportunity>([select id, name, No_of_Students__c,AccountID , No_of_Teachers__c,Subscription_End_Year__c ,Subscription_Start_Year__c
                                                                         from opportunity where Parent_Opportunity__c = :oppId]);
            
            List<Opportunity> oppList = new List<Opportunity>();    
            for(ID opportunityID : mapOfChildOpp.keySet()){
                Opportunity op = mapOfChildOpp.get(opportunityID);
                if((Integer.valueOf(op.Subscription_start_Year__c)== System.Today().year()) && (Integer.valueOf(op.Subscription_End_Year__c) == System.Today().year()+1)){
                    oppList.add(op);
                }
            }
            return JSON.serialize(oppList);     
        }
        return null;        
    }
    /**
* Remoting method to Save Opportunity Records
* @param sobjectName - Salesforce Object - Opportunity records
* Description : below method is used to update Opportunity records. 
*/
    
    @RemoteAction
    global static String SaveOppRecords(List<Opportunity> listOfOpportunity , Opportunity parentOpp){
        
        /*For grouped opportunity, calculate Amount of each entity based on number of studensts and number of teachers */
        Double totalStudentsAmount = 0.0;
        Double totalTeachersAmount = 0.0;
        Double totalDiscountedAmount = 0.0;
        Double calculateStudentsAmount = 0.0;
        Double calculateTeachersAmount = 0.0;
        Double calculateDiscountedAmount = 0.0;
        Double splitAmountRatio = 0.0;
        Double calculatedYears = 1;
        String message; // This will be used to send success or Error message on the page.
        
        List<Opportunity> oppToBeUpdated = new List<Opportunity>();
        Quote quoteobj = new Quote();
        quoteobj = [select id,(Select id,TotalPrice,Product2.Family from QuoteLineItems) from Quote where OpportunityId =: parentOpp.id and status = :Constants.QUOTE_STATUS_ACCEPTED limit 1];
        
        if(quoteobj != null && quoteobj.id != null && quoteobj.QuoteLineItems != null && quoteobj.QuoteLineItems.size()>0){
            for(QuoteLineItem QLI : quoteobj.QuoteLineItems) {
                if(QLI.Product2.Family == Constants.PRODUCT_FAMILY_STUDENT)
                    totalStudentsAmount = QLI.TotalPrice;
                else if(QLI.Product2.Family == Constants.PRODUCT_FAMILY_TEACHER)
                    totalTeachersAmount = QLI.TotalPrice;
                else if(QLI.Product2.Family == Constants.PRODUCT_FAMILY_DISCOUNT) 
                    totalDiscountedAmount = QLI.TotalPrice;
            }
            
            if(parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_Grouped).getRecordTypeId()){    
                for(Opportunity opp : listOfOpportunity){
                    if(totalStudentsAmount != 0.0){
                        calculateStudentsAmount = (opp.No_of_Students__c/parentOpp.No_of_Students__c)*totalStudentsAmount;
                    }
                    if(totalTeachersAmount != 0.0){
                        calculateTeachersAmount = (opp.No_of_Teachers__c/parentOpp.No_of_Teachers__c)*totalTeachersAmount;
                    }
                    
                    if(totalStudentsAmount + totalTeachersAmount != 0.0) {
                        splitAmountRatio = (calculateStudentsAmount + calculateTeachersAmount) / (totalStudentsAmount + totalTeachersAmount);
                        calculateDiscountedAmount = splitAmountRatio * totalDiscountedAmount;
                    }
                    
                    opp.Amount = calculateStudentsAmount + calculateTeachersAmount - Math.abs(calculateDiscountedAmount);
                    
                }
            } else if(parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_GroupedMultiyear).getRecordTypeId()){
                if(parentOpp.Subscription_End_Year__c != null && parentOpp.Subscription_Start_Year__c != null)
                    calculatedYears = Integer.valueOf(parentOpp.Subscription_End_Year__c)-Integer.valueOf(parentOpp.Subscription_Start_Year__c);
                
                totalStudentsAmount = totalStudentsAmount * calculatedYears;
                totalTeachersAmount = totalTeachersAmount * calculatedYears;
                totalDiscountedAmount = totalDiscountedAmount * calculatedYears;
                
                calculatedYears = Integer.valueOf(parentOpp.Subscription_End_Year__c)-Integer.valueOf(parentOpp.Subscription_Start_Year__c);
                
                Map<id,Opportunity> mapOfChildOpp = new Map<id,Opportunity>([select id,AccountId,name, No_of_Students__c, No_of_Teachers__c,Subscription_End_Year__c ,Subscription_Start_Year__c
                                                                             from opportunity where Parent_Opportunity__c = :parentOpp.id]);
                Map<ID,List<Opportunity>> mapOfAccountIDAndOpp = new Map<ID,List<Opportunity>>();
                
                for(ID opportunityID : mapOfChildOpp.keySet()){
                    Opportunity op = mapOfChildOpp.get(opportunityID);
                    List<Opportunity> listOfOpp =  new List<Opportunity>();
                    if(mapOfAccountIDAndOpp.containsKey(op.AccountId)){
                        listOfOpp = mapOfAccountIDAndOpp.get(op.AccountId);
                        listOfOpp.add(op);
                        mapOfAccountIDAndOpp.put(op.AccountId,listOfOpp);
                    }
                    else{
                        listOfOpp.add(op);
                        mapOfAccountIDAndOpp.put(op.AccountId,listOfOpp);
                    }
                }
                
                for(Opportunity childOpp : listOfOpportunity){
                    if(totalStudentsAmount != 0.0){
                        calculateStudentsAmount = (childOpp.No_of_Students__c/parentOpp.No_of_Students__c)*totalStudentsAmount/calculatedYears;
                    }
                    if(totalTeachersAmount != 0.0){
                        calculateTeachersAmount = (childOpp.No_of_Teachers__c/parentOpp.No_of_Teachers__c)*totalTeachersAmount/calculatedYears;
                    }
                    if(totalStudentsAmount + totalTeachersAmount != 0.0) {
                        splitAmountRatio = (calculateStudentsAmount + calculateTeachersAmount) / (totalStudentsAmount + totalTeachersAmount);
                        calculateDiscountedAmount = splitAmountRatio * totalDiscountedAmount;
                    }
                    
                    childOpp.Amount = calculateStudentsAmount + calculateTeachersAmount - Math.abs(calculateDiscountedAmount);
                    
                    //childOpp.Amount = calculateStudentsAmount + calculateTeachersAmount ;
                    
                    if(mapOfAccountIDAndOpp.containskey(childOpp.AccountID)){
                        List<Opportunity> oppList = mapOfAccountIDAndOpp.get(childOpp.AccountID);
                        for(Opportunity oppObj : oppList){
                            oppObj.No_of_Students__c = childOpp.No_of_Students__c;
                            oppObj.No_of_Teachers__c = childOpp.No_of_Teachers__c;
                            oppObj.Amount = childOpp.Amount;
                            oppToBeUpdated.add(oppObj);
                        }
                    }
                }   
            }
            try{
                if(listOfOpportunity!=null && listOfOpportunity.size()>0 && (parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_Grouped).getRecordTypeId()))
                    update listOfOpportunity;
                if(oppToBeUpdated!=null && oppToBeUpdated.size()>0 && (parentOpp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(Constants.RT_Label_Opportunity_GroupedMultiyear).getRecordTypeId()))
                    update oppToBeUpdated;
                message = 'Success';   
            }
            catch(Exception e){
                System.debug('Exception --> '+e);
                message = 'Something went wrong. Please try again.';
            }          
        } 
        return message; 
    }
}