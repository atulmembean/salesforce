public class DeleteInvoice {
    
    @AuraEnabled
    public static Invoice__c getInvoiceDetails(String invId){
        Invoice__c inv= [select Id,Paypal_Invoice_Id__c,Paypal_Invoice__c,paypal_send_url__c,Paypal_status__c from Invoice__c where Id =:invId];
        return inv;
    }

    @AuraEnabled
    public static String cancelInvoice(Invoice__c invoice){
        String msg = 'success';
        
        StaticResource sr = [SELECT Id,Body,SystemModStamp FROM StaticResource WHERE Name = 'paypal_oauth_token' LIMIT 1]; 
        
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
                invoice.Paypal_Invoice_Id__c = '';
                invoice.Paypal_Invoice__c = '';
                invoice.paypal_send_url__c = '';
                invoice.Paypal_status__c = 'Deleted';
                
                try{
                    update invoice; 
                }
                catch(DmlException e){
                    return 'Error '+e; 
                }                        
                
            }
            
        }
        
        return msg;
    }
    
}