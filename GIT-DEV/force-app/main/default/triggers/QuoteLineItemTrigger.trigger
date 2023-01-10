trigger QuoteLineItemTrigger on QuoteLineItem (before insert,before update, after insert, after update, before delete) {
  system.debug('Trigger.New in the quoteline item **'+Trigger.New);
    if(Trigger.IsBefore && Trigger.IsInsert){

        for(QuoteLineItem  qli:Trigger.New){
            system.debug('In before Insert'+Trigger.New);            
            qli.Quote_Product_Family__c=qli.Product_family__c;
       /*     Quote qq= new Quote();
            qq=[select id,TotalPrice_NewCustom__c,TotalPrice_Custom__c from Quote where id=:qli.QuoteId];
            system.debug('qq'+qq);
            qli.Quote_Product_Family__c=qli.Product_family__c;
            qli.TotalPrice_QuotelineCustom__c=qli.TotalPrice;
            qq.TotalPrice_NewCustom__c=qli.TotalPrice;
            system.debug('qq.TotalPrice_NewCustom__c **'+qq.TotalPrice_NewCustom__c); */
            // update qq;
            //TEXT(Product2.Family)
        }
    }
    if(Trigger.IsBefore && Trigger.IsUpdate){
        for(QuoteLineItem  qli:Trigger.New){
            system.debug('In before Update'+Trigger.New);            
            qli.Quote_Product_Family__c=qli.Product_family__c;
          //  qli.TotalPrice_QuotelineCustom__c=qli.TotalPrice;
            //TEXT(Product2.Family)
        }
    }
    
 /*  if(Trigger.IsAfter && Trigger.IsInsert){
        QuoteTriggerHandler quoteTriggerHandlerObj =  new QuoteTriggerHandler();
        quoteTriggerHandlerObj.run();
       system.debug('This is in after insert logic');
      
    }*/
    if(Trigger.isAfter && Trigger.isUpdate){
        QuoteLineItemTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }
    If(Trigger.isBefore && Trigger.isDelete){
        QuoteLIneItemTriggerHandler.handleDelete(Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        QuoteLIneItemTriggerHandler.handleAfterInsert(Trigger.newMap);
    }
}