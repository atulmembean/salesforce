public class InvoiceRefundController {
    @AuraEnabled
    public static String processFullRefund(String invoiceId){
        String quoteId=[select id,Quote__c from Invoice__c where id=:invoiceId].Quote__c;
        system.debug('@@'+quoteId);
        String validationMsg=InvoiceRefundController.validateOpportunity(quoteId);
        if(!validationMsg.equalsIgnoreCase('SUCCESS')){
            return validationMsg;
        }
        List<Invoice__c>lstInvoices=[select id,name,status__c, Paypal_Invoice__c, Paypal_Invoice_Id__c,paypal_send_url__c, Paypal_status__c,(select id from Payments__r) from Invoice__c where Quote__c=:quoteId];
        if(lstInvoices.size()>0 && lstInvoices.get(0).Payments__r.size()==0){
            validationMsg='Payment is not made for the invoice and No refund can be made';
            return validationMsg;
        }
        Quote objQuote=[select id,name,QuoteNumber,status,AccountId,opportunityId,Subscription_Start_Year__c,Subscription_End_Year__c,No_of_students__c,No_of_Teachers__c,
                        TotalPrice,(select id,unitPrice from QuoteLIneItems where product2.Family='Student Subscriptions' limit 1 ) from quote where id=:quoteId];
        List<Contract>lstSubscriptions=[select id,name from Contract where accountId=:objQuote.AccountId];
        Account objAccount=[select id,name,Subscription_Status__c,No_of_Students__c,No_of_Teachers__c,AnnualRevenue__c,Subscription_Years__c,Student_rate__c  from Account where id=:objQuote.AccountId];
        List<Integer>substcribtionYears=new List<Integer>();
        for(String yr:objAccount.Subscription_Years__c.split(';')){
            substcribtionYears.add(Integer.valueOf(yr));
        }
        substcribtionYears.sort();
        substcribtionYears.remove(substcribtionYears.size()-1);
        String strSubYear='';
        if(substcribtionYears.size()>1){
            for(Integer i:substcribtionYears){
                strSubYear=(strSubYear.length()>0?strSubYear+';'+String.valueOf(i):strSubYear+String.valueOf(i));
            }
        }else if(substcribtionYears.size()==1){
            strSubYear=substcribtionYears.get(0)+'';
        }
        
        objAccount.Subscription_Years__c=strSubYear;
        // objAccount.Subscription_Status__c='Expired';
        Opportunity objOpportunity=[select id,name, stagename, Credit_note__c,Amount,No_of_Students__c,No_of_Teachers__c,Loss_Reason__c,Lost_Reason__c from Opportunity where id=:objQuote.OpportunityId];
        Credit_Note__c objCreditNote=new Credit_Note__c();
        objCreditNote.Quote__c =quoteId;
        objCreditNote.Opportunity__c=objOpportunity.Id;
        objCreditNote.Invoice__c=lstInvoices.get(0).Id;
        objCreditNote.Bill_To__c=objAccount.Id;
        objCreditNote.Credit_Date__c=System.Today();
        objCreditNote.Reference_Number__c=objQuote.QuoteNumber;
        objCreditNote.recordTypeId=Schema.SObjectType.Credit_Note__c.getRecordTypeInfosByName().get('Lumsum').getRecordTypeId();
        insert objCreditNote;
        objCreditNote=[select id,name from Credit_note__c where id=:objCreditNote.Id];
        List<Credit_Note_Line_Item__c>lstCreditItems=new List<Credit_Note_Line_Item__c>();
        List<QuoteLineItem>lstQuoteLineItems=[select id, Product2Id,UnitPrice, Quantity,refund_qty__c, Product_Family__c from QuoteLineItem where quoteId=:quoteId ];
        Double studentCount=0.0;
        Double teacherCount=0.0;
        Double Amount=0.0;
        for(QuoteLineItem objItem:lstQuoteLineItems){
            Credit_Note_Line_Item__c item=new Credit_Note_Line_Item__c();
            item.Credit_Note__c=objCreditNote.Id;
            item.Product__c=objItem.Product2Id;
            item.Quantity__c=objItem.Quantity;
            item.Rate__c=objItem.UnitPrice;
            item.Refund_Quantity__c=objItem.Quantity;
            objItem.refund_qty__c=objItem.Quantity;
            lstCreditItems.add(item);
            if(objItem.Product_family__c=='Student Subscriptions'){
                studentCount=StudentCount+objItem.refund_qty__c;
            }else if(objItem.Product_family__c=='Teacher Subscriptions'){
                teacherCount=teacherCount+objItem.refund_qty__c;
            }
            amount=amount+(objItem.Refund_Qty__c* objItem.UnitPrice);
        }
        objAccount.No_of_Students__c=objAccount.No_of_Students__c-studentCount;
        objAccount.No_of_Teachers__c=objAccount.No_of_Teachers__c-teacherCount;
        objAccount.AnnualRevenue__c=objAccount.AnnualRevenue__c-Amount;
        objAccount.Student_Rate__c=(objQuote.QuoteLineItems.size()>0?objQuote.QuoteLineItems.get(0).UnitPrice:0);
        update objAccount;
        insert lstCreditItems;
        update lstQuoteLineItems;
        
        List<Opportunity>lstRenewalOpportunity=[select id,name from Opportunity where Parent_Renewal_Opportunity__c=:objOpportunity.Id and recordType.name='Renewal'];
        delete lstRenewalOpportunity;
        objOpportunity.Credit_Note__c=objCreditNote.Name;
        objOpportunity.No_of_Students__c=objOpportunity.No_of_Students__c-studentCount;
        objOpportunity.No_of_Teachers__c=objOpportunity.No_of_Teachers__c-teacherCount;
        if (objOpportunity.Amount > 0)
            objOpportunity.Amount=objOpportunity.Amount-Amount;
        else
            objOpportunity.Amount = 0;
        objOpportunity.StageName='Close Lost';
        objOpportunity.Loss_Reason__c='Other';
        objOpportunity.Lost_Reason__c='Invoice Amount Refunded';
        
        objOpportunity = updateRefundAmountInOpportunity(objOpportunity,objCreditNote.Id,'Full');
        update objOpportunity;
        //delete lstSubscriptions;
        return 'Success';
    }
    @AuraEnabled
    public static String processPartialRefund(String invoiceId,List<QuoteLineItem>itemList){
        String quoteId=[select id,Quote__c from Invoice__c where id=:invoiceId].Quote__c;
        List<Invoice__c>lstInvoices=[select id,name,status__c, Paypal_Invoice__c, Paypal_Invoice_Id__c,paypal_send_url__c, Paypal_status__c,(select id from Payments__r) from Invoice__c where Id=:invoiceId];
        String validationMsg=''; 
        if(lstInvoices.size()>0 && lstInvoices.get(0).Payments__r.size()==0){
            validationMsg='Payment is not made for the invoice and No refund can be made';
            return validationMsg;
        }
        Quote objQuote=[select id,name,quoteNumber,status,AccountId,opportunityId,Subscription_Start_Year__c,Subscription_End_Year__c,No_of_students__c,No_of_Teachers__c,
                        TotalPrice,(select id,unitPrice from QuoteLIneItems where product2.Family='Student Subscriptions' limit 1 ) from quote where id=:quoteId];
        List<Contract>lstSubscriptions=[select id,name,No_of_Students__c,No_of_Teachers__c,Amount__c from Contract where accountId=:objQuote.AccountId order by createdDate desc limit 1];
        Account objAccount=[select id,name,Subscription_Status__c,No_of_Students__c,No_of_Teachers__c,AnnualRevenue__c,Subscription_Years__c,Student_rate__c  from Account where id=:objQuote.AccountId];
        List<Integer>substcribtionYears=new List<Integer>();
        for(String yr:objAccount.Subscription_Years__c.split(';')){
            substcribtionYears.add(Integer.valueOf(yr));
        }
        substcribtionYears.sort();
        substcribtionYears.remove(substcribtionYears.size()-1);
        String strSubYear='';
        if(substcribtionYears.size()>1){
            for(Integer i:substcribtionYears){
                strSubYear=(strSubYear.length()>0?strSubYear+';'+String.valueOf(i):strSubYear+String.valueOf(i));
            }
        }else if(substcribtionYears.size()==1){
            strSubYear=substcribtionYears.get(0)+'';
        }
        
        objAccount.Subscription_Years__c=strSubYear;
        // objAccount.Subscription_Status__c='Expired';
        Opportunity objOpportunity=[select id,name, stagename, Credit_note__c,Amount,No_of_Students__c,No_of_Teachers__c, Loss_Reason__c, Lost_Reason__c from Opportunity where id=:objQuote.OpportunityId];
        Credit_Note__c objCreditNote=new Credit_Note__c();
        objCreditNote.Quote__c =quoteId;
        objCreditNote.Opportunity__c=objOpportunity.Id;
        objCreditNote.Invoice__c=lstInvoices.get(0).Id;
        objCreditNote.Bill_To__c=objAccount.Id;
        objCreditNote.Credit_Date__c=System.Today();
        objCreditNote.Reference_Number__c=objQuote.QuoteNumber;
        objCreditNote.recordTypeId=Schema.SObjectType.Credit_Note__c.getRecordTypeInfosByName().get('Subscription').getRecordTypeId();
        insert objCreditNote;
        objCreditNote=[select id,name from Credit_note__c where id=:objCreditNote.Id];
        List<Credit_Note_Line_Item__c>lstCreditItems=new List<Credit_Note_Line_Item__c>();
        List<QuoteLineItem>lstQuoteLineItems=itemList;//[select id, Product2Id,UnitPrice, Quantity,refund_qty__c, Product_Family__c from QuoteLineItem where quoteId=:quoteId ];
        Double studentCount=0.0;
        Double teacherCount=0.0; 
        Double Amount=0.0;
        for(QuoteLineItem objItem:lstQuoteLineItems){
            Credit_Note_Line_Item__c item=new Credit_Note_Line_Item__c();
            item.Credit_Note__c=objCreditNote.Id;
            item.Product__c=objItem.Product2Id;
            item.Quantity__c=objItem.Quantity;
            item.Rate__c=objItem.UnitPrice;
            item.Refund_Quantity__c=objItem.refund_qty__c;
           // objItem.refund_qty__c=objItem.Quantity;
            lstCreditItems.add(item);
            if(objItem.Product_family__c=='Student Subscriptions'){
                studentCount=StudentCount+objItem.refund_qty__c;
            }else if(objItem.Product_family__c=='Teacher Subscriptions'){
                teacherCount=teacherCount+objItem.refund_qty__c;
            }
            amount=amount+(objItem.Refund_Qty__c* objItem.UnitPrice);
        }
        objAccount.No_of_Students__c=objAccount.No_of_Students__c-studentCount;
        objAccount.No_of_Teachers__c=objAccount.No_of_Teachers__c-teacherCount;
        objAccount.AnnualRevenue__c=objAccount.AnnualRevenue__c-Amount;
        objAccount.Student_Rate__c=(objQuote.QuoteLineItems.size()>0?objQuote.QuoteLineItems.get(0).UnitPrice:0);
        update objAccount;
        insert lstCreditItems;
        update lstQuoteLineItems;
        for(Contract objContract:lstSubscriptions){
            objContract.No_of_Students__c=objContract.No_of_Students__c-studentCount;
            objContract.No_of_Teachers__c=objContract.No_of_Teachers__c-teacherCount;
            objContract.Amount__c=objContract.Amount__c-Amount;
        }
        update lstSubscriptions;
        List<Opportunity>lstRenewalOpportunity=[select id,name,Credit_Note__c from Opportunity where Parent_Renewal_Opportunity__c=:objOpportunity.Id and recordType.name='Renewal'];
        for(Opportunity objRenewal:lstRenewalOpportunity){
            objRenewal.Credit_Note__c=objCreditNote.Name;
        }
        update lstRenewalOpportunity;
        objOpportunity.Credit_Note__c=objCreditNote.Name;
        objOpportunity.No_of_Students__c=objOpportunity.No_of_Students__c-studentCount;
        objOpportunity.No_of_Teachers__c=objOpportunity.No_of_Teachers__c-teacherCount;
        if (objOpportunity.Amount > 0)
            objOpportunity.Amount=objOpportunity.Amount-Amount;
        else
            objOpportunity.Amount = 0;
        objOpportunity = updateRefundAmountInOpportunity(objOpportunity,objCreditNote.Id,'Partial');
        update objOpportunity;
        
        return 'Success';
    }
    
    public static Opportunity updateRefundAmountInOpportunity(Opportunity objOpportunity, String creditNoteId,String refundType ){
        Double refudedAmout = [Select Id,Refunded_Amount__c from Credit_Note__c where Id = :creditNoteId].Refunded_Amount__c;
        objOpportunity.Refunded_Amount__c = refudedAmout;
        objOpportunity.Refund__c =refundType == 'Full'?'Full Refund':'Partial Refund';
        objOpportunity.Subscription_Processed__c = true;
        return objOpportunity;
    }
    
    @AuraEnabled
    public static List<QuoteLineItem>fetchLilneItems(String invoiceId){
        return [select id, Product2Id,Product2.Name,UnitPrice, Quantity,Refund_Qty__c, Product_Family__c from QuoteLineItem where quoteId in (select quote__c from Invoice__c where id=:invoiceId) ];
    }
    public static String validateOpportunity(Id quoteId){
        Quote objQuote=[select id,name,opportunityId from Quote where id=:quoteId ];
        Opportunity objOpportunity=[select id,name,Teachers_usage_count__c , RecordType.DeveloperName from Opportunity where id=:objQuote.opportunityID];
        if(objOpportunity.recordType.DeveloperName!='Grouped' && objOpportunity.recordType.DeveloperName!='Grouped MultiYear' && objOpportunity.Teachers_usage_count__c==0 ){
            return 'Please update teachers Membean usage count.';
        }
        return 'SUCCESS';
    }
}