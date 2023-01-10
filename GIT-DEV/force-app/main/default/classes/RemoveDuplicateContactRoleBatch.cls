global class RemoveDuplicateContactRoleBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
       global Database.QueryLocator start(Database.BatchableContext BC){
            string query;
            Date dt = system.today();
            dt = dt.addDays(-90);
            String close = 'Close Lost';
            close = '\''+close+'\'';
            List<String> rectype = New List<String>{'Renewal'};
            if(Test.isRunningTest()){
               query = 'Select id from Opportunity where ((Probability > 0 AND Probability < 100) AND CloseDate >= :dt AND Recordtype.Name = :rectype) order by CloseDate DESC LIMIT 10';  
            }
            else{
               query = 'Select id from Opportunity where Probability >= 0';
            }
            
            return Database.getQueryLocator(query);
       }
       
       global void execute(Database.BatchableContext BC, List<Opportunity> scope){

                for(Opportunity o:scope){
                    ProcessRecord(o.Id);
                }
                    
       }
        
       global void finish(Database.BatchableContext BC){
            
       }
    
       global void ProcessRecord(String rId){
            List<OpportunityContactRole> ocrlst = [Select Id, ContactId, OpportunityId, Role from OpportunityContactRole where OpportunityId = :rId order by Contactid, CreatedDate DESC];
            Map<Id,OpportunityContactRole> ocrMap =  New Map<Id,OpportunityContactRole>();
            for (OpportunityContactRole ocr :ocrlst)
            {
                ocrMap.put(ocr.Id,ocr);
                system.debug('ocrMap.ocrid::: ' + ocr.Id);
            } 
            //List<OpportunityContactRole> ocrlstnew = [Select Id, ContactId, OpportunityId, Role from OpportunityContactRole where OpportunityId = :rId];
            List<OpportunityContactRole> ocrlstdel = New List<OpportunityContactRole>();
            String Prev = '';
            String Cur = '';
            for (OpportunityContactRole ocr :ocrlst)
            {
                Cur = ocr.ContactId;
                system.debug('Cur::: ' + Cur);
                if (Prev == '' || Prev != Cur)
                {
                    for(OpportunityContactRole targetocr : ocrMap.values()) 
                    { 
                        if (targetocr.ContactId == ocr.ContactId && targetocr.Id != ocr.Id)
                        {
                            ocrlstdel.add(targetocr);
                            system.debug('targetocr::: ' + targetocr);
                        }
                    }
                    Prev = Cur;
                    system.debug('Prev::: ' + Prev);
                }    
            }
            if (ocrlstdel.Size()>0)
                delete ocrlstdel;
       }
}