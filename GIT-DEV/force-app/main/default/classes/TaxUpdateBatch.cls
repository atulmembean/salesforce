global class TaxUpdateBatch implements Database.Batchable<sObject>{

    public string state;
    
    public TaxUpdateBatch(String state){
        this.state = state;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            query = 'select BillingState,County_Name__c,Tax__c,Pairing_for_tax__c from Account where BillingState = \''+state+'\'';                       
            return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account>scope){
        
        Set<String> stateCountyComb = new Set<String>();        
        List<Account> taxAccounts = new List<Account>();
        
        for(Account sa:scope){
            stateCountyComb.add(sa.BillingState+' '+sa.County_Name__c);
        }
               
        List<City_State_Mapping__c> csm = [select Tax__c,Pairing_for_tax__c,Add_tax_for_county__c from City_State_Mapping__c where Pairing_for_tax__c IN:stateCountyComb];
                
        if(csm.size()>0){
            for(Account a:scope){
                for(City_State_Mapping__c c:csm){
                    if(c.Pairing_for_tax__c == (a.BillingState+' '+a.County_Name__c) && c.Tax__c != a.Tax__c){
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
                       taxAccounts.add(a);
                    }                                        
                }
            }
        }
        
        if(taxAccounts.size()>0){
            update taxAccounts;
        }
        
        Set<Id> taxIds = new Set<Id>();
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        List<QuoteLineItem> newTaxLineItems = new List<QuoteLineItem>();
        List<QuoteLineItem> TaxLineItemsToDelete = new List<QuoteLineItem>();
        Set<String> pricebookIds = new Set<String>();
        
        for(Account ta:taxAccounts){
            taxIds.add(ta.Id);
        }
        
        List<Quote> quoteList = [select Opportunity.Account.Tax__c,PriceBook2Id,(select Product2.Id,Product2.Name,Quantity,TotalPrice,UnitPrice,Subtotal from QuoteLineItems) from Quote where Opportunity.Account.Tax_Exempt__c = False and Opportunity.Account.Tax__c <> Null and Opportunity.AccountId IN:taxIds and Tax_override__c = False];
        
        for(Quote qList:quoteList){
            pricebookIds.add(qList.PriceBook2Id);
        }
        
        List<PricebookEntry> prEntry = [select Id,Product2Id,PriceBook2Id from PricebookEntry where PriceBook2Id IN:pricebookIds and Product2.Name = 'Tax']; 
        
        Map<Id,PricebookEntry> pbEntry = new Map<Id,PricebookEntry>();
        
        for(PricebookEntry p:prEntry){
            pbEntry.put(p.PriceBook2Id,p);
        }
        
        if(quoteList.size()>0){
            
            for(Quote ql:quoteList){
                Decimal sum = 0;                    
                QuoteLineItem qliTax;
                QuoteLineItem ntlItm;
                
                for(QuoteLineItem qli:ql.QuoteLineItems){
                    if(qli.Product2.Name != 'Tax'){
                        sum += qli.Subtotal;                           
                    }
                    else{
                        qliTax = qli;
                    }                         
                }
                
                if(qliTax != Null && sum != 0 && (ql.Opportunity.Account.Tax__c != Null && ql.Opportunity.Account.Tax__c != 0)){
                    qliTax.UnitPrice = sum*ql.Opportunity.Account.Tax__c/100;
                    qliTax.Quantity = 1;
                    
                    qliList.add(qliTax);  
                }
                else if(qliTax == Null && sum != 0 && (ql.Opportunity.Account.Tax__c != Null && ql.Opportunity.Account.Tax__c != 0)){
                    ntlItm = new QuoteLineItem(Quantity = 1,UnitPrice = sum*ql.Opportunity.Account.Tax__c/100,Product2Id = pbEntry.get(ql.Pricebook2Id).Product2Id,QuoteId = ql.Id,PricebookEntryId = pbEntry.get(ql.Pricebook2Id).Id);
                    newTaxLineItems.add(ntlItm);
                }
                else if(qliTax != Null && (sum == 0 || ql.Opportunity.Account.Tax__c == Null || ql.Opportunity.Account.Tax__c == 0)){
                    TaxLineItemsToDelete.add(qliTax);
                }
            }
            
        }
                    
		if(qliList.size()>0)
        update qliList;
        
        if(newTaxLineItems.size()>0)
        insert newTaxLineItems;
        
        if(TaxLineItemsToDelete.size()>0)
        delete TaxLineItemsToDelete;
        
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