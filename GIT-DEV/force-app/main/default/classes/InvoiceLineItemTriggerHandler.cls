public class InvoiceLineItemTriggerHandler {

    public static void invokePaypalHandler(List<Invoice_Line_Item__c> invli){
        Set<Id> Ids = new Set<Id>();
        
        for(Invoice_Line_Item__c i:invli){
            Ids.add(i.Invoice__c);
        }
        
        List<Invoice__c> invoices= [select Id,Name,Contact__r.Phone,Due_Date__c,Date__c,Contact__r.Name,Contact__r.Email,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Paypal_Invoice_Id__c,P_O_Number__c,(select Id,Name,Product__r.Family,Description_Line_Item__c,Quantity__c,Unit_Price__c from Invoice_Line_Items__r) from Invoice__c where Id IN:Ids];
        
        List<Invoice__c> inv = new List<Invoice__c>();
        
        for(Invoice__c i:invoices){
            if(!String.isBlank(i.Paypal_Invoice_Id__c)){
                inv.add(i);
            }
        }
        
        if(inv.size()>0){
            Database.executeBatch(new PaypalUpdateHandler(inv), 1);
        }
        
    }
}