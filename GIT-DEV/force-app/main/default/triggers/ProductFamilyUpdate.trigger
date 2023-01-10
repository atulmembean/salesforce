trigger ProductFamilyUpdate on QuoteLineItem (before insert,before update) {
  
  for(QuoteLineItem  qli:Trigger.New){
      
       qli.Quote_Product_Family__c=qli.Product_family__c;
      
  }
 
}