public with sharing class ProcessSubscriptionsOpptyInvocable
{
    public class ProcessRequest
    {
        @InvocableVariable(
            label = 'Opportunity Record ID'
            description = 'Opportunity Record ID'
            required = false
        )
        public String opportunityId;
        
    } 
               
    @InvocableMethod(label='Process Subscriptions for Opportunity')
    public static void createRenewalOppty(List<ProcessRequest > requests)
    {
        for ( ProcessRequest request : requests )
        {
            ProcessRecord(request);
        }
    }
    
    public static void ProcessRecord(ProcessRequest request)
    {
        
        if (request.opportunityId!= null)
        {
            String rId = request.opportunityId;
            List<String> Years = New List<String>();
            Integer val = 0;
            Integer numYears =0;
            List <String> subYears =  New List<String>();
            List <String> subYearsnew =  New List<String>();
            Boolean flg = false;
            String subscriptionYears = '';
            Contract newcon = New Contract();
            Integer numberDays = 0;
            List<Contract> subscriptions = New List<Contract>();
            List<Contract> upsertcontracts = New List<Contract>();
            List<Contract> updatecontracts = New List<Contract>();
            List<Contract> insertcontracts = New List<Contract>();
            List<Contract> deletecontracts = New List<Contract>();
            Opportunity opp = [select id, name, Refund__c, Refunded_Amount__c, Teacher__r.Email, AccountId, Pilot_End_Date__c, Subscription_Start_Year__c, Subscription_End_Year__c, No_of_Students__c, No_of_Teachers__c, Amount, Subscription__c, Account.Parent_Pay__c, Student_Pay__c, StageName,Subscription_Processed__c from opportunity where Id = :rId];
            if (opp.Account != Null)
            {
                List<Account> acclst = New List<Account>();
                Account a = [Select Id, AnnualRevenue, RecordType.Name, Teacher_Email__c, Subscription_Status__c , School_Id__c, AnnualRevenue__c, Subscription_Years__c, Parent_Pay__c, Previous_Pilot_End_Date__c, LatestPilotEndDate1__c, Previous_Membership_Expires_On__c, Previous_Subscription_Expiry_Date__c, Subscription_Expiry_Date1__c, Student_Rate__c, Ready_for_Membean_Sync__c, Temp_Ready_for_Membean_Sync__c,Membean_Expires_On__c, Membership_Expires_On__c, Subscription_Expiry_Month_Calc__c,No_Of_Students__c,No_Of_Teachers__c from Account where Id = :opp.AccountId];
                List<QuoteLineItem> qlst = [select id, unitprice, Quantity from QuoteLineItem where Product2.Family='Student Subscriptions' AND Quote.Status = 'Accepted' And Quote.Opportunity.Id = :opp.Id];
                Integer days = 0;
                Date dt;
                Integer oppyears = 1;
                // Setting Membean Subscription Expiray Dates and Acount data
                List<Contract> delcontracts = [Select Id from Contract where AccountId = :a.Id];
                List<Contract> inscontracts = New LIst<Contract>();
                //if (delcontracts.size()>0)
                    //delete delcontracts;
                Decimal pilotAnnualRev = 0;
                Decimal pilotStudentcnt = 0;
                Decimal pilotTeachercnt = 0;
                Decimal subAnnualRev = 0;
                Decimal subStudentcnt = 0;
                Decimal subTeachercnt = 0;
                String prevOppid = '';
                Date LatestPilotEndDate;
                Date LatestSubEndDate;
                Date MembeanExpires;

                days = Date.daysInMonth(Integer.valueOf(opp.Subscription_End_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c));
                dt = Date.newInstance(Integer.valueOf(opp.Subscription_End_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                oppyears = Integer.valueOf(opp.Subscription_End_Year__c) - Integer.valueOf(opp.Subscription_Start_Year__c);
                for (integer i=0;i<oppyears;++i)
                {
                    Years.add(String.valueOf(integer.ValueOf(opp.Subscription_Start_Year__c)+i));
                    if (opp.Amount != Null)
                        subAnnualRev = subAnnualRev + (opp.Amount/oppyears);
                    if (opp.No_of_Students__c != Null)   
                        subStudentcnt = subStudentcnt + opp.No_of_Students__c;
                    if (opp.No_of_Teachers__c != Null)  
                        subTeachercnt = subTeachercnt + opp.No_of_Teachers__c;
                }    
                String SEY = '';
                Date CurrentDate = system.Today();
                SEY = opp.Subscription_End_Year__c;
                days = Date.daysInMonth(Integer.valueOf(opp.Subscription_End_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c));
                    
                /*if (SEY != '')
                {
                    days = Date.daysInMonth(Integer.valueOf(SEY), integer.valueOf(a.Subscription_Expiry_Month_Calc__c));
                    LatestSubEndDate = Date.newInstance(Integer.valueOf(SEY),integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                    CurrentDate = Date.newInstance(CurrentDate.year(),integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                }
                if (integer.valueOf(SEY) - CurrentDate.year() <= 1)
                    a.Membean_Expires_On__c = Date.newInstance(Integer.valueOf(SEY),integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                else
                    a.Membean_Expires_On__c = Date.newInstance(CurrentDate.year()+1,integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);*/
                Date dtold = System.Today().addDays(-90);
                if (a.Previous_Subscription_Expiry_Date__c == Null || a.Previous_Subscription_Expiry_Date__c < dtold)
                    a.Subscription_Expiry_Date1__c = dtold;   
                else
                    a.Subscription_Expiry_Date1__c = a.Previous_Subscription_Expiry_Date__c;
                if (a.Previous_Membership_Expires_On__c == Null || a.Previous_Membership_Expires_On__c < dtold)
                    a.Membean_Expires_On__c = dtold;
                else
                    a.Membean_Expires_On__c = a.Previous_Membership_Expires_On__c;
                subAnnualRev = subAnnualRev  + pilotAnnualRev;
                subStudentcnt = subStudentcnt + pilotStudentcnt;
                subTeachercnt = subTeachercnt + pilotTeachercnt;
                Set<String> setYears = New Set<String>();
                
                
                /*if (Years.size()>0)
                {
                    Years.sort();
                    setYears.addAll(Years); 
                    Years.addAll(setYears);   
                }
                subYearsnew = a.Subscription_Years__c.split(';');
                String newsubYears = '';
                for (integer i=0;i<Years.Size();++i)
                {
                    String flag = 'Y';
                    for (integer k=0;k<subYearsnew.Size();++k)
                    {
                        if (subyearsnew[k] == Years[i])
                        {
                            flag = 'N';
                            break;
                        }
                    }
                    if (flag == 'Y')
                        newsubYears = newSubYears + Years[i] + ';';    
                }
                newsubYears = newSubYears.removeEnd(';');
                a.Subscription_Years__c = newSubYears;*/
                
                for (integer i=0;i<oppyears;++i)
                {
                    val = integer.valueof(opp.Subscription_Start_Year__c)+i;
                    Years.add(String.valueOf(val));    
                }
                Years.sort();
                system.debug('Years Sort::: ' + Years);
                system.debug('a.Subscription_Years__c::: '+ a.Subscription_Years__c);
                if (a.Subscription_Years__c == Null)
                {
                    for (integer i=0;i<Years.size();++i)
                    {
                        subscriptionYears = subscriptionYears + Years[i] + ';';    
                    }
                }
                else if (a.Subscription_Years__c != Null)
                {
                    subYears.addAll(a.Subscription_Years__c.split(';'));
                    subYears.sort();
                    for (integer j=0;j<Years.Size();++j)
                    {
                        flg = false;
                        for (integer k=0;k<subYears.Size();++k)
                        {
                            if (Years[j] == subYears[k])
                            {
                                //subYears.remove(k);
                                flg = TRUE;
                                break;
                            }
                        }
                        if (flg == FALSE)
                            subYears.add(Years[j]);
                    }
                }
                system.debug('subscriptionYears1::: ' + subscriptionYears);
                if (subYears.Size()>0)
                    subYears.sort();
                system.debug('subYears::: ' + subYears);
                for (integer z=0;z<subYears.size();++z)
                {
                    subscriptionYears = subscriptionYears + subYears[z] + ';';        
                }
                subscriptionYears = subscriptionYears.removeEnd(';');
                system.debug('subscriptionYears2::: ' + subscriptionYears);
                system.debug('subYears.size::: ' + subYears.size());
                if (subscriptionYears != '')
                    a.Subscription_Years__c = subscriptionYears;
                    
                
                a.No_Of_Students__c = subStudentcnt;
                a.No_Of_Teachers__c = subTeachercnt;
                a.Subscription_Expiry_Date1__c = dt;
                if (a.School_Id__c  != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                {
                    a.Ready_for_Membean_Sync__c = TRUE;
                    a.Temp_Ready_for_Membean_Sync__c =  TRUE;
                }
                //a.Ready_for_Membean_Sync__c = TRUE;
                //a.Temp_Ready_for_Membean_Sync__c =  TRUE;

                subscriptions = [Select Id, Name, Subscription_Start_Year__c, Subscription_End_Year__c, AccountId, No_of_Students__c, No_of_Teachers__c, Amount__c from Contract where AccountId = :a.Id];
                Boolean newflag = false;
              
                for (integer i=0;i<Years.Size();++i)
                {
                    for(Contract con : subscriptions)
                    {
                        if(con.Subscription_Start_Year__c == Years[i] && con.Subscription_End_Year__c == String.valueOf(integer.valueof(Years[i])+1))
                        {
                            if (con.Amount__c - (opp.Amount/Years.Size()) <= 0)
                                    deletecontracts.add(con);
                            else
                            {
                                con.No_of_Students__c = con.No_of_Students__c - opp.No_of_Students__c;
                                con.No_of_Teachers__c = con.No_of_Teachers__c - opp.No_of_Teachers__c;
                                con.Amount__c = con.Amount__c - (opp.Amount/Years.Size());
                                update con;
                            }
                            if (i==0)
                            {
                                a.No_of_Students__c = con.No_of_Students__c;
                                a.No_Of_Teachers__c = con.No_of_Teachers__c;
                                if (a.AnnualRevenue__c != Null)
                                    a.AnnualRevenue__c = a.AnnualRevenue__c - (opp.Amount/Years.Size());
                                else
                                    a.AnnualRevenue__c = 0;

                            }
                        }                
                    }
                 }
                    if (updateContracts.size()>0)
                        update updateContracts;
                    if (deletecontracts.Size()>0)
                        delete deletecontracts;
                    update a;
                    opp.Subscription_Processed__c = FALSE;
                    update opp; 
            }
        }
    }
}