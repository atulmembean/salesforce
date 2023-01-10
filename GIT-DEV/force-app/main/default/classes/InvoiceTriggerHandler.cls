public class InvoiceTriggerHandler {

    public static void invokePaypalHandler(Set<id> triggerIds,List<Invoice__c> invoices,Map<Id,Invoice__c> invMap){
        
        Set<Id> Ids = new Set<Id>();
        
        for(Invoice__c i:invoices){
            
            if(!String.isBlank(i.Paypal_Invoice_Id__c) && (invMap.get(i.Id).Paypal_status__c == i.Paypal_status__c) && (i.Paypal_status__c != 'Paid')){
                Ids.add(i.Id);
            }
        }
        
        List<Invoice__c> inv = [select Id,Name,Contact__r.Phone,Due_Date__c,Date__c,Contact__r.Name,Contact__r.Email,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Paypal_Invoice_Id__c,P_O_Number__c,(select Id,Name,Product__r.Family,Description_Line_Item__c,Quantity__c,Unit_Price__c from Invoice_Line_Items__r) from Invoice__c where Id IN:Ids];
        
        if(inv.size()>0){
            Database.executeBatch(new PaypalUpdateHandler(inv), 1);
        }
        
    }
    
    public static void invokePaypalHandlerforDeleteInvoice(List<Invoice__c> invoices){
        
        Set<Id> Ids = new Set<Id>();
        
        for(Invoice__c i:invoices)
        {
            
            if(!String.isBlank(i.Paypal_Invoice_Id__c) && (i.Paypal_status__c != 'Paid'))
            {
                Ids.add(i.Id);
            }
        }
        
        List<Invoice__c> invlst = [select Id,Name,Contact__r.Phone,Due_Date__c,Date__c,Contact__r.Name,Contact__r.Email,Billing_Street__c,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Paypal_Invoice_Id__c,P_O_Number__c,(select Id,Name,Product__r.Family,Description_Line_Item__c,Quantity__c,Unit_Price__c from Invoice_Line_Items__r) from Invoice__c where Id IN:Ids];
        StaticResource sr = [SELECT Id,Body,SystemModStamp FROM StaticResource WHERE Name = 'paypal_oauth_token' LIMIT 1];
        
        for (Invoice__c invoice :invlst)
        {
        
        Http h = new Http(); 
        
        HttpRequest authReq = new HttpRequest();
        authReq.setEndpoint('https://api.paypal.com/v1/oauth2/token');
        authReq.setMethod('POST');
        authReq.setHeader('Content-Type','application/x-www-form-urlencoded');
        authReq.setHeader('Authorization',sr.Body.toString());
        authReq.setBody('grant_type=client_credentials'); 
        
        HttpResponse authRes = h.send(authReq);
        
        if(authRes.getStatusCode() == 200){
            Map<String, Object> authResults = (Map<String, Object>) JSON.deserializeUntyped(authRes.getBody());                             
            String authToken = 'Bearer '+(String)authResults.get('access_token');
            
            
            HttpRequest sendReq = new HttpRequest();
            sendReq.setEndpoint('https://api.paypal.com/v2/invoicing/invoices/'+invoice.Paypal_Invoice_Id__c+'/cancel');
            sendReq.setMethod('POST');
            sendReq.setHeader('Content-Type','application/json');
            sendReq.setHeader('Authorization',authToken);
            
            HttpResponse sendResponse = h.send(sendReq);                              
            if(sendResponse.getStatusCode() == 204){
                /*invoice.Paypal_Invoice_Id__c = '';
                invoice.Paypal_Invoice__c = '';
                invoice.paypal_send_url__c = '';
                invoice.Paypal_status__c = 'Deleted';
                
                try{
                    update invoice; 
                }
                catch(DmlException e){
                    //return 'Error '+e; 
                } */                       
                
            }
            
        }
        }
        
    }
    
}