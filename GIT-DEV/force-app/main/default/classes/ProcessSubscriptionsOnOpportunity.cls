global class ProcessSubscriptionsOnOpportunity implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext context){
        string query;
        if (Test.isRunningTest())
            query='Select Id from opportunity where Subscription_Processed__c=true order by LastModifiedDate DESC LIMIT 3';
        else
            query='Select Id from opportunity where Subscription_Processed__c=true';
        return Database.getQueryLocator(query);
    }
    global void  execute(database.BatchableContext context, List<Opportunity>lstOpp)
    {
        for (Opportunity o :lstOpp)
            processRecord(o.Id);
    }
    
    global void finish(Database.BatchableContext context){
        
    }
    
    global void processRecord(String rId)
    {
        Date todayDt = System.Today();
        Integer daystoconsider = 0;
        system.debug('Opportunity ID::: '+ rId);
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
        Opportunity o = [select id, name, Refund__c, Prior_Stage__c, Refunded_Amount__c, Teacher__r.Email, AccountId, Pilot_End_Date__c, Subscription_Start_Year__c, Subscription_End_Year__c, No_of_Students__c, No_of_Teachers__c, Amount, Subscription__c, Account.Parent_Pay__c, Student_Pay__c, StageName,Subscription_Processed__c,Membean_Extension_Date__c ,Temporary_Membean_Extension_Date__c from opportunity where Id = :rId];
        String curYear =  String.valueof(Date.Today().Year());

        if (o.Account != Null)
        {
            String recProceed = 'No';
            List<Opportunity> othpayOpp = [Select Id, Student_Pay__c,AccountId,Subscription_End_Year__c,StageName from Opportunity where AccountId = :o.AccountId AND Subscription_End_Year__c >= :curYear AND StageName = 'Close Won' ANd id != :o.Id AND Student_Pay__c = TRUE];
            List<Account> acclst = New List<Account>();
            Account a = [Select Id,RecordType.Name, AnnualRevenue, Teacher_Email__c, Subscription_Status__c , School_Id__c, AnnualRevenue__c, Subscription_Years__c, Parent_Pay__c, Previous_Pilot_End_Date__c, LatestPilotEndDate1__c, Previous_Membership_Expires_On__c, Previous_Subscription_Expiry_Date__c, Subscription_Expiry_Date1__c, Student_Rate__c, Ready_for_Membean_Sync__c, Temp_Ready_for_Membean_Sync__c,Membean_Expires_On__c, Membership_Expires_On__c, Subscription_Expiry_Month_Calc__c,No_Of_Students__c,No_Of_Teachers__c,Pilot_Years__c from Account where Id = :o.AccountId];
            Account aorig = [Select Id,RecordType.Name, AnnualRevenue, Teacher_Email__c, Subscription_Status__c , School_Id__c, AnnualRevenue__c, Subscription_Years__c, Parent_Pay__c, Previous_Pilot_End_Date__c, LatestPilotEndDate1__c, Previous_Membership_Expires_On__c, Previous_Subscription_Expiry_Date__c, Subscription_Expiry_Date1__c, Student_Rate__c, Ready_for_Membean_Sync__c, Temp_Ready_for_Membean_Sync__c,Membean_Expires_On__c, Membership_Expires_On__c, Subscription_Expiry_Month_Calc__c,No_Of_Students__c,No_Of_Teachers__c,Pilot_Years__c from Account where Id = :o.AccountId];
            
            List<QuoteLineItem> qlst = [select id, unitprice, Quantity from QuoteLineItem where Product2.Family='Student Subscriptions' AND Quote.Status = 'Accepted' And Quote.Opportunity.Id = :o.Id AND Quote.Opportunity.Student_Pay__c = TRUE];
            System.debug('OppName: '+o.name +'OppId='+o.id+' o.Pilot_End_Date__c:'+o.Pilot_End_Date__c+ 'a.Subscription_Expiry_Date1__c='+a.Subscription_Expiry_Date1__c+' a.Subscription_Years__c:'+a.Subscription_Years__c);
            List<QuoteLineItem> qlstoth = New List<QuoteLineItem>();
            if (othpayOpp.Size()>0)
                qlstoth = [select id, unitprice, Quantity from QuoteLineItem where Product2.Family='Student Subscriptions' AND Quote.Status = 'Accepted' And Quote.Opportunity.Id = :othpayOpp[0].Id];
            
            if (o.Pilot_End_Date__c != Null && o.StageName != 'Close Won' && o.Membean_Extension_Date__c == Null)
            {
                if (o.Pilot_End_Date__c != a.Subscription_Expiry_Date1__c && a.Subscription_Status__c != 'Customer')
                {
                    a.Previous_Pilot_End_Date__c =  a.LatestPilotEndDate1__c;
                    a.LatestPilotEndDate1__c = o.Pilot_End_Date__c;
                    
                    a.Membership_Expires_On__c = o.Pilot_End_Date__c;
                    a.Membean_Expires_On__c = o.Pilot_End_Date__c;
                    if (a.Teacher_Email__c == Null)
                        a.Teacher_Email__c = o.Teacher__r.Email;
                    if ((a.Parent_Pay__c == FALSE) && (o.Student_Pay__c == TRUE))
                        a.parent_Pay__c = TRUE;
                    
                    if (qlst.size()>0)
                        a.Student_Rate__c = qlst[0].unitprice;
                    else if (qlstoth.size()>0)
                        a.Student_Rate__c = qlstoth[0].unitprice;
                    //a.Temp_Ready_for_Membean_Sync__c = TRUE;
                    if (a.School_Id__c != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                    {
                        a.Temp_Ready_for_Membean_Sync__c = TRUE;
                        a.Ready_for_Membean_Sync__c = TRUE;
                    }
                    acclst.add(a);
                }
                else if ((o.Pilot_End_Date__c > a.Subscription_Expiry_Date1__c) || (a.Subscription_Expiry_Date1__c == Null))
                {
                    a.Previous_Pilot_End_Date__c =  a.LatestPilotEndDate1__c;
                    a.LatestPilotEndDate1__c = o.Pilot_End_Date__c;
                    
                    a.Membership_Expires_On__c = o.Pilot_End_Date__c;
                    a.Membean_Expires_On__c = o.Pilot_End_Date__c;
                    if (a.Teacher_Email__c == Null)
                        a.Teacher_Email__c = o.Teacher__r.Email;
                    if ((a.Parent_Pay__c == FALSE) && (o.Student_Pay__c == TRUE))
                        a.parent_Pay__c = TRUE;
                    if (qlst.size()>0)
                        a.Student_Rate__c = qlst[0].unitprice;
                    else if (qlstoth.size()>0)
                        a.Student_Rate__c = qlstoth[0].unitprice;
                    //a.Temp_Ready_for_Membean_Sync__c = TRUE;
                    if (a.School_Id__c != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                    {
                        a.Temp_Ready_for_Membean_Sync__c = TRUE;
                        a.Ready_for_Membean_Sync__c = TRUE;
                    }   
                    acclst.add(a);
                }
            }
            /*else if (o.Pilot_End_Date__c != Null && o.StageName == 'Close Won')
            {
                recProceed = 'Yes';
                Date dttod = System.Today();
                Integer yracc = dttod.Year();
                Integer days1 = Date.daysInMonth(Integer.valueOf(o.Subscription_End_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c));
                Integer daysacc = Date.daysInMonth(yracc, integer.valueOf(a.Subscription_Expiry_Month_Calc__c));
                
                Date dtacc = Date.newInstance(yracc, integer.valueOf(a.Subscription_Expiry_Month_Calc__c), daysacc);
                Date dt1 = Date.newInstance(Integer.valueOf(o.Subscription_End_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days1);
                
                // Adding Account Subscription Years
                numYears = integer.valueOf(o.Subscription_End_Year__c) - integer.ValueOf(o.Subscription_Start_Year__c);
                                    
                for (integer i=0;i<numYears;++i)
                {
                    val = integer.valueof(o.Subscription_Start_Year__c)+i;
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
                system.debug('subscriptionYearspilot::: ' + subscriptionYears);
                if (subYears.Size()>0)
                    subYears.sort();
                system.debug('subYearspilot::: ' + subYears);
                for (integer z=0;z<subYears.size();++z)
                {
                    subscriptionYears = subscriptionYears + subYears[z] + ';';        
                }
                subscriptionYears = subscriptionYears.removeEnd(';');
                system.debug('subscriptionYearspilot2::: ' + subscriptionYears);
                system.debug('subYears.sizepilot::: ' + subYears.size());
                if (subscriptionYears != '')
                    a.Subscription_Years__c = subscriptionYears;
                    
                if (a.Teacher_Email__c == Null)
                        a.Teacher_Email__c = o.Teacher__r.Email;
                
                a.No_Of_Teachers__c = o.No_Of_Teachers__c;
                a.No_Of_Students__c = o.No_Of_Students__c;
                
                if ((a.Parent_Pay__c == FALSE) && (o.Student_Pay__c == TRUE))
                    a.parent_Pay__c = TRUE;
                if ((o.Student_Pay__c == FALSE) && (othpayOpp.Size() == 0))
                    a.parent_Pay__c = FALSE;
                if (qlst.size()>0)
                    a.Student_Rate__c = qlst[0].unitprice;
                else if (qlstoth.size()>0)
                    a.Student_Rate__c = qlstoth[0].unitprice;
                //a.Temp_Ready_for_Membean_Sync__c =  TRUE;
                if (a.School_Id__c != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                {
                    a.Temp_Ready_for_Membean_Sync__c = TRUE;
                    a.Ready_for_Membean_Sync__c = TRUE;
                }
                
                
                if ((a.Subscription_Expiry_Date1__c == Null) && (a.Membean_Expires_On__c > dtacc))
                {
                    a.Subscription_Expiry_Date1__c = dt1;
                    //acclst.add(a);
                }
                else if ((a.Subscription_Expiry_Date1__c == Null || (a.Subscription_Expiry_Date1__c < dttod)) && (a.Membean_Expires_On__c < dtacc))
                {
                    a.Subscription_Expiry_Date1__c = dt1;
                    a.Membership_Expires_On__c = dtacc;
                    a.Membean_Expires_On__c = dtacc;
                    //acclst.add(a);
                }
                else if (a.Subscription_Expiry_Date1__c == Null && a.Membean_Expires_On__c == Null)
                {
                    a.Subscription_Expiry_Date1__c = dt1;
                    a.Membership_Expires_On__c = dtacc;
                    a.Membean_Expires_On__c = dtacc;
                    //acclst.add(a);
                }
                //acclst.add(a);
                
            }*/
            else if (o.StageName != 'Close Won' && o.StageName != 'Close Lost' && o.Membean_Extension_Date__c != Null)
            {
                //a.Previous_Subscription_Expiry_Date__c = a.Subscription_Expiry_Date1__c;
                if (a.Membership_Expires_On__c < o.Membean_Extension_Date__c)
                {
                    //a.Previous_Membership_Expires_On__c = a.Membership_Expires_On__c;
                    a.Membership_Expires_On__c = o.Membean_Extension_Date__c;
                    a.Membean_Expires_On__c = o.Membean_Extension_Date__c;
                }
                if (a.Subscription_Expiry_Date1__c < o.Membean_Extension_Date__c)
                {
                    //a.Subscription_Expiry_Date1__c = o.Membean_Extension_Date__c;
                }
                if (a.Teacher_Email__c == Null)
                    a.Teacher_Email__c = o.Teacher__r.Email;
                if ((a.Parent_Pay__c == FALSE) && (o.Student_Pay__c == TRUE))
                    a.parent_Pay__c = TRUE;
                if ((o.Student_Pay__c == FALSE) && (othpayOpp.Size() == 0))
                        a.parent_Pay__c = FALSE;
                if (qlst.size()>0)
                    a.Student_Rate__c = qlst[0].unitprice;
                else if (qlstoth.size()>0)
                        a.Student_Rate__c = qlstoth[0].unitprice;
                //a.Temp_Ready_for_Membean_Sync__c = TRUE;
                if (a.School_Id__c != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                {
                    a.Temp_Ready_for_Membean_Sync__c = TRUE;
                    a.Ready_for_Membean_Sync__c = TRUE;
                }
                acclst.add(a);
            }
            else if (o.StageName == 'Close Won')
            {
                Date accntSubExpdt = a.Subscription_Expiry_Date1__c;
                system.debug('accntSubExpdt::: ' + accntSubExpdt);
                System.debug('INside CLose Won:::' );
                recProceed = 'Yes';
                List<Opportunity> sameyearoppty = [Select Id,StageName from Opportunity where Subscription_Start_Year__c = :o.Subscription_Start_Year__c AND AccountId = :o.AccountId AND Id != :o.Id];
                Boolean firstOppty = TRUE;
                for (Opportunity opp :sameyearoppty)
                {
                    if (opp.StageName == 'Close Won')
                        firstOppty = FALSE;
                }
                Integer days = Date.daysInMonth(Integer.valueOf(o.Subscription_End_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c));
                Date dt = Date.newInstance(Integer.valueOf(o.Subscription_End_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                Integer oppyears = Integer.valueOf(o.Subscription_End_Year__c) - Integer.valueOf(o.Subscription_Start_Year__c);
                Date dtadd1;
                
                dtadd1 = Date.newInstance(Integer.valueOf(o.Subscription_Start_Year__c)+1, integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                Date dtadd2 = Date.newInstance(Integer.valueOf(o.Subscription_Start_Year__c)+1, integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                system.debug('dtadd1::: ' + dtadd1);
                system.debug('dt::: ' + dt);
                system.debug('oppyears::: ' + oppyears);
                // Adding Subscription Years to Account
                numYears = integer.valueOf(o.Subscription_End_Year__c) - integer.ValueOf(o.Subscription_Start_Year__c);
                //08.25.2022
                /*if (a.Membean_Expires_On__c != Null && a.Membean_Expires_On__c > dtadd1)
                    numberDays = dtadd1.daysBetween(a.Membean_Expires_On__c);
                if (a.Membean_Expires_On__c != Null && a.Membean_Expires_On__c <= dtadd1)
                    numberDays = a.Membean_Expires_On__c.daysBetween(dtadd1);
                    
                if (a.Membean_Expires_On__c != Null && a.Membean_Expires_On__c > todayDt)
                    daystoconsider = a.Membean_Expires_On__c.daysBetween(todayDt);*/
                    
                /*if (a.Subscription_Expiry_Date1__c != Null && a.Subscription_Expiry_Date1__c > dtadd1)
                    numberDays = dtadd1.daysBetween(a.Subscription_Expiry_Date1__c );
                if (a.Subscription_Expiry_Date1__c != Null && a.Subscription_Expiry_Date1__c <= dtadd1)
                    numberDays = a.Subscription_Expiry_Date1__c.daysBetween(dtadd1);
                    
                if (a.Subscription_Expiry_Date1__c != Null && a.Subscription_Expiry_Date1__c > todayDt)
                    daystoconsider = a.Subscription_Expiry_Date1__c.daysBetween(todayDt);*/
                    
                if (accntSubExpdt != Null && accntSubExpdt > dtadd1)
                    numberDays = dtadd1.daysBetween(accntSubExpdt);
                if (accntSubExpdt != Null && accntSubExpdt <= dtadd1)
                    numberDays = accntSubExpdt.daysBetween(dtadd1);
                    
                if (accntSubExpdt != Null && accntSubExpdt > todayDt)
                    daystoconsider = accntSubExpdt.daysBetween(todayDt);
                
                for (integer i=0;i<numYears;++i)
                {
                    val = integer.valueof(o.Subscription_Start_Year__c)+i;
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
                    
                if (a.Teacher_Email__c == Null)
                        a.Teacher_Email__c = o.Teacher__r.Email;
                
                a.No_Of_Teachers__c = o.No_Of_Teachers__c;
                a.No_Of_Students__c = o.No_Of_Students__c;
                //if ((a.Subscription_Expiry_Date1__c == Null) || (dt >= a.Subscription_Expiry_Date1__c))
                if ((accntSubExpdt == Null) || (dt >= accntSubExpdt))
                {
                    // Added 08.03.2021
                    if (accntSubExpdt == Null) //New Customers
                    {
                        a.Subscription_Expiry_Date1__c = dtadd1;
                        a.Membean_Expires_On__c = dtadd2;
                        integer newdays = -10;
                        Date dtaddnew = Date.newInstance(Integer.valueOf(o.Subscription_Start_Year__c), integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                        Date dtaddnew1 = Date.newInstance(Integer.valueOf(o.Subscription_Start_Year__c)+1, integer.valueOf(a.Subscription_Expiry_Month_Calc__c), days);
                        
                        if (dtaddnew > system.Today())
                            newdays = dtaddnew.daysBetween(todayDt);
                        if (system.Today() > dtaddnew || (newdays < 30 && newdays >=0))
                        {
                            a.Membean_Expires_On__c = dtaddnew1;
                        }
                        else
                        {
                            a.Membean_Expires_On__c = dtaddnew;
                        }
                    }
                    if (accntSubExpdt != Null && dt >= accntSubExpdt && firstOppty == TRUE) //Returning Customers
                        a.Subscription_Expiry_Date1__c = dtadd1;     
                    // End Code Change
                           
                    if (firstOppty == TRUE)
                    {
                        //a.Previous_Subscription_Expiry_Date__c = a.Subscription_Expiry_Date1__c;
                        //a.Previous_Membership_Expires_On__c = a.Membership_Expires_On__c;
                        a.Membership_Expires_On__c = dtadd1;
                    }
                    if (accntSubExpdt < dt || accntSubExpdt == Null)
                        a.Subscription_Expiry_Date1__c = dt;
                    a.AnnualRevenue = o.Amount;
                    numberDays = 0;
                    // 08.25.2022
                    /*if (a.Membean_Expires_On__c != Null && a.Membean_Expires_On__c > dtadd1)
                    {
                        numberDays = dtadd1.daysBetween(a.Membean_Expires_On__c);
                        if (numberDays <=30 && firstOppty == TRUE)
                            a.Membean_Expires_On__c = dtadd1;
                    }
                    else if (a.Membean_Expires_On__c != Null && a.Membean_Expires_On__c <= dtadd1)
                    {
                        if ((integer.valueOf(o.Subscription_Start_Year__c) - a.Membean_Expires_On__c.Year() <= 1) && (firstOppty == TRUE))
                        {
                            //numberDays = a.Membean_Expires_On__c.daysBetween(dtadd1);
                            Date todaydate1 = System.Today();
                            Integer numDays = todaydate1.daysBetween(a.Membean_Expires_On__c);
                            if (numDays <=30 && firstOppty == TRUE)
                                a.Membean_Expires_On__c = dtadd1;
                        }
                    }*/
                    //if (a.Subscription_Expiry_Date1__c != Null && a.Subscription_Expiry_Date1__c > dtadd1)
                    if (accntSubExpdt != Null && accntSubExpdt > dtadd1)
                    {
                        numberDays = dtadd1.daysBetween(accntSubExpdt);
                        if (numberDays <=30 && firstOppty == TRUE)
                            a.Membean_Expires_On__c = dtadd1;
                    }
                    //else if (a.Subscription_Expiry_Date1__c != Null && a.Subscription_Expiry_Date1__c <= dtadd1)
                    else if (accntSubExpdt != Null && accntSubExpdt <= dtadd1)
                    {
                        //if ((integer.valueOf(o.Subscription_Start_Year__c) - a.Subscription_Expiry_Date1__c.Year() <= 1) && (firstOppty == TRUE))
                        if ((integer.valueOf(o.Subscription_Start_Year__c) - accntSubExpdt.Year() <= 1) && (firstOppty == TRUE))
                        {
                            //numberDays = a.Membean_Expires_On__c.daysBetween(dtadd1);
                            Date todaydate1 = System.Today();
                            Integer numDays = todaydate1.daysBetween(accntSubExpdt);
                            system.debug('inside numDays::: ' + numDays);
                            if (numDays <=30 && firstOppty == TRUE)
                                a.Membean_Expires_On__c = dtadd1;
                        }
                    }
                    
                    
                    //if ((numberDays <= 30) && (firstOppty == TRUE))
                        //a.Membean_Expires_On__c = dtadd1;   
                    
                    if ((a.Parent_Pay__c == FALSE) && (o.Student_Pay__c == TRUE))
                        a.parent_Pay__c = TRUE;
                    if ((o.Student_Pay__c == FALSE) && (othpayOpp.Size() == 0))
                        a.parent_Pay__c = FALSE;
                    if (qlst.size()>0)
                        a.Student_Rate__c = qlst[0].unitprice;
                    else if (qlstoth.size()>0)
                        a.Student_Rate__c = qlstoth[0].unitprice;
                    //a.Temp_Ready_for_Membean_Sync__c =  TRUE;
                    if (a.School_Id__c != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                    {
                        a.Temp_Ready_for_Membean_Sync__c = TRUE;
                        a.Ready_for_Membean_Sync__c = TRUE; // added 08.04.2021
                    }
                    
                    //acclst.add(a);
                }
                else
                {
                    a.AnnualRevenue =  o.Amount;
                    
                    if ((a.Parent_Pay__c == FALSE) && (o.Student_Pay__c == TRUE))
                        a.parent_Pay__c = TRUE;
                    if ((o.Student_Pay__c == FALSE) && (othpayOpp.Size() == 0))
                        a.parent_Pay__c = FALSE;
                    if (qlst.size()>0)
                        a.Student_Rate__c = qlst[0].unitprice;
                    else if (qlstoth.size()>0)
                        a.Student_Rate__c = qlstoth[0].unitprice;
                    //a.Ready_for_Membean_Sync__c = TRUE;
                    //08.25.2022
                    /*if ((a.Membean_Expires_On__c < dtadd1) && (firstOppty == TRUE) && (daystoconsider <= 30))
                    {
                        a.Membean_Expires_On__c = dtadd1;
                        a.Membership_Expires_On__c = dtadd1;
                    }*/
                    if ((a.Subscription_Expiry_Date1__c < dtadd1) && (firstOppty == TRUE) && (daystoconsider <= 30))
                    {
                        a.Membean_Expires_On__c = dtadd1;
                        a.Membership_Expires_On__c = dtadd1;
                    }
                    //a.Temp_Ready_for_Membean_Sync__c =  TRUE; 
                    if (a.School_Id__c != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                    {
                        a.Temp_Ready_for_Membean_Sync__c = TRUE;
                        a.Ready_for_Membean_Sync__c = TRUE;
                    }
                        
                    //acclst.add(a);
                }
            }
            else if (o.StageName ==  'Close Lost')
            {
                Integer days = 0;
                Date dt;
                Integer oppyears = 1;
                // Setting Membean Subscription Expiray Dates and Acount data
                List<Opportunity> pilotopp = [select id, name, AccountId, Pilot_End_Date__c, Subscription_Start_Year__c, Subscription_End_Year__c, No_of_Students__c, No_of_Teachers__c, Amount, Subscription__c, Account.Parent_Pay__c, Student_Pay__c, StageName,Subscription_Processed__c from opportunity where Pilot_End_Date__c != Null AND StageName != 'Close Won' AND Stagename != 'Close Lost' AND AccountId = :a.Id Order by Subscription_Start_Year__c ASC];
                List<Opportunity> subopp = [select id, name, AccountId, Pilot_End_Date__c, Subscription_Start_Year__c, Subscription_End_Year__c, No_of_Students__c, No_of_Teachers__c, Amount, Subscription__c, Account.Parent_Pay__c, Student_Pay__c, StageName,Subscription_Processed__c from opportunity where StageName = 'Close Won' AND AccountId = :a.Id Order by Subscription_Start_Year__c ASC];
                List<Contract> delcontracts = [Select Id from Contract where AccountId = :a.Id];
                List<Contract> inscontracts = New LIst<Contract>();
                if (delcontracts.size()>0)
                    delete delcontracts;
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
                for (Opportunity opp : pilotopp)
                {
                    if (prevOppid == '' || prevOppid != opp.Id)
                    {
                        pilotAnnualRev = 0;
                        pilotStudentcnt = 0;
                        pilotTeachercnt = 0;
                    }
                    prevOppid = opp.Id;
                    Years.add(String.valueOf(opp.Pilot_End_Date__c.Year()));
                    if (opp.Amount != Null)
                        pilotAnnualRev = pilotAnnualRev + opp.Amount;
                    if (opp.No_of_Students__c != Null)   
                        pilotStudentcnt = pilotStudentcnt + opp.No_of_Students__c;
                    if (opp.No_of_Teachers__c != Null)  
                        pilotTeachercnt = pilotTeachercnt + opp.No_of_Teachers__c;
                    LatestpilotEndDate = opp.Pilot_End_Date__c;
                }
                
                for (Opportunity opp : subopp)
                {
                    if (prevOppid == '' || prevOppid != opp.Id)
                    {
                        subAnnualRev = 0;
                        subStudentcnt = 0;
                        subTeachercnt = 0;
                    }
                    prevOppid = opp.Id;
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
                        newcon = New Contract();
                        newcon.Subscription_Start_Year__c = String.valueOf(integer.valueof(opp.Subscription_Start_Year__c)+i);
                        newcon.Subscription_End_Year__c = String.valueOf(integer.valueof(opp.Subscription_Start_Year__c)+i+1);
                        newcon.AccountId = a.Id;
                        newcon.No_of_Students__c = opp.No_of_Students__c;
                        newcon.No_of_Teachers__c = opp.No_of_Teachers__c;
                        newcon.Amount__c = opp.Amount;
                        insertContracts.add(newcon);
                    }    
                }
                if (o.Prior_Stage__c == 'Close Won')
                {
                    Integer numberDaysDiff = 0;
                    Date olddt = System.Today();
                    olddt = olddt.addDays(-150);
                    if (a.Previous_Membership_Expires_On__c != Null)
                    {
                        numberDaysDiff = a.Previous_Membership_Expires_On__c.daysBetween(system.Today());
                        if (numberDaysDiff > 150)
                        {
                            a.Membean_Expires_On__c = olddt; 
                        }
                        else
                        {
                             a.Membean_Expires_On__c = a.Previous_Membership_Expires_On__c;  
                        }
                    }
                    else if (a.Previous_Membership_Expires_On__c == Null)
                    {
                        a.Membean_Expires_On__c = olddt; 
                    }
                    a.Subscription_Expiry_Date1__c = a.Previous_Subscription_Expiry_Date__c;
                    if (othpayOpp.Size() > 0)
                        a.parent_Pay__c = TRUE;
                    if ((o.Student_Pay__c == TRUE) && (othpayOpp.Size() == 0))
                        a.parent_Pay__c = FALSE;
                }
                
                subAnnualRev = subAnnualRev  + pilotAnnualRev;
                subStudentcnt = subStudentcnt + pilotStudentcnt;
                subTeachercnt = subTeachercnt + pilotTeachercnt;
                Set<String> setYears = New Set<String>();
                if (Years.size()>0)
                {
                    Years.sort();
                    setYears.addAll(Years); 
                    Years.addAll(setYears);   
                }
                String newsubYears = '';
                for (integer i=0;i<Years.Size();++i)
                {
                    newsubYears = newSubYears + Years[i] + ';';    
                }
                newsubYears = newSubYears.removeEnd(';');
                a.Subscription_Years__c = newSubYears;
                a.No_Of_Students__c = subStudentcnt;
                a.No_Of_Teachers__c = subTeachercnt;
                
                if (a.School_Id__c  != Null && a.RecordType.Name != 'District' && a.RecordType.Name != 'Tutoring')
                {
                    a.Temp_Ready_for_Membean_Sync__c = TRUE;
                    a.Ready_for_Membean_Sync__c = TRUE;
                }
                acclst.add(a);

            }
            //if (acclst.Size()>0)
                //update acclst;
            
            system.debug('recProceed:::' + recProceed);
            if (recProceed == 'Yes')
            {
                //List<Account> acclstn = New List<Account>();
                Integer daysn = Date.daysInMonth(Integer.valueOf(o.Subscription_Start_Year__c), integer.valueOf(aorig.Subscription_Expiry_Month_Calc__c));
                Date dtn = Date.newInstance(Integer.valueOf(o.Subscription_Start_Year__c)+1, integer.valueOf(aorig.Subscription_Expiry_Month_Calc__c), daysn);
                Integer oppyearsn = Integer.valueOf(o.Subscription_End_Year__c) - Integer.valueOf(o.Subscription_Start_Year__c);
                Date dtadd1n;
                Integer numDaysn = 0;
                dtadd1n = Date.newInstance(Integer.valueOf(o.Subscription_Start_Year__c), integer.valueOf(aorig.Subscription_Expiry_Month_Calc__c), daysn);
                Date dtadd2n = Date.newInstance(Integer.valueOf(o.Subscription_End_Year__c), integer.valueOf(aorig.Subscription_Expiry_Month_Calc__c), daysn);
                system.debug('dtadd1n::: ' + dtadd1n);
                //Bluebird schools
                if (aorig.Subscription_Years__c == NULL && aorig.Pilot_Years__c == Null && aorig.Membean_Expires_On__c == Null && aorig.School_ID__c != '')
                {
                    if (system.Today() <= dtadd1n)
                    {
                        numDaysn =  system.Today().daysBetween(dtadd1n);
                        system.debug('1:::');
                        system.debug('numDaysn:::' + numDaysn);
                        if (numDaysn <= 30)
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtn;
                            //acclst.add(a);
                        }
                        else
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtadd1n;
                           //acclst.add(a);
                        }
                    }
                    else
                    {
                        system.debug('1 else:::');
                        a.Subscription_Expiry_Date1__c = dtadd2n;
                        //a.Membean_Expires_On__c = dtadd1n;
                        a.Membean_Expires_On__c = dtn;
                        //acclst.add(a);
                    }
                }
                else if ((system.Today() <= dtadd1n) && (String.valueOf(System.Today().Year()) <= o.Subscription_Start_Year__c))
                {
                    if (aorig.Membean_Expires_On__c != Null)
                        numDaysn =  system.Today().daysBetween(aorig.Membean_Expires_On__c);
                    else
                        numDaysn = 0;
                    system.debug('2:::');
                    system.debug('numDaysn:::' + numDaysn);
                    system.debug('aorig.Membean_Expires_On__c::: ' + aorig.Membean_Expires_On__c);
                    if (aorig.Membean_Expires_On__c == dtadd1n && aorig.Subscription_Expiry_Date1__c >= dtadd1n)
                    {
                        system.debug('2-1:::');
                        
                        if (numDaysn <= 30)
                        {
                            if (aorig.Subscription_Expiry_Date1__c < dtadd2n)
                                a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtn;
                            //acclst.add(a);
                        }
                        else
                        {
                            if (aorig.Subscription_Expiry_Date1__c < dtadd2n)
                                a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtadd1n;
                            //acclst.add(a);
                        }
                    }
                    else if (aorig.Membean_Expires_On__c < system.Today() && aorig.Subscription_Expiry_Date1__c < system.Today())
                    {
                        system.debug('2-1else:::');
                        if (numDaysn <= 30)
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtn;
                            //acclst.add(a);
                        }
                        else
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtadd1n;
                            //acclst.add(a);
                        }
                    }
                    else if (aorig.Membean_Expires_On__c == dtadd1n && aorig.Subscription_Expiry_Date1__c == Null)
                    {
                        system.debug('2-2else:::');
                        if (numDaysn <= 30)
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtn;
                            //acclst.add(a);
                        }
                        else
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtadd1n;
                            //acclst.add(a);
                        }
                    }
                    else if (aorig.Membean_Expires_On__c < dtadd1n && aorig.Subscription_Expiry_Date1__c == Null)
                    {
                        system.debug('2-3else:::');
                        if (numDaysn <= 30)
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtn;
                            //acclst.add(a);
                        }
                        else
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtadd1n;
                            //acclst.add(a);
                        }
                    }
                    else if (aorig.Membean_Expires_On__c < dtadd1n && aorig.Subscription_Expiry_Date1__c < system.Today())
                    {
                        system.debug('2-4else:::');
                        if (numDaysn <= 30)
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtn;
                            //acclst.add(a);
                        }
                        else
                        {
                            a.Subscription_Expiry_Date1__c = dtadd2n;
                            a.Membean_Expires_On__c = dtadd1n;
                            //acclst.add(a);
                        }
                    }
                    else if (aorig.Membean_Expires_On__c == Null && aorig.Subscription_Expiry_Date1__c == Null)
                    {
                        system.debug('2-5else:::');
                        a.Subscription_Expiry_Date1__c = dtadd2n;
                        a.Membean_Expires_On__c = dtadd1n;
                        //acclst.add(a);
                    }
                    
                }
                else if (system.Today() > dtadd1n)
                {
                    system.debug('3:::');
                    if (integer.valueOf(aorig.Subscription_Expiry_Month_Calc__c) != 12)
                    {
                        a.Subscription_Expiry_Date1__c = dtadd2n;
                        a.Membean_Expires_On__c = dtn;
                    }
                    else
                    {
                        a.Subscription_Expiry_Date1__c = dtadd2n;
                        a.Membean_Expires_On__c = dtn;
                    }
                    //acclst.add(a);
                }
                //acclst.add(a);
                if (acclst.Size()==0)
                    acclst.add(a);    
            }
            if (acclst.Size()==0)
                    acclst.add(a);    
            if (acclst.Size()>0)
                    update acclst;     
                
                
            a = [Select Id, RecordType.Name, School_ID__c, AnnualRevenue, Teacher_Email__c, Subscription_Status__c , AnnualRevenue__c, Subscription_Years__c, Parent_Pay__c, Previous_Pilot_End_Date__c, LatestPilotEndDate1__c, Previous_Membership_Expires_On__c, Previous_Subscription_Expiry_Date__c, Subscription_Expiry_Date1__c, Student_Rate__c, Ready_for_Membean_Sync__c, Temp_Ready_for_Membean_Sync__c,Membean_Expires_On__c, Membership_Expires_On__c, Subscription_Expiry_Month_Calc__c,No_Of_Students__c,No_Of_Teachers__c,Pilot_Years__c from Account where Id = :o.AccountId];
            subscriptions = [Select Id, Name, Subscription_Start_Year__c, Subscription_End_Year__c, AccountId, No_of_Students__c, No_of_Teachers__c, Amount__c from Contract where AccountId = :a.Id];
            Boolean newflag = false;
            if (o.StageName == 'Close Won') // Handling Subscription records
            {
                if (o.Refund__c == 'Full Refund' || o.Refund__c == 'Partial Refund')
                {
                    for (integer i=0;i<Years.Size();++i)
                    {
                        for(Contract con : subscriptions)
                        {
                            if(con.Subscription_Start_Year__c == Years[i] && con.Subscription_End_Year__c == String.valueOf(integer.valueof(Years[i])+1))
                            {
                                if (con.Amount__c - (o.Refunded_Amount__c/Years.Size()) <= 0)
                                    deletecontracts.add(con);
                                else
                                {
                                    con.No_of_Students__c = con.No_of_Students__c - o.No_of_Students__c;
                                    con.No_of_Teachers__c = con.No_of_Teachers__c - o.No_of_Teachers__c;
                                    con.Amount__c = con.Amount__c - (o.Refunded_Amount__c/Years.Size());
                                    updateContracts.add(con);
                                }
                            }
                            if (i==0)
                            {
                                a.No_of_Students__c = con.No_of_Students__c - o.No_of_Students__c;
                                a.No_Of_Teachers__c = con.No_of_Teachers__c - o.No_of_Teachers__c;
                                if (a.AnnualRevenue__c != Null)
                                    a.AnnualRevenue__c = a.AnnualRevenue__c - (o.Refunded_Amount__c/Years.Size());
                                else
                                    a.AnnualRevenue__c = 0;   
                                update a;
                            }                
                        }
                    }
                    o.Refund__c = Null;
                }
                else if (subscriptions.size() == 0)
                {
                    for (integer i=0;i<Years.Size();++i)
                    {
                        newcon = New Contract();
                        newcon.Subscription_Start_Year__c = Years[i];
                        newcon.Subscription_End_Year__c = String.valueOf(integer.valueof(Years[i])+1);
                        newcon.AccountId = a.Id;
                        newcon.No_of_Students__c = o.No_of_Students__c;
                        newcon.No_of_Teachers__c = o.No_of_Teachers__c;
                        newcon.Amount__c =  o.Amount/Years.Size();
                        insertContracts.add(newcon);
                        if (i==0 && (numberDays <= 30 || integer.valueOf(o.Subscription_Start_Year__c) <= a.Membean_Expires_On__c.Year()))
                        {
                            a.No_of_Students__c = o.No_Of_Students__c;
                            a.No_Of_Teachers__c = o.No_Of_Teachers__c;
                            a.AnnualRevenue__c = o.Amount/Years.Size();
                            update a;
                        }
                    }
                }
                else
                {
                    Boolean create = true;
                    for (integer i=0;i<Years.Size();++i)
                    {
                        create =  true;
                        for(Contract con : subscriptions)
                        {
                            if(con.Subscription_Start_Year__c == Years[i] && con.Subscription_End_Year__c == String.valueOf(integer.valueof(Years[i])+1))
                            {
                                con.No_of_Students__c = con.No_of_Students__c + o.No_of_Students__c;
                                con.No_of_Teachers__c = con.No_of_Teachers__c + o.No_of_Teachers__c;
                                con.Amount__c = con.Amount__c + (o.Amount/Years.Size());
                                updateContracts.add(con);
                                create = false;
                                if (i==0 && (numberDays <= 30 || integer.valueOf(o.Subscription_Start_Year__c) <= a.Membean_Expires_On__c.Year()))
                                {
                                    //a.No_Of_Students__c = con.No_of_Students__c + o.No_of_Students__c;
                                    //a.No_Of_Teachers__c = con.No_of_Teachers__c + o.No_of_Teachers__c;
                                    a.No_Of_Students__c = con.No_of_Students__c;
                                    a.No_Of_Teachers__c = con.No_of_Teachers__c;
                                    a.AnnualRevenue__c = con.Amount__c;
                                    update a;
                                }
                            }         
                        }
                        if (create == true)
                        {
                            newcon = New Contract();
                            newcon.Subscription_Start_Year__c = Years[i];
                            newcon.Subscription_End_Year__c = String.valueOf(integer.valueof(Years[i])+1);
                            newcon.AccountId = a.Id;
                            newcon.No_of_Students__c = o.No_of_Students__c;
                            newcon.No_of_Teachers__c = o.No_of_Teachers__c;
                            newcon.Amount__c =  o.Amount/Years.Size();
                            insertContracts.add(newcon);
                            if (i==0 && (numberDays <= 30 || integer.valueOf(o.Subscription_Start_Year__c) <= a.Membean_Expires_On__c.Year()))
                            {
                                a.No_of_Students__c = o.No_Of_Students__c;
                                a.No_Of_Teachers__c = o.No_Of_Teachers__c;
                                a.AnnualRevenue__c = o.Amount/Years.Size();
                                update a;
                            }
                        }  
                    }
                }
            }
            else if (o.StageName == 'Close Lost') // Handling Subscription records
            {
                for (integer i=0;i<Years.Size();++i)
                {
                    for(Contract con : subscriptions)
                    {
                        if(con.Subscription_Start_Year__c == Years[i] && con.Subscription_End_Year__c == String.valueOf(integer.valueof(Years[i])+1))
                        {
                            if (con.Amount__c - (o.Refunded_Amount__c/Years.Size()) <= 0)
                                    deletecontracts.add(con);
                            else
                            {
                                con.No_of_Students__c = con.No_of_Students__c - o.No_of_Students__c;
                                con.No_of_Teachers__c = con.No_of_Teachers__c - o.No_of_Teachers__c;
                                con.Amount__c = con.Amount__c - (o.Amount/Years.Size());
                                updateContracts.add(con);
                            }
                            if (i==0)
                            {
                                a.No_of_Students__c = con.No_of_Students__c - o.No_of_Students__c;
                                a.No_Of_Teachers__c = con.No_of_Teachers__c - o.No_of_Teachers__c;
                                if (a.AnnualRevenue__c != Null)
                                    a.AnnualRevenue__c = a.AnnualRevenue__c - (o.Amount/Years.Size());
                                else
                                    a.AnnualRevenue__c = 0;
                                update a;
                            }
                        }                
                    }
                }
            }
            if (insertContracts.size()>0)
                insert insertContracts;
            if (updateContracts.size()>0)
                update updateContracts;
            if (deletecontracts.Size()>0)
                delete deletecontracts;
            o.Membean_Extension_Date__c =  Null;
            o.Subscription_Processed__c = FALSE;
            update o;
            
                 
        }
    }
}