global class TaxLineItemUpdateBatch implements Database.Batchable<sObject>{
    
    public List<City_State_Mapping__c> csm;
    public Set<String> taxMap;
    
    public TaxLineItemUpdateBatch(List<City_State_Mapping__c> csmap){
         this.csm = csmap;
    }
        
    global Database.QueryLocator start(Database.BatchableContext BC){            
        string query;
        taxMap = new Set<String>();
        for(City_State_Mapping__c c:csm){
            taxMap.add(c.Pairing_for_tax__c);
           
        } 
        system.debug('@@@'+taxMap);
        
        List<Account> accts = [select Id,Tax__c,Pairing_for_tax__c from Account where Pairing_for_tax__c IN:taxMap];
        system.debug('@@'+accts);
        List<Account> acctsToUpdate = new List<Account>();
        
        for(Account a:accts){
            for(City_State_Mapping__c c:csm){
                if(c.Pairing_for_tax__c == a.Pairing_for_tax__c && c.Tax__c != a.Tax__c){
                    if(c.Add_tax_for_county__c == True){
                        a.Tax__c = c.Tax__c;
                    }
                    else
                        a.Tax__c = Null;
                        
                }
                else if(c.Pairing_for_tax__c == a.Pairing_for_tax__c && c.Add_tax_for_county__c == False){
                    a.Tax__c = Null;                    
                }
                
                if(c.Pairing_for_tax__c == a.Pairing_for_tax__c){
                    acctsToUpdate.add(a);
                }
                
            }
        }
        
        if(acctsToUpdate.size()>0)
        update acctsToUpdate;
                
        query = 'select Opportunity.Account.Tax__c,Opportunity.AccountId,Pricebook2Id,(select Id,Product2.Name,Subtotal from QuoteLineItems) from Quote where Opportunity.Account.Pairing_for_tax__c IN:taxMap and Opportunity.Account.Tax_Exempt__c = False and Status != \'Accepted\' and Tax_override__c = False';                                       
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Quote>scope){
        
        List<QuoteLineItem> newTaxLineItems = new List<QuoteLineItem>();
        List<QuoteLineItem> taxLineItemsToUpdate = new List<QuoteLineItem>();
        List<QuoteLineItem> taxLineItemsToDelete = new List<QuoteLineItem>();
        Set<String> pricebookIds = new Set<String>();
        
        for(Quote qList:scope){
            pricebookIds.add(qList.PriceBook2Id);
        }
        
        List<PricebookEntry> prEntry = [select Id,Product2Id,PriceBook2Id from PricebookEntry where PriceBook2Id IN:pricebookIds and Product2.Name = 'Tax']; 
        
        Map<Id,PricebookEntry> pbEntry = new Map<Id,PricebookEntry>();
        
        for(PricebookEntry p:prEntry){
            pbEntry.put(p.PriceBook2Id,p);
        }
                      
        for(Quote q:scope){
            Decimal sum = 0;                    
            QuoteLineItem qliTax;
            QuoteLineItem ntlItm;
            
            for(QuoteLineItem qli:q.QuoteLineItems){
                if(qli.Product2.Name != 'Tax'){
                    sum += qli.Subtotal;                           
                }
                else{
                    qliTax = qli;
                } 
            }
            
            if(qliTax == Null && sum != 0 && (q.Opportunity.Account.Tax__c != Null && q.Opportunity.Account.Tax__c != 0)){
                ntlItm = new QuoteLineItem(Quantity = 1,UnitPrice = sum*q.Opportunity.Account.Tax__c/100,Product2Id = pbEntry.get(q.Pricebook2Id).Product2Id,QuoteId = q.Id,PricebookEntryId = pbEntry.get(q.Pricebook2Id).Id);
                
                newTaxLineItems.add(ntlItm);
            }
            else if(qliTax != Null && (q.Opportunity.Account.Tax__c == Null || q.Opportunity.Account.Tax__c == 0)){
                taxLineItemsToDelete.add(qliTax);
            }
            else if(qliTax != Null && q.Opportunity.Account.Tax__c > 0){
                qliTax.UnitPrice = sum*q.Opportunity.Account.Tax__c/100;
                taxLineItemsToUpdate.add(qliTax);
            }
        }
                
        if(newTaxLineItems.size()>0)
        insert newTaxLineItems;
        
        if(taxLineItemsToUpdate.size()>0)
        update taxLineItemsToUpdate;    
        
        if(taxLineItemsToDelete.size()>0)
        delete taxLineItemsToDelete;
    }
    
    global void finish(Database.BatchableContext BC){
        
        AsyncApexJob a = [SELECT Id,
                             Status,
                             NumberOfErrors,
                             JobItemsProcessed,
                             TotalJobItems,
                             CompletedDate,
                             ExtendedStatus,
                             ApexClass.name,
                             CreatedBy.Email,
                             CreatedBy.Name
                      FROM AsyncApexJob 
                      WHERE Id =:BC.getJobId()];
        
        system.debug('Status - '+a.Status+' NumberOfErrors - '+a.NumberOfErrors);
        system.debug('ExtendedStatus - '+a.ExtendedStatus);
        
    }
    
}