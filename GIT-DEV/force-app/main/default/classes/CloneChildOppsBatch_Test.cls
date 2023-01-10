@istest(SeeAllData=TRUE)
private class CloneChildOppsBatch_Test{
@isTest static void test_method_one() {
    Test.StartTest();
    List<Opportunity> olstclone = New List<Opportunity>();
    Id rectypeId = [Select Id from RecordType where Name ='Public School' AND sObjectType = 'Account' and isActive = TRUE].Id;
    Account a = New Account(Name = 'Test New',RecordTypeId = rectypeId);
    insert a;
    Id recordTypeId = [Select Id from RecordType where Name = 'Renewal' and SobjectType = 'Opportunity' And isActive = TRUE].Id;
    Opportunity o = [Select Id,ZDiscountAnnual__c,Commitment_Duration__c,Subscription_End_Year__c, Account.Subscription_Expiry_Month__c, Cloned_Opportunity_To_Process__c from Opportunity where RecordType.Name = 'Renewal' AND Parent_Renewal_Opportunity__r.Account.RecordType.Name = 'District' lIMIT 1];
    
    Opportunity objCloneOpp = o.clone(false, true, false, true);
    objCloneOpp.Name = 'Test1' + '-' + 'Renewal' + ' ' + o.Subscription_End_Year__c;
    objCloneOpp.RecordTypeId = recordTypeId;
    if (o.ZDiscountAnnual__c == 0)
        objCloneOpp.StageName = 'Nurturing';
    else
        objCloneOpp.StageName = 'Verbal';
    objCloneOpp.Parent_Opportunity__c = o.Id;
    objCloneOpp.AccountId = a.Id;
    objCloneOpp.Subscription_Start_Year__c = o.Subscription_End_Year__c;
    Integer year = Integer.ValueOf(o.Subscription_End_Year__c.trim());
    year = year + 1;
    objCloneOpp.Subscription_End_Year__c = String.valueOf(year);
    if (o.Account.Subscription_Expiry_Month__c != '')
    {
        Integer Yr = Integer.ValueOf(o.Subscription_End_Year__c.trim());
        Integer Day = 1;
        Integer Month;
        If (o.Account.Subscription_Expiry_Month__c == 'January')
            Month = 1;
        else if (o.Account.Subscription_Expiry_Month__c == 'February')
            Month = 2;
        else if (o.Account.Subscription_Expiry_Month__c == 'March')
            Month = 3;
        else if (o.Account.Subscription_Expiry_Month__c == 'April')
            Month = 4;
        else if (o.Account.Subscription_Expiry_Month__c == 'May')
            Month = 5;
        else if (o.Account.Subscription_Expiry_Month__c == 'June')
            Month = 6;
        else if (o.Account.Subscription_Expiry_Month__c == 'July')
            Month = 7;
        else if (o.Account.Subscription_Expiry_Month__c == 'August')
            Month = 8;
        else if (o.Account.Subscription_Expiry_Month__c == 'September')
            Month = 9;
        else if (o.Account.Subscription_Expiry_Month__c == 'October')
            Month = 10;
        else if (o.Account.Subscription_Expiry_Month__c == 'November')
            Month = 11;
        else if (o.Account.Subscription_Expiry_Month__c == 'December')
            Month = 12;
        Date d = date.newInstance(Yr,Month,Day);
        d = d.toStartOfMonth().addDays(-1);
        objCloneOpp.CloseDate = d;
        objCloneOpp.Estimate_Status__c = 'Not Estimated';
        objCloneOpp.Probability = 0;
        objCloneOpp.IsCloseWon__c = FALSE;
        objCloneOpp.Pilot_Start_Date__c = NULL;
        objCloneOpp.Pilot_End_Date__c = NULL;
        objCloneOpp.Start_Pilot__c = FALSE;
        objCloneOpp.Key_Activity_Log__c = '';
        objCloneOpp.Scaling_down_consideration__c = FALSE;
        objCloneOpp.Scaling_up_consideration__c = FALSE;
        objCloneOpp.Scaling_up_from_last_year__c = FALSE;
        objCloneOpp.Scaling_down_from_last_year__c = FALSE;
        objCloneOpp.Quote_Acknowledgement__c = FALSE;
        objCloneOpp.Sub_Stage__c = '';
        if (o.Commitment_Duration__c > 1)
            objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c - 1);
        else if (o.Commitment_Duration__c == 1)
            objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c);
    }
    else
        objCloneOpp.CloseDate = System.Today();
    olstclone.add(objCloneOpp);
    
    
    objCloneOpp = o.clone(false, true, false, true);
    objCloneOpp.Name = 'Test' + '-' + 'Renewal' + ' ' + o.Subscription_End_Year__c;
    objCloneOpp.RecordTypeId = recordTypeId;
    if (o.ZDiscountAnnual__c == 0)
        objCloneOpp.StageName = 'Nurturing';
    else
        objCloneOpp.StageName = 'Verbal';
    objCloneOpp.Parent_Renewal_Opportunity__c = o.Id;
    objCloneOpp.AccountId = o.AccountId;
    objCloneOpp.Subscription_Start_Year__c = o.Subscription_End_Year__c;
    year = Integer.ValueOf(o.Subscription_End_Year__c.trim());
    year = year + 1;
    objCloneOpp.Subscription_End_Year__c = String.valueOf(year);
    if (o.Account.Subscription_Expiry_Month__c != '')
    {
        Integer Yr = Integer.ValueOf(o.Subscription_End_Year__c.trim());
        Integer Day = 1;
        Integer Month;
        If (o.Account.Subscription_Expiry_Month__c == 'January')
            Month = 1;
        else if (o.Account.Subscription_Expiry_Month__c == 'February')
            Month = 2;
        else if (o.Account.Subscription_Expiry_Month__c == 'March')
            Month = 3;
        else if (o.Account.Subscription_Expiry_Month__c == 'April')
            Month = 4;
        else if (o.Account.Subscription_Expiry_Month__c == 'May')
            Month = 5;
        else if (o.Account.Subscription_Expiry_Month__c == 'June')
            Month = 6;
        else if (o.Account.Subscription_Expiry_Month__c == 'July')
            Month = 7;
        else if (o.Account.Subscription_Expiry_Month__c == 'August')
            Month = 8;
        else if (o.Account.Subscription_Expiry_Month__c == 'September')
            Month = 9;
        else if (o.Account.Subscription_Expiry_Month__c == 'October')
            Month = 10;
        else if (o.Account.Subscription_Expiry_Month__c == 'November')
            Month = 11;
        else if (o.Account.Subscription_Expiry_Month__c == 'December')
            Month = 12;
        Date d = date.newInstance(Yr,Month,Day);
        d = d.toStartOfMonth().addDays(-1);
        objCloneOpp.CloseDate = d;
        objCloneOpp.Estimate_Status__c = 'Not Estimated';
        objCloneOpp.Probability = 0;
        objCloneOpp.IsCloseWon__c = FALSE;
        objCloneOpp.Pilot_Start_Date__c = NULL;
        objCloneOpp.Pilot_End_Date__c = NULL;
        objCloneOpp.Start_Pilot__c = FALSE;
        objCloneOpp.Key_Activity_Log__c = '';
        objCloneOpp.Scaling_down_consideration__c = FALSE;
        objCloneOpp.Scaling_up_consideration__c = FALSE;
        objCloneOpp.Scaling_up_from_last_year__c = FALSE;
        objCloneOpp.Scaling_down_from_last_year__c = FALSE;
        objCloneOpp.Quote_Acknowledgement__c = FALSE;
        objCloneOpp.Sub_Stage__c = '';
        if (o.Commitment_Duration__c > 1)
            objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c - 1);
        else if (o.Commitment_Duration__c == 1)
            objCloneOpp.Commitment_year__c = String.valueOf(o.Commitment_Duration__c);
    }
    else
        objCloneOpp.CloseDate = System.Today();
    objCloneOpp.Cloned_Opportunity_To_Process__c = TRUE;
    olstclone.add(objCloneOpp);
    

    insert olstclone;
    Id batchJobId = Database.executeBatch(new CloneChildOppsBatch(), 1); 
    Test.stopTest();
}
}