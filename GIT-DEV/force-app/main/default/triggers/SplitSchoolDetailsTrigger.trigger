trigger SplitSchoolDetailsTrigger on Split_School_Detail__c (after insert,after Update) {
    
    Set<Id> oppIdSet = new Set<Id>();
    
    //SyncWithOpportunity sync=new SyncWithOpportunity();
    for(Split_School_Detail__c sp: Trigger.New) {
        oppIdSet.add(sp.ParentOppId__c);
    }
    
    if(oppIdSet.size() > 0)  {
        QuoteTriggerHandler q = new QuoteTriggerHandler();
        q.updateSplitSchoolDetails(oppIdSet);
    }
    //sync.SchoolSyncwithOpportunity(Trigger.new);
}