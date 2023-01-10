/**
 * @Author: Karthik
 * @Date: 30/06/2020
 * @Description:  A trigger Handler class need to be used in ProductFamilyUpdate trigger on QuoteLIneItem
 * */
public class QuoteLIneItemTriggerHandler {
    /*
     * @Author: Karthik
     * @Date: 30/06/2020
     * @Param : oldMap : The map of QuoteLineItem which will consist old values for record
     * @Param : newMap: The  Map of QuoteLineItem which will consist new Values for record
     * @Description: this method will be called on after update trigger of QuoteLineItem 
     * */
    public static void handleAfterUpdate(Map<Id,QuoteLineItem>oldMap, Map<Id,QuoteLineItem> newMap){
        //Creating a new Map of changedRecords which will hold only those QuoteLineItem records for which either quantity, unitPrice or totalPrice is changed.
        //We will update corresponding InvoiceLineItem records for these records only
        Map<Id,QuoteLineItem>changedRecords=new Map<Id,QuoteLineItem>();
        //Iterating over OldMap of QuoteLineItem records
        for(Id key:oldMap.keySet()){
            //Checking whether any of quantity, unitPrice, totalPrice of changed for each records of Map
            if(oldMap.get(key).quantity!=newMap.get(key).quantity || oldMap.get(key).UnitPrice!=newMap.get(key).UnitPrice || oldMap.get(key).TotalPrice!=newMap.get(key).TotalPrice){
                //If change found, adding particular record to Map
                changedRecords.put(key,newMap.get(key));
            }
        }
        if(!changedRecords.isEmpty()){
            //Fetching Invoice Line Item records corresponding to CHANGED quoteLineItem records
            Map<Id,Invoice_Line_Item__C>mapInvoiceLIneItem=new Map<Id,Invoice_Line_Item__c>([select id,name,Quantity__c,Amount__c,Unit_Price__c,Quote_Line_Item__C from Invoice_Line_Item__c where Quote_LIne_Item__c in :changedRecords.keySet()]);    
            //Iterating over InvoiceLineItem Map
            for(Invoice_Line_Item__c objInvLineItem:mapInvoiceLIneItem.values()){
                //Fetching QuoteLineItem record from Map corresponding to Invoice Line Item Record
                QuoteLineItem objQuoteLIne=changedRecords.get(objInvLIneItem.Quote_Line_Item__C);
                //Updating values on Invoice Line Item Record
                objInvLineItem.Quantity__c=ObjQuoteLine.Quantity;
                objInvLineItem.Unit_Price__c=objQuoteLIne.UnitPrice;
                objInvLineItem.Amount__c=ObjQuoteLine.Quantity*objQuoteLIne.UnitPrice;
                
            }
            //Updating InvoiceLIneItem records
            update mapInvoiceLIneItem.values();
        }
        
    }
    public static void handleDelete(Map<Id,QuoteLineItem>deletedMap){
        Map<Id,Invoice_line_item__c>invoiceLineMap=new Map<Id,Invoice_LIne_Item__c>([select id,name from Invoice_Line_Item__C where quote_Line_Item__c in : deletedMap.keySet()]);
        delete invoiceLineMap.values();
        
    }
    public static void handleAfterInsert(Map<Id,QuoteLineItem>newMap){
        Set<Id>quoteIds=new Set<Id>();
        for(QuoteLIneItem objLineItem:newMap.values()){
            quoteIds.add(objLineItem.quoteId);
        }
        Map<Id,Invoice__C> quoteVsInvoiceMap=new Map<Id,Invoice__c>();
        for(Invoice__c objInvoice:[select id,name,Quote__c from Invoice__c where Quote__c in : quoteIds]){
            quoteVsInvoiceMap.put(objInvoice.Quote__c, objInvoice);
        }
        List<Invoice_line_Item__c>lstInvLineItem=new List<Invoice_line_Item__c>();
        for(QuoteLIneItem objLineItem:newMap.values()){
            if(quoteVsInvoiceMap.get(objLineItem.QuoteId)!=null){
                Invoice_line_Item__c lineItem=new Invoice_line_Item__c();
                lineItem.Invoice__c=quoteVsInvoiceMap.get(objLineItem.QuoteId).Id;
                lineItem.Product__c=objLineItem.Product2Id;
                lineItem.Quantity__c=objLineItem.Quantity;
                lineItem.Unit_Price__c=objLIneItem.UnitPrice;
                lineItem.Amount__c=objLineItem.TotalPrice;
                lineItem.Quote_Line_Item__c=objLineItem.Id;
                lstInvLineItem.add(lineItem);
            }
            if(lstInvLineItem.size()>0){
                upsert lstInvLineItem;
            }
            
        }
    }
    
}