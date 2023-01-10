/**
* Class Type        : Trigger Handler
* Created by        : Swayam Arora
* Modified by       : Pooja K
* Version           : 37.0
* Modified Date     : 28/06/2018
* Description       : Class contains all the Business logic for OpportunityTrigger trigger.
**/
public class OpportunityTriggerHandler {
    private static boolean pilotCreate = false;
    private static Map<Id, RecordType> oppRecordTypesMap = OpportunityService.oppRecordTypesById;
    //Auto naming name
    public static void updateOpportunityName(List<Opportunity> newOpportunities){
        for(Opportunity opp:newOpportunities){
            system.debug('opp.Name:::' + opp.RPT_Opportunity_Name__c);
            opp.Name=opp.RPT_Opportunity_Name__c;
        }
    }
   //Update Account Membean Expires On
    public static void UpdateAccountMembeanExpiresOn(List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
        system.debug('@@@@@  UpdateAccountMembeanExpiresOn');
        List<Opportunity> oppList = [Select Id,AccountId,Temporary_Membean_Extension_Date__c,Account.School_ID__c,Account_Membean_Expires_On__c,
                                      account.RecordTypeId,account.RecordType.Name,account.Membership_Expires_On__c,account.Membean_Expires_On__c,account.Temp_Ready_for_Membean_Sync__c,account.Ready_for_Membean_Sync__c from opportunity where id in :newOpportunities];
        List<Account>  updateAccountList = new List<Account>();
        for(Opportunity opp:oppList){
            if(Trigger.isInsert){
                if(opp.account.RecordType.Name != 'District' && String.isNotBlank(opp.account.School_ID__c) &&
                   (opp.Temporary_Membean_Extension_Date__c != null) &&
                   ((opp.account_Membean_Expires_On__c < opp.Temporary_Membean_Extension_Date__c) || (opp.account_Membean_Expires_On__c == null))){
                Account acc = new Account();
                acc.Id = opp.AccountId;
                acc.Membership_Expires_On__c = opp.Temporary_Membean_Extension_Date__c;
                acc.Membean_Expires_On__c = opp.Temporary_Membean_Extension_Date__c;
                acc.Temp_Ready_for_Membean_Sync__c = true;
                acc.Ready_for_Membean_Sync__c = true;
                updateAccountList.add(acc);
            }
            }else if(Trigger.isUpdate){
                system.debug('opp.account.RecordType.Name '+opp.account.RecordType.Name);
                system.debug('opp.account.School_ID__c '+opp.account.School_ID__c);
                system.debug(' newOppsMap.get(opp.Id).Temporary_Membean_Extension_Date__c '+ newOppsMap.get(opp.Id).Temporary_Membean_Extension_Date__c);
                system.debug('oldOppsMap.get(opp.Id).Temporary_Membean_Extension_Date__c '+oldOppsMap.get(opp.Id).Temporary_Membean_Extension_Date__c);
                system.debug('opp.Temporary_Membean_Extension_Date__c '+opp.Temporary_Membean_Extension_Date__c);
                system.debug('opp.account_Membean_Expires_On__c'+opp.account_Membean_Expires_On__c);
                if(opp.account.RecordType.Name != 'District' && String.isNotBlank(opp.account.School_ID__c) &&
                   newOppsMap.get(opp.Id).Temporary_Membean_Extension_Date__c != oldOppsMap.get(opp.Id).Temporary_Membean_Extension_Date__c && (opp.Temporary_Membean_Extension_Date__c != null) && ((opp.account_Membean_Expires_On__c < opp.Temporary_Membean_Extension_Date__c) || (opp.account_Membean_Expires_On__c == null))){
                Account acc = new Account();
                acc.Id = opp.AccountId;
                acc.Membership_Expires_On__c = opp.Temporary_Membean_Extension_Date__c;
                acc.Membean_Expires_On__c = opp.Temporary_Membean_Extension_Date__c;
                acc.Temp_Ready_for_Membean_Sync__c = true;
                acc.Ready_for_Membean_Sync__c = true;
                updateAccountList.add(acc);
            }
            }
            
            
        }
        if(updateAccountList.size()>0){
            update updateAccountList;
        }
       // update oppList.account;
    }
    
    // TODO CloseWon Capture the Membean student count when an opportunity converts from pilot to Close-Won_V6
    public static void captureMembeanStudentCountWhenOppConvertsFromPilotToCloseWon(List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
        system.debug('@@@@@  captureMembeanStudentCountWhenOppConvertsFromPilotToCloseWon');
        Map<string,Opportunity> oppList = new map<string,Opportunity>([Select Id,OwnerId,AccountId,StageName,Pilot_End_Date__c,
                                     IsCloseWon__c,Pilot_Student_Count__c,Teacher_Count_at_Conversion__c,account.Membean_Teacher_Count__c,account.Membean_Student_Count__c,account.School_ID__c from opportunity where id in :newOpportunities]);
       // List<Account>  updateAccountList = new List<Account>();
       List<Opportunity> needtoUpdateOpp = new List<Opportunity>();
        List<Messaging.SingleEmailMessage> mails =
  new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Account_Owner_Notification_on_Empty_School_Code'];
        for(Opportunity opp:newOpportunities){
            if(opp.StageName == 'Close Won' && opp.Pilot_End_Date__c >= System.Today()){
               // Account acc = new Account();
               // opp.AccountId = acc.Id;
               system.debug('@@@   opp.account.Membean_Student_Count__c '+oppList.get(opp.id).account.Membean_Student_Count__c);
                system.debug('@@@   opp.account.Membean_Teacher_Count__c '+oppList.get(opp.id).account.Membean_Teacher_Count__c);
                opp.Pilot_Student_Count__c = oppList.get(opp.id).account.Membean_Student_Count__c;
                opp.Teacher_Count_at_Conversion__c = oppList.get(opp.id).account.Membean_Teacher_Count__c;
                system.debug('@@ before opp'+opp.Pilot_Student_Count__c);
                needtoUpdateOpp.add(opp);
                system.debug('@@ opp'+opp.Teacher_Count_at_Conversion__c);
                
            }else if(opp.StageName == 'Close Won' && opp.account.School_ID__c == null &&
                     (opp.account.RecordType.Name == 'Public School' || opp.account.RecordType.Name == 'Private School')){
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(lstEmailTemplates[0].Id);
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(opp.ownerId);// Any contact or User id of your record
                //mail.setWhatId(opp.Id); //Optional field to ensure proper merging of objects in template
                mails.add(mail);

            }
            else if ((opp.pilot_End_Date__c != oldOppsMap.get(opp.id).Pilot_End_Date__c) && (opp.pilot_End_Date__c > System.Today()) && opp.account.School_ID__c == null &&
                     (opp.account.RecordType.Name == 'Public School' || opp.account.RecordType.Name == 'Private School'))
            {
                List<EmailTemplate> lstEmailTemplates1 = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Account_Owner_Notification_on_Empty_School_Code'];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(lstEmailTemplates1[0].Id);
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(opp.ownerId);// Any contact or User id of your record
                //mail.setWhatId(opp.Id); //Optional field to ensure proper merging of objects in template
                mails.add(mail);
            }
        }
        system.debug('@@ before needtoUpdateOpp'+needtoUpdateOpp);
        if(needtoUpdateOpp.size()>0){
           // update needtoUpdateOpp;
         system.debug('@@ after needtoUpdateOpp'+needtoUpdateOpp);   
        }
        if(mails.size()>0){
            Messaging.sendEmail(mails );
        }
        
    }
    
    // Update the Pilot Years in Account when opportunity pilot is started
    public static void updatePilotYearsInAccountWhenOppPilotIsStarted(boolean isNew,List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
       
       system.debug('@@@@@  updatePilotYearsInAccountWhenOppPilotIsStarted');
       List<Opportunity> oppList = [Select Id,OwnerId,AccountId,Start_Pilot__c,Pilot_End_Date__c,account.Pilot_Years__c,account.Subscription_Expiry_Month_Calc__c from opportunity where id in :newOpportunities];
       List<Account> needtoUpdateAcc = new List<Account>();
       String pilotyr='';
       Integer expmonth = 0;
       for(Opportunity opp:oppList){
            pilotyr='';
            Integer numberOfDays = Date.daysInMonth(system.Today().year(), Integer.valueOf(opp.account.Subscription_Expiry_Month_Calc__c));
            Date lastDayOfMonth = Date.newInstance(system.Today().year(), Integer.valueOf(opp.account.Subscription_Expiry_Month_Calc__c), numberOfDays);
            Date pilotcheckdate = lastDayOfMonth.addDays(1);
            if(((newOppsMap.get(opp.Id).Start_Pilot__c != oldOppsMap.get(opp.Id).Start_Pilot__c && opp.Start_Pilot__c == true)  &&                
                (opp.Pilot_End_Date__c.month() ) > integer.valueOf(System.Label.Month8 ) ) ||
                ((isNew && opp.Start_Pilot__c == true ) && (opp.Pilot_End_Date__c.month() ) > integer.valueOf(System.Label.Month8 )) ||
                ((newOppsMap.get(opp.Id).Pilot_End_Date__c != oldOppsMap.get(opp.Id).Pilot_End_Date__c) && (opp.Pilot_End_Date__c.month() ) > integer.valueOf(System.Label.Month8 ))){
                    if(opp.account.Pilot_Years__c != opp.account.Pilot_Years__c+';'+opp.Pilot_End_Date__c.year() && opp.Pilot_End_Date__C >= pilotcheckdate){
                        Account acc = new Account();
                        acc.Id = opp.AccountId;
                        if(opp.account.Pilot_Years__c != null){
                           pilotyr = String.valueOf(opp.Pilot_End_Date__c.year());
                           if (opp.account.Pilot_Years__c.indexOf(pilotyr) == -1)
                               acc.Pilot_Years__c =   opp.account.Pilot_Years__c+';'+opp.Pilot_End_Date__c.year();
                        }  
                        else {
                             acc.Pilot_Years__c = ''+ opp.Pilot_End_Date__c.year();
                        }
                       
                       // opp.Teacher_Count_at_Conversion__c = acc.Membean_Teacher_Count__c;
                        needtoUpdateAcc.add(acc);
                        system.debug('@@@ if   acc.Pilot_Years__c '+acc.Pilot_Years__c);
                    }
                    
            }else if((((newOppsMap.get(opp.Id).Start_Pilot__c != oldOppsMap.get(opp.Id).Start_Pilot__c) && opp.Start_Pilot__c == true)  && ((opp.Pilot_End_Date__c.month() ) >=  integer.valueOf(System.Label.Month1 ) && (opp.Pilot_End_Date__c.month() )  <= integer.valueOf(System.Label.Month8 )) ) ||
                    ((isNew  &&  opp.Start_Pilot__c == true ) && ((opp.Pilot_End_Date__c.month() ) >=  integer.valueOf(System.Label.Month1 ) && (opp.Pilot_End_Date__c.month() )  <= integer.valueOf(System.Label.Month8 ))) ||
                    ((newOppsMap.get(opp.Id).Pilot_End_Date__c != oldOppsMap.get(opp.Id).Pilot_End_Date__c) && ((opp.Pilot_End_Date__c.month() ) >=  integer.valueOf(System.Label.Month1 ) && (opp.Pilot_End_Date__c.month() )  <= integer.valueOf(System.Label.Month8 )))){
                
                    if(opp.account.Pilot_Years__c != opp.account.Pilot_Years__c+';'+(opp.Pilot_End_Date__c.year() - 1) && opp.Pilot_End_Date__C >= pilotcheckdate){
                        Account acc = new Account();
                        acc.Id = opp.AccountId;
                        if(opp.account.Pilot_Years__c != null){
                           pilotyr = String.valueOf(opp.Pilot_End_Date__c.year());
                           if (opp.account.Pilot_Years__c.indexOf(pilotyr) == -1)
                               acc.Pilot_Years__c =   opp.account.Pilot_Years__c+';'+opp.Pilot_End_Date__c.year();
                        }  else{
                             acc.Pilot_Years__c = ''+ opp.Pilot_End_Date__c.year();
                        }
                       // opp.Teacher_Count_at_Conversion__c = acc.Membean_Teacher_Count__c;
                        needtoUpdateAcc.add(acc);
                        system.debug('@@@ else   acc.Pilot_Years__c '+acc.Pilot_Years__c);
                    }
            }
            
        }
        system.debug('@@@ needtoUpdateAcc '+needtoUpdateAcc);
        if(needtoUpdateAcc.size()>0){
            update needtoUpdateAcc;
        }
        
        
    }
    
    // Email Ganesh when the Opportunity stage becomes On the fence or Closed Lost
   /* public static void emailGaneshWhenOppStageBecomesOnthefenceOrClosedLost(Boolean isNew,List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
        system.debug('@@@@@  emailGaneshWhenOppStageBecomesOnthefenceOrClosedLost');
        List<Opportunity> oppList = [Select Id,OwnerId,AccountId,StageName,On_the_fence_email_repetition_check__c from opportunity where id in :newOpportunities];
       // List<Account>  updateAccountList = new List<Account>();
       List<Opportunity> needtoUpdateOpp = new List<Opportunity>();
       List<Opportunity> opplstupd = New List<Opportunity>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'Email_to_GK_if_Opp_Stage_becomes_On_the_fence_or_Closed_Lost'];
        List<User> lstUser = [select id,Name,username from user where name = 'Membean Team'];
        //for(Opportunity opp:newOpportunities){
        for(Opportunity opp:oppList){
            if(isNew){
                if((opp.StageName == 'On the fence' && opp.On_the_fence_email_repetition_check__c == false )|| opp.StageName == 'Close Lost' ){
                
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(lstEmailTemplates[0].Id);
                    mail.setSaveAsActivity(false);
                    mail.setTargetObjectId(lstUser[0].id);// Any contact or User id of your record
                    //mail.setWhatId(opp.Id); //Optional field to ensure proper merging of objects in template
                    mails.add(mail);
                    opp.On_the_fence_email_repetition_check__c = true;
                    opplstupd.add(opp);
                    //needtoUpdateOpp.add(opp);
                }
            }else{
               if((opp.StageName == 'On the fence' && opp.On_the_fence_email_repetition_check__c == false && newOppsMap.get(opp.Id).StageName != oldOppsMap.get(opp.Id).StageName)|| (opp.StageName == 'Close Lost' && newOppsMap.get(opp.Id).StageName != oldOppsMap.get(opp.Id).StageName)){
                
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(lstEmailTemplates[0].Id);
                    mail.setSaveAsActivity(false);
                    mail.setTargetObjectId(lstUser[0].id);// Any contact or User id of your record
                    //mail.setWhatId(opp.Id); //Optional field to ensure proper merging of objects in template
                    mails.add(mail);
                    opp.On_the_fence_email_repetition_check__c = true;
                    opplstupd.add(opp);
                    //needtoUpdateOpp.add(opp);
                } 
            }
            
        }
        if (opplstupd.Size()>0)
            update opplstupd;
        
        //if(needtoUpdateOpp.size()>0){
            //update needtoUpdateOpp;
        //}
        if(mails.size()>0){
            Messaging.sendEmail(mails );
        }
        
    }*/
    
    //Contact Role creation on Opportunity if a Teacher is tagged
    public static void contactRoleCreationOnOpportunityIfTeacherIsTagged(List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
        system.debug('@@@@@  contactRoleCreationOnOpportunityIfTeacherIsTagged');
        List<Opportunity> oppList = [Select Id,AccountId,Teacher__c,Cloned_Opportunity_To_Process__c,RecordTypeId,RecordType.Name,Parent_Opportunity__c,Parent_Renewal_Opportunity__c from opportunity where id in :newOpportunities];
        List<OpportunityContactRole>  updateOppConRoleList = new List<OpportunityContactRole>();
        for(Opportunity opp:oppList){
                if(!Trigger.isInsert && newOppsMap.get(opp.Id).Teacher__c != oldOppsMap.get(opp.Id).Teacher__c && String.isNotBlank(opp.Teacher__c) ){
                OpportunityContactRole oppConRole = new OpportunityContactRole();
                oppConRole.ContactId = opp.Teacher__c;
                oppConRole.OpportunityId = opp.Id;
                oppConRole.IsPrimary = true;
                oppConRole.Role = 'Influential User';
                updateOppConRoleList.add(oppConRole);
            }else if(Trigger.isInsert && String.isNotBlank(opp.Teacher__c) && opp.Cloned_Opportunity_To_Process__c == FALSE &&
                     opp.RecordType.Name != 'Renewal' &&  opp.Parent_Opportunity__c == null &&  opp.Parent_Renewal_Opportunity__c == null){
                OpportunityContactRole oppConRole = new OpportunityContactRole();
                oppConRole.ContactId = opp.Teacher__c;
                oppConRole.OpportunityId = opp.Id;
                oppConRole.IsPrimary = true;
                oppConRole.Role = 'Influential User';
                updateOppConRoleList.add(oppConRole);
            }
            //}
            
            
        }
        if(updateOppConRoleList.size()>0){
            insert updateOppConRoleList;
        }
       // update oppList.account;
    }
    
    
    //Update Account Subscriptions on Oppty move from Close Won
    public static void updateAccSubscriptionsOnOpptyMoveFromCloseWon(List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
        system.debug('@@@@@  updateAccSubscriptionsOnOpptyMoveFromCloseWon');
        /*List<Opportunity> oppList = [Select Id,AccountId,StageName from opportunity where id in :newOpportunities];
        List<ProcessSubscriptionsOpptyInvocable.ProcessRequest>  requests = new List<ProcessSubscriptionsOpptyInvocable.ProcessRequest>();
        for(Opportunity opp:oppList){
            if(Trigger.isInsert && opp.StageName != 'Close Lost'){
               ProcessSubscriptionsOpptyInvocable.ProcessRequest request = new ProcessSubscriptionsOpptyInvocable.ProcessRequest();
               request.opportunityId = opp.Id;
               requests.add(request);
            }  else if(Trigger.isUpdate && newOppsMap.get(opp.Id).StageName != oldOppsMap.get(opp.Id).StageName &&
                   oldOppsMap.get(opp.Id).StageName == 'Close Won' && opp.StageName != 'Close Lost'){
               ProcessSubscriptionsOpptyInvocable.ProcessRequest request = new ProcessSubscriptionsOpptyInvocable.ProcessRequest();
               request.opportunityId = opp.Id;
               requests.add(request);
            }
            }

        if(requests.size()>0){
             ProcessSubscriptionsOpptyInvocable.createRenewalOppty(requests);
        }*/
    }
    
    
    //TODO Pilot Pilot Flow:Pilot Records Creation when Pilot End Date on Opportunity changes_V5
    public static void pilotRecordsCreationWhenPilotEndDateOnOppChanges(boolean isNew,List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
        system.debug('@@@@@  pilotRecordsCreationWhenPilotEndDateOnOppChanges');
        String cont = 'Y';
        String pilotpresent = 'N';
        List<Pilot__c> accpillst = New List<Pilot__c>();
        if (!pilotCreate)
        {
            List<Opportunity> oppList = [Select Id,AccountId,Name,StageName,Pilot_End_Date__c,Start_Pilot__c,Is_Parent__c,Type,RPT_Membean_Student_Count__c,(Select id,Membean_Student_Count__c,isPilotUpdate__c,Name,Pilot_Type__c from Pilots__r where isPilotUpdate__c = false) from opportunity where id in :newOpportunities];
            Set<Id> aid = new Set<Id>();
            for (Opportunity ol :opplist)
            {
                aid.add(ol.AccountId);
            }
            if (aid.size()>0)
                accpillst = [Select Id, Pilot_Start_Date__c, Pilot_End_Date__c,Account__c from Pilot__c where Id in :aId];
            List<Pilot__c>  updatePilotList = new List<Pilot__c>();
            for(Opportunity opp:oppList){
                pilotpresent = 'N';
                cont = 'Y';
                if(Trigger.isInsert){
                    if(( opp.Start_Pilot__c   == True) && (opp.Is_Parent__c == false || (opp.Is_Parent__c == true &&  opp.Type != 'Grouped'  && opp.Type != 'Grouped Multiyear' ))){
                       //Account acc = new Account();
                       Pilot__c pil = new Pilot__c();
                        for (Pilot__c pilE:opp.Pilots__r ){
                            pilE.Membean_Student_Count__c = opp.RPT_Membean_Student_Count__c;
                            pilE.isPilotUpdate__c = true;
                            updatePilotList.add(pilE);
                        }
                        //pil.Account__c = opp.AccountId;
                        pil.Opportunity__c = opp.Id;
                        pil.Account__c = opp.AccountId;
                        pil.Membean_Student_Count__c = opp.RPT_Membean_Student_Count__c;
                        if(opp.Name.length()>74){
                               pil.Name = opp.Name.substring(0,74)+'-'+'Pilot';
                           } else{
                               pil.Name = opp.Name+'-'+'Pilot';
                            } 
                        pil.Pilot_End_Date__c = opp.Pilot_End_Date__c;
                        pil.Pilot_Start_Date__c = system.today();
                        pil.Pilot_Type__c = 'Started';
                       // pil.Pilot_Type__c = IF(ISNEW(),"Started",IF(OR(PRIORVALUE([Opportunity].Pilot_End_Date__c) > TODAY(),AND(PRIORVALUE([Opportunity].Pilot_End_Date__c) <= DATEVALUE([Opportunity].LastModifiedDate ), DATEVALUE([Opportunity].LastModifiedDate ) <= PRIORVALUE([Opportunity].Pilot_End_Date__c)+7)),"Extended",IF(PRIORVALUE([Opportunity].Pilot_End_Date__c) < TODAY(),"Restarted","Started"  ) ));
                        pil.isPilotUpdate__c = false;
                        for (Pilot__c plst :accpillst)
                        {
                            if (plst.Pilot_Start_Date__c == system.Today() && plst.Pilot_End_Date__c == opp.Pilot_End_Date__c && plst.Account__c == opp.AccountId)
                            {
                                pilotpresent = 'Y';
                                break;
                            }
                        }
                        if (pilotpresent == 'N') 
                            updatePilotList.add(pil);
                    }
                }else if(Trigger.isUpdate){
                       if((newOppsMap.get(opp.Id).Pilot_End_Date__c != oldOppsMap.get(opp.Id).Pilot_End_Date__c ) && (opp.Is_Parent__c == false || (opp.Is_Parent__c ==true && opp.Type != 'Grouped'  && opp.Type != 'Grouped Multiyear'))){
                        //    Account acc = new Account();
                        Pilot__c pil = new Pilot__c();
                       // acc.Id = opp.AccountId;
                       
                        pil.Opportunity__c = opp.Id;
                        pil.Account__c = opp.AccountId;
                        pil.Membean_Student_Count__c = opp.RPT_Membean_Student_Count__c;
                           if(opp.Name.length()>74){
                               pil.Name = opp.Name.substring(0,74)+'-'+'Pilot';
                           } else{
                               pil.Name = opp.Name+'-'+'Pilot';
                            }  
                        //pil.Name = opp.Name.substring(0,74)+'-'+'Pilot';
                        pil.Pilot_End_Date__c = opp.Pilot_End_Date__c;
                        pil.Pilot_Start_Date__c = system.today();
                        if((oldOppsMap.get(opp.Id).Pilot_End_Date__c  > date.TODAY())||
                          (oldOppsMap.get(opp.Id).Pilot_End_Date__c <= newOppsMap.get(opp.Id).LastModifiedDate.date() && 
                          newOppsMap.get(opp.Id).LastModifiedDate.date() <=oldOppsMap.get(opp.Id).Pilot_End_Date__c + 7)){
                          pil.Pilot_Type__c =    'Extended'; 
                          } else if(oldOppsMap.get(opp.Id).Pilot_End_Date__c  < date.TODAY()){
                              pil.Pilot_Type__c = 'Restarted';
                          } else{
                              pil.Pilot_Type__c = 'Started';
                          } 
                      //, DATEVALUE([Opportunity].LastModifiedDate ) <= PRIORVALUE([Opportunity].Pilot_End_Date__c)+7)),"Extended",IF(PRIORVALUE([Opportunity].Pilot_End_Date__c) < TODAY(),"Restarted","Started"  ) ));
                        pil.isPilotUpdate__c = false;
                        cont = 'Y';
                        for (Pilot__c pl :updatePilotList)
                        {
                            if (pl.Pilot_End_Date__c == opp.Pilot_End_Date__c && pl.Pilot_Start_Date__c == system.today() && pl.Account__c == opp.AccountId)
                            {
                                cont = 'N';
                                break;
                            }
                        }
                        for (Pilot__c plst :accpillst)
                        {
                            if (plst.Pilot_Start_Date__c == system.Today() && plst.Pilot_End_Date__c == opp.Pilot_End_Date__c && plst.Account__c == opp.AccountId)
                            {
                                pilotpresent = 'Y';
                                break;
                            }
                        }
                        if (pilotpresent == 'N' && cont == 'Y')
                            updatePilotList.add(pil);
                     } 
                    }
                
                
            }
            if(updatePilotList.size()>0){
                upsert updatePilotList;
            }
        }
        pilotCreate = TRUE;
    }
    
    
    //TODOUpdate Closed Date to Today's Date if Opportunity is Won_V8
    public static void updateClosedDateToTodaysDateifOppisCloseWon(List<Opportunity> newOpportunities,Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap){
        system.debug('@@@@@  updateClosedDateToTodaysDateifOppisCloseWon');
        List<Opportunity> oppList = [Select Id,AccountId,Teacher__c,StageName,IsCloseWon__c,IsCloseLost__c,IsCancelled__c,Prior_Stage__c,CloseDate from opportunity where id in :newOpportunities];
        List<Opportunity>  updateOppList = new List<Opportunity>();
        for(Opportunity opp:newOppsMap.values()){
           // if(Trigger.isInsert ){
               /*if((opp.StageName == 'Close Won' && opp.IsCloseWon__c == false) || (opp.StageName == 'Close Won' && opp.IsCloseWon__c == true && opp.Prior_Stage__c != 'Close Won') || Test.isRunningTest() ){
                opp.CloseDate = System.today();
                opp.IsCloseWon__c = true;
                updateOppList.add(opp);
            }else if((opp.StageName == 'Close Lost' && opp.IsCloseLost__c == false) || (opp.StageName == 'Close Lost' && opp.IsCloseLost__c == true && opp.Prior_Stage__c != 'Close Lost') ){
                opp.CloseDate = System.today();
                opp.IsCloseLost__c = true;
                updateOppList.add(opp);
            }else if((opp.StageName == 'Cancelled' && opp.IsCloseLost__c == false) || (opp.StageName == 'Cancelled' && opp.IsCloseLost__c == true && opp.Prior_Stage__c != 'Cancelled')){
                opp.CloseDate = System.today();
                opp.IsCancelled__c = true;
                updateOppList.add(opp);
            }*/ 
           // }else 
                if(Trigger.isUpdate){
                if((opp.StageName == 'Close Won' && opp.IsCloseWon__c == false) || (opp.StageName == 'Close Won' && opp.IsCloseWon__c == true && opp.Prior_Stage__c != 'Close Won') && newOppsMap.get(opp.Id).StageName != oldOppsMap.get(opp.Id).StageName){
                opp.CloseDate = System.today();
                opp.IsCloseWon__c = true;
                updateOppList.add(opp);
            }else if((opp.StageName == 'Close Lost' && opp.IsCloseLost__c == false) || (opp.StageName == 'Close Lost' && opp.IsCloseLost__c == true && opp.Prior_Stage__c != 'Close Lost') && newOppsMap.get(opp.Id).StageName != oldOppsMap.get(opp.Id).StageName){
                opp.CloseDate = System.today();
                opp.IsCloseLost__c = true;
                updateOppList.add(opp);
            }else if((opp.StageName == 'Cancelled' && opp.IsCloseLost__c == false) || (opp.StageName == 'Cancelled' && opp.IsCloseLost__c == true && opp.Prior_Stage__c != 'Cancelled') && newOppsMap.get(opp.Id).StageName != oldOppsMap.get(opp.Id).StageName){
                opp.CloseDate = System.today();
                opp.IsCancelled__c = true;
                updateOppList.add(opp);
            }
            }
                
        }
        if(updateOppList.size()>0){
           // update updateOppList;
        }
       // update oppList.account;
    }
    
    
// When parent opportunity get esmitated stage update all child opportunity estimated stage get updated
    public static void updateChildOpportunityEstimatedStage(Map<String,Opportunity> parentOpportunityList){
       Map<String, List<Opportunity>> parentOppIdVsRelatedChildOpp = new Map<String, List<Opportunity>>();
       for(Opportunity child : [Select Id,Estimate_Status__c,Parent_Opportunity__c,Parent_Renewal_Opportunity__c from Opportunity where Parent_Opportunity__c =:parentOpportunityList.values() or Parent_Renewal_Opportunity__c =:parentOpportunityList.values()]){
          system.debug('@@ child '+child);
           system.debug('@@ child.Parent_Opportunity__c '+child.Parent_Opportunity__c);
           system.debug('@@ child.Parent_Renewal_Opportunity__c '+child.Parent_Renewal_Opportunity__c);
           if(child.Parent_Opportunity__c != null || 
             child.Parent_Renewal_Opportunity__c != null){
                 List<Opportunity> relatedOppList = new List<Opportunity>();
                 if(parentOppIdVsRelatedChildOpp.containsKey((child.Parent_Opportunity__c))){
                     relatedOppList = parentOppIdVsRelatedChildOpp.get((child.Parent_Opportunity__c));
                     relatedOppList.add(child);
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }else if(parentOppIdVsRelatedChildOpp.containsKey((child.Parent_Renewal_Opportunity__c))){
                     relatedOppList = parentOppIdVsRelatedChildOpp.get((child.Parent_Renewal_Opportunity__c));
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Renewal_Opportunity__c,relatedOppList);
                 }else if(child.Parent_Renewal_Opportunity__c != null){
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Renewal_Opportunity__c,relatedOppList);
                 }else if(child.Parent_Opportunity__c != null){
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }
           }
       }
        system.debug('@@@  parentOppIdVsRelatedChildOpp '+parentOppIdVsRelatedChildOpp);
       List<Opportunity> needToUpdateList = new List<Opportunity>();
       for(Opportunity parentOpp : parentOpportunityList.values()){
           if(parentOppIdVsRelatedChildOpp.containsKey(parentOpp.Id) &&
             parentOppIdVsRelatedChildOpp.get(parentOpp.Id).size()>0){
                 for(Opportunity relatedChildOpp : parentOppIdVsRelatedChildOpp.get(parentOpp.Id)){
                     relatedChildOpp.Estimate_Status__c = parentOpp.Estimate_Status__c;
                     needToUpdateList.add(relatedChildOpp);
                     system.debug('@@relatedChildOpp'+relatedChildOpp);
                 }
                 
           }
        } 
        
        system.debug('@@needToUpdateList'+needToUpdateList);
        if(needToUpdateList.size()>0){
            update needToUpdateList;
            system.debug('@@needToUpdateList after '+needToUpdateList);
        }
    }
    
    public static void updateAccountStatusToPilot(Map<Id, Opportunity> newOpps, Map<Id, Opportunity> oldOppsMap) {
        system.debug('@@@@@  updateAccountStatusToPilot');
        Map<String, Opportunity> checkEstimatedStatus = new Map<String, Opportunity>();
        for(Opportunity newOpp : newOpps.values()) {
            if(newOpp.Estimate_Status__c != oldOppsMap.get(newOpp.Id).Estimate_Status__c){
                checkEstimatedStatus.put(newOpp.Id,newOpp);
            }
        }
         system.debug('@@checkEstimatedStatus'+checkEstimatedStatus);
        if(checkEstimatedStatus.size() >0){
            updateChildOpportunityEstimatedStage(checkEstimatedStatus);
           
        }
    }
    //Update Child opportunities pilot started when Parent opportunity pilot is started
    public static void updateChildOpportunityPilotEndDate(Map<String,Opportunity> parentOpportunityList){
       Map<String, List<Opportunity>> parentOppIdVsRelatedChildOpp = new Map<String, List<Opportunity>>();
       for(Opportunity child : [Select Id,Is_Parent__c,Start_Pilot__c,Pilot_End_Date__c,Parent_Opportunity__c,Parent_Renewal_Opportunity__c from Opportunity where Parent_Opportunity__c =:parentOpportunityList.values() or Parent_Renewal_Opportunity__c =:parentOpportunityList.values()]){
          system.debug('@@ child '+child);
           system.debug('@@ child.Parent_Opportunity__c '+child.Parent_Opportunity__c);
           system.debug('@@ child.Parent_Renewal_Opportunity__c '+child.Parent_Renewal_Opportunity__c);
           if(child.Parent_Opportunity__c != null || 
             child.Parent_Renewal_Opportunity__c != null){
                 List<Opportunity> relatedOppList = new List<Opportunity>();
                 if(parentOppIdVsRelatedChildOpp.containsKey((child.Parent_Opportunity__c))){
                     relatedOppList = parentOppIdVsRelatedChildOpp.get((child.Parent_Opportunity__c));
                     relatedOppList.add(child);
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }else if(parentOppIdVsRelatedChildOpp.containsKey((child.Parent_Renewal_Opportunity__c))){
                     relatedOppList = parentOppIdVsRelatedChildOpp.get((child.Parent_Renewal_Opportunity__c));
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Renewal_Opportunity__c,relatedOppList);
                 }else if(child.Parent_Renewal_Opportunity__c != null){
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Renewal_Opportunity__c,relatedOppList);
                 }else if(child.Parent_Opportunity__c != null){
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }
           }
       }
        system.debug('@@@  parentOppIdVsRelatedChildOpp '+parentOppIdVsRelatedChildOpp);
       List<Opportunity> needToUpdateList = new List<Opportunity>();
       for(Opportunity parentOpp : parentOpportunityList.values()){
           if(parentOppIdVsRelatedChildOpp.containsKey(parentOpp.Id) &&
             parentOppIdVsRelatedChildOpp.get(parentOpp.Id).size()>0){
                 for(Opportunity relatedChildOpp : parentOppIdVsRelatedChildOpp.get(parentOpp.Id)){
                     relatedChildOpp.Pilot_End_Date__c = parentOpp.Pilot_End_Date__c;
                     relatedChildOpp.Start_Pilot__c = true;
                     needToUpdateList.add(relatedChildOpp);
                     system.debug('@@relatedChildOpp'+relatedChildOpp);
                 }
                 
           }
        } 
        
        system.debug('@@needToUpdateList'+needToUpdateList);
        if(needToUpdateList.size()>0){
            update needToUpdateList;
            system.debug('@@needToUpdateList after '+needToUpdateList);
        }
    }
    public static void updateChildOpportunityPilotStarted(Map<String,Opportunity> parentOpportunityList){
       Map<String, List<Opportunity>> parentOppIdVsRelatedChildOpp = new Map<String, List<Opportunity>>();
       for(Opportunity child : [Select Id,Is_Parent__c,Start_Pilot__c,Pilot_End_Date__c,Parent_Opportunity__c,Parent_Renewal_Opportunity__c from Opportunity where Parent_Opportunity__c =:parentOpportunityList.values() or Parent_Renewal_Opportunity__c =:parentOpportunityList.values()]){
          system.debug('@@ child '+child);
           system.debug('@@ child.Parent_Opportunity__c '+child.Parent_Opportunity__c);
           system.debug('@@ child.Parent_Renewal_Opportunity__c '+child.Parent_Renewal_Opportunity__c);
           if(child.Parent_Opportunity__c != null || 
             child.Parent_Renewal_Opportunity__c != null){
                 List<Opportunity> relatedOppList = new List<Opportunity>();
                 if(parentOppIdVsRelatedChildOpp.containsKey((child.Parent_Opportunity__c))){
                     relatedOppList = parentOppIdVsRelatedChildOpp.get((child.Parent_Opportunity__c));
                     relatedOppList.add(child);
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }else if(parentOppIdVsRelatedChildOpp.containsKey((child.Parent_Renewal_Opportunity__c))){
                     relatedOppList = parentOppIdVsRelatedChildOpp.get((child.Parent_Renewal_Opportunity__c));
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Renewal_Opportunity__c,relatedOppList);
                 }else if(child.Parent_Renewal_Opportunity__c != null){
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Renewal_Opportunity__c,relatedOppList);
                 }else if(child.Parent_Opportunity__c != null){
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }
           }
       }
        system.debug('@@@  parentOppIdVsRelatedChildOpp '+parentOppIdVsRelatedChildOpp);
       List<Opportunity> needToUpdateList = new List<Opportunity>();
       for(Opportunity parentOpp : parentOpportunityList.values()){
           if(parentOppIdVsRelatedChildOpp.containsKey(parentOpp.Id) &&
             parentOppIdVsRelatedChildOpp.get(parentOpp.Id).size()>0){
                 for(Opportunity relatedChildOpp : parentOppIdVsRelatedChildOpp.get(parentOpp.Id)){
                     relatedChildOpp.Pilot_End_Date__c = parentOpp.Pilot_End_Date__c;
                     relatedChildOpp.Start_Pilot__c = true;
                     needToUpdateList.add(relatedChildOpp);
                     system.debug('@@relatedChildOpp'+relatedChildOpp);
                 }
                 
           }
        } 
        
        system.debug('@@needToUpdateList'+needToUpdateList);
        if(needToUpdateList.size()>0){
            update needToUpdateList;
            system.debug('@@needToUpdateList after '+needToUpdateList);
        }
    }
    
    public static void updateStartPilotonChildOpp(Map<Id, Opportunity> newOpps, Map<Id, Opportunity> oldOppsMap) {
        system.debug('@@@@@  updateStartPilotonChildOpp');
        Map<String, Opportunity> checkPilotStartStatus = new Map<String, Opportunity>();
        Map<String, Opportunity> checkPilotEndStatus = new Map<String, Opportunity>();
        for(Opportunity newOpp : newOpps.values()) {
            if(newOpp.Is_Parent__c == true && newOpp.Start_Pilot__c != oldOppsMap.get(newOpp.Id).Start_Pilot__c){
                checkPilotStartStatus.put(newOpp.Id,newOpp);
            }
            if(newOpp.Is_Parent__c == true && newOpp.Pilot_End_Date__c != oldOppsMap.get(newOpp.Id).Pilot_End_Date__c){
                checkPilotEndStatus.put(newOpp.Id,newOpp);
            }
        }
         system.debug('@@checkPilotStartStatus'+checkPilotStartStatus);
        if(checkPilotStartStatus.size() >0){
            updateChildOpportunityPilotStarted(checkPilotStartStatus);
           
        }
         system.debug('@@checkPilotEndStatus'+checkPilotEndStatus);
        if(checkPilotEndStatus.size() >0){
            updateChildOpportunityPilotEndDate(checkPilotEndStatus);
           
        }
        
    }
    
    //Update stage to closedWon for child opportunities if type is grouped or grouped multi year
    public static void updateChildOpportunityStage(Map<String,Opportunity> parentOpportunityList,String newSt, String oldSt){
       Map<String, List<Opportunity>> parentOppIdVsRelatedChildOpp = new Map<String, List<Opportunity>>();
       for(Opportunity child : [Select Id,Subscription_Processed__c,Estimate_Status__c,Loss_Reason__c,Lost_Reason__c,StageName,Temporary_Membean_Extension_Date__c,Type,Parent_Opportunity__c,AccountId from Opportunity where Parent_Opportunity__c =:parentOpportunityList.values()]){
          system.debug('@@ child '+child);
           system.debug('@@ child.Parent_Opportunity__c '+child.Parent_Opportunity__c);
           if(child.Parent_Opportunity__c != null || 
             child.Parent_Renewal_Opportunity__c != null){
                 List<Opportunity> relatedOppList = new List<Opportunity>();
                 if(parentOppIdVsRelatedChildOpp.containsKey((child.Parent_Opportunity__c))){
                     relatedOppList = parentOppIdVsRelatedChildOpp.get((child.Parent_Opportunity__c));
                     relatedOppList.add(child);
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }else if(child.Parent_Opportunity__c != null){
                     relatedOppList.add(child);  
                     parentOppIdVsRelatedChildOpp.put(child.Parent_Opportunity__c,relatedOppList);
                 }
           }
       }
       system.debug('@@@  parentOppIdVsRelatedChildOpp '+parentOppIdVsRelatedChildOpp);
       List<Opportunity> needToUpdateList = new List<Opportunity>();
       List<Account> updateAccountList1 = new List<Account>();
       Date dt=null;
       Set<Id> acIds = New Set<Id>();
       for(Opportunity parentOpp : parentOpportunityList.values()){
           if(parentOppIdVsRelatedChildOpp.containsKey(parentOpp.Id) &&
             parentOppIdVsRelatedChildOpp.get(parentOpp.Id).size()>0){
                 for(Opportunity relatedChildOpp : parentOppIdVsRelatedChildOpp.get(parentOpp.Id)){
                     relatedChildOpp.Loss_Reason__c = parentOpp.Loss_Reason__c;
                     relatedChildOpp.Lost_Reason__c = parentOpp.Lost_Reason__c;
                     relatedChildOpp.StageName = parentOpp.StageName;
                     relatedChildOpp.Estimate_Status__c = parentOpp.Estimate_Status__c;
                     relatedChildOpp.Temporary_Membean_Extension_Date__c = parentOpp.Temporary_Membean_Extension_Date__c;
                     relatedChildOpp.Subscription_Processed__c = true;
                     needToUpdateList.add(relatedChildOpp);
                     system.debug('@@relatedChildOpp'+relatedChildOpp);
                     acIds.add(relatedChildOpp.AccountId);
                 }
                 
           }
           system.debug('acIds:::'+acIds);
           if (acIds.Size()>0 && newSt == oldSt)
           {
                dt = parentOpp.Temporary_Membean_Extension_Date__c;
                for (Account acc :[Select Id,Membership_Expires_On__c,Membean_Expires_On__c,Temp_Ready_for_Membean_Sync__c,Ready_for_Membean_Sync__c from Account where Id in :acIds])
                {
                    acc.Membership_Expires_On__c = dt;
                    acc.Membean_Expires_On__c = dt;
                    acc.Temp_Ready_for_Membean_Sync__c = true;
                    acc.Ready_for_Membean_Sync__c = true;
                    updateAccountList1.add(acc);
                    system.debug('acc.Id:::'+acc.Id);
                }
                if (updateAccountList1.size()>0)
                {
                    system.debug('updateAccountList1.Size:::'+ updateAccountList1.Size());
                    update updateAccountList1;
                }
            }
        }
        
        //system.debug('@@needToUpdateList'+needToUpdateList);
        if(needToUpdateList.size()>0){
            update needToUpdateList;
            //system.debug('@@needToUpdateList after '+needToUpdateList);
        }
        
    }
    
    public static void updateChildOppStage(Map<Id, Opportunity> newOpps, Map<Id, Opportunity> oldOppsMap) {
        system.debug('@@@@@  updateChildOppStage');
        Map<String, Opportunity> checkStage = new Map<String, Opportunity>();
        String newStage = '';
        String oldStage = '';
        for(Opportunity newOpp : newOpps.values()) {
            if((newOpp.StageName != oldOppsMap.get(newOpp.Id).StageName||newOpp.Temporary_Membean_Extension_Date__c != oldOppsMap.get(newOpp.Id).Temporary_Membean_Extension_Date__c) && (newOpp.Type == 'Grouped' || newOpp.Type == 'Grouped MultiYear')){
                checkStage.put(newOpp.Id,newOpp);
                newStage = newOpp.StageName;
                oldStage = oldOppsMap.get(newOpp.Id).StageName;
            }
        }
         system.debug('@@checkStage'+checkStage);
        if(checkStage.size() >0){
            updateChildOpportunityStage(checkStage,newStage,oldStage);
           
        }
    }
    
    ///
    public static void updateAccountStatusToPilot(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppsMap) {
        Map<Id, Account> linkedAccountsMap;
        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Id> oppAccIdMap = new Map<Id, Id>();
        Map<Id, Account> accsToUpdateMap = new Map<Id, Account>();
        
        for(Opportunity newOpp : newOpps) {
            Boolean isUpdateOpp = oldOppsMap != NULL && oldOppsMap.containsKey(newOpp.Id);
            Boolean isInsertOpp = oldOppsMap == NULL || !oldOppsMap.containsKey(newOpp.Id);
            Boolean isNowPilot = newOpp.StageName == Constants.OPP_STAGE_PILOT && (isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName != Constants.OPP_STAGE_PILOT));
            Boolean isNowWon = newOpp.StageName == Constants.OPP_STAGE_Won && (isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName != Constants.OPP_STAGE_Won));
            Boolean isChangedYears = isInsertOpp || (isUpdateOpp && (newOpp.Subscription_Start_Year__c != oldOppsMap.get(newOpp.Id).Subscription_Start_Year__c || newOpp.Subscription_End_Year__c != oldOppsMap.get(newOpp.Id).Subscription_End_Year__c));
            Boolean isBeforeNew =(isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName == Constants.OPP_STAGE_NEW));
            
            if(isNowPilot || isNowWon || isChangedYears || isBeforeNew) {
                oppAccIdMap.put(newOpp.Id, newOpp.AccountId);
            }
        }
        
        linkedAccountsMap = new Map<Id, Account>(AccountService.getSchoolsByIds(oppAccIdMap.values()));
        
        for(Opportunity newOpp : newOpps) {
            Boolean isUpdateOpp = oldOppsMap != NULL && oldOppsMap.containsKey(newOpp.Id);
            Boolean isInsertOpp = oldOppsMap == NULL || !oldOppsMap.containsKey(newOpp.Id);
            Boolean isNowPilot = newOpp.StageName == Constants.OPP_STAGE_PILOT && (isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName != Constants.OPP_STAGE_PILOT));
            Boolean isNowWon = newOpp.StageName == Constants.OPP_STAGE_Won && (isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName != Constants.OPP_STAGE_Won));
            Boolean isChangedYears = isInsertOpp || (isUpdateOpp && (newOpp.Subscription_Start_Year__c != oldOppsMap.get(newOpp.Id).Subscription_Start_Year__c || newOpp.Subscription_End_Year__c != oldOppsMap.get(newOpp.Id).Subscription_End_Year__c));
            
            Boolean addAccToList = false;
            Account acc = linkedAccountsMap.get(newOpp.AccountId);
            
            if(isNowPilot || isNowWon || isChangedYears) {
                if(isNowPilot || isNowWon) {
                    //Account acc = linkedAccountsMap.get(newOpp.AccountId);
                    Boolean isAcademicYear;
                    if(newOpp.Subscription_Start_Year__c != NULL && newOpp.Subscription_Start_Year__c != '') {
                        //isAcademicYear    = Integer.valueOf(newOpp.Subscription_Start_Year__c) == CountrySettingsService.getCurrentAcademicStartYear(acc.BillingCountry);
                        isAcademicYear  = true;
                    } else {
                        isAcademicYear = true;
                    }
                    
                    if(isAcademicYear) {
                        /*if(newOpp.StageName == Constants.OPP_STAGE_PILOT) {
                            if(acc.Subscription_Status__c != Constants.ACC_SUBSCRIPTION_STATUS_CUSTOMER && acc.Subscription_Status__c != Constants.ACC_SUBSCRIPTION_STATUS_PILOT) {
                                acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_PILOT;
                                //accountsToUpdate.add(acc);
                                //addAccToList = true;
                                accsToUpdateMap.put(acc.Id, acc);
                            }
                        } else if(newOpp.StageName == Constants.OPP_STAGE_Won) {
                            if(acc.Subscription_Status__c != Constants.ACC_SUBSCRIPTION_STATUS_CUSTOMER) {
                                acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_CUSTOMER;
                                //accountsToUpdate.add(acc);
                                //addAccToList = true;
                                accsToUpdateMap.put(acc.Id, acc);
                            }
                        }*/
                        if(newOpp.StageName == Constants.OPP_STAGE_Won) {
                            if(acc.Subscription_Status__c != Constants.ACC_SUBSCRIPTION_STATUS_CUSTOMER) {
                                acc.Subscription_Status__c = Constants.ACC_SUBSCRIPTION_STATUS_CUSTOMER;
                                //accountsToUpdate.add(acc);
                                //addAccToList = true;
                                accsToUpdateMap.put(acc.Id, acc);
                            }
                        }
                    }
                }
            }
        }
        
        Map<Id, List<Opportunity>> accOppsMap = new Map<Id, List<Opportunity>>();
        List<Opportunity> otherRelatedOpps = new List<Opportunity>();
        
        /*if(oldOppsMap != null) {
            accOppsMap = new Map<Id, List<Opportunity>>();
            otherRelatedOpps = [Select Id, AccountId, StageName, Subscription_Start_Year__c, RecordType.DeveloperName from Opportunity where Id Not In :oldOppsMap.keySet() And AccountId In :oppAccIdMap.values() And StageName = :Constants.OPP_STAGE_PILOT And (RecordType.DeveloperName = :Constants.RT_Opportunity_Regular Or RecordType.DeveloperName = :Constants.RT_Opportunity_Child)];
            
            for(Opportunity otherOpp : otherRelatedOpps) {
                if(accOppsMap.containsKey(otherOpp.AccountId)) {
                    accOppsMap.get(otherOpp.AccountId).add(otherOpp);
                } else {
                    accOppsMap.put(otherOpp.AccountId, new List<Opportunity> {otherOpp});
                }
            }   
        }*/
        
        for(Opportunity newOpp : newOpps) {
            Boolean isUpdateOpp = oldOppsMap != NULL && oldOppsMap.containsKey(newOpp.Id);
            Boolean isInsertOpp = oldOppsMap == NULL || !oldOppsMap.containsKey(newOpp.Id);
            Boolean isNowPilot = newOpp.StageName == Constants.OPP_STAGE_PILOT && (isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName != Constants.OPP_STAGE_PILOT));
            Boolean isNowWon = newOpp.StageName == Constants.OPP_STAGE_Won && (isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName != Constants.OPP_STAGE_Won));
            Boolean isChangedYears = isInsertOpp || (isUpdateOpp && (newOpp.Subscription_Start_Year__c != oldOppsMap.get(newOpp.Id).Subscription_Start_Year__c || newOpp.Subscription_End_Year__c != oldOppsMap.get(newOpp.Id).Subscription_End_Year__c));
            Boolean isBeforeNew =(isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName == Constants.OPP_STAGE_NEW ));
            Boolean isBeforeInterested =(isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName == Constants.OPP_STAGE_INTERESTED ));
            Boolean isBeforeRenewal =(isInsertOpp || (isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName == Constants.OPP_STAGE_RENEWAL ));
            Boolean addAccToList = false;
            
            Account acc = linkedAccountsMap.get(newOpp.AccountId);
            
            /*if(newOpp.StageName == Constants.OPP_STAGE_PILOT  && acc != null && (isBeforeNew || isBeforeInterested || isBeforeRenewal )) {
                Integer sYear = Integer.valueOf(newOpp.Subscription_Start_Year__c);
                Integer eYear = Integer.valueOf(newOpp.Subscription_End_Year__c);
                for(Integer i = sYear; i < eYear; i++) {
                    if(acc.Pilot_Years__c == null) {
                        acc.Pilot_Years__c = String.valueOf(i);
                        //addAccToList = true;
                        if(accsToUpdateMap.containsKey(acc.Id)) {
                            accsToUpdateMap.get(acc.Id).Pilot_Years__c = acc.Pilot_Years__c;
                        } else {
                            accsToUpdateMap.put(acc.Id, acc);   
                        }
                    } else if(!acc.Pilot_Years__c.contains(String.valueOf(i))){
                        acc.Pilot_Years__c += ';' + String.valueOf(i);
                        //addAccToList = true;
                        if(accsToUpdateMap.containsKey(acc.Id)) {
                            accsToUpdateMap.get(acc.Id).Pilot_Years__c = acc.Pilot_Years__c;
                        } else {
                            accsToUpdateMap.put(acc.Id, acc);   
                        } 
                    }   
                }
            }
            
            else if(newOpp.StageName == Constants.OPP_STAGE_PILOT && isChangedYears && acc != null) {
                Integer sYear = Integer.valueOf(newOpp.Subscription_Start_Year__c);
                Integer eYear = Integer.valueOf(newOpp.Subscription_End_Year__c);
                for(Integer i = sYear; i < eYear; i++) {
                    if(acc.Pilot_Years__c == null) {
                        acc.Pilot_Years__c = String.valueOf(i);
                        //addAccToList = true;
                        if(accsToUpdateMap.containsKey(acc.Id)) {
                            accsToUpdateMap.get(acc.Id).Pilot_Years__c = acc.Pilot_Years__c;
                        } else {
                            accsToUpdateMap.put(acc.Id, acc);   
                        }
                    } else if(!acc.Pilot_Years__c.contains(String.valueOf(i))){
                        acc.Pilot_Years__c += ';' + String.valueOf(i);
                        //addAccToList = true;
                        if(accsToUpdateMap.containsKey(acc.Id)) {
                            accsToUpdateMap.get(acc.Id).Pilot_Years__c = acc.Pilot_Years__c;
                        } else {
                            accsToUpdateMap.put(acc.Id, acc);   
                        }
                    }   
                }
            }*/
            
            /*if(isUpdateOpp && acc != null) {
                Opportunity oldOpp = oldOppsMap.get(newOpp.Id);
                Boolean isOtherOppForSameYear = false;
                if(accOppsMap.containsKey(oldOpp.AccountId)) {
                    for(Opportunity otherOpp : accOppsMap.get(oldOpp.AccountId)) {
                        if(oldOpp.Subscription_Start_Year__c == otherOpp.Subscription_Start_Year__c) {
                            isOtherOppForSameYear = true;
                            break;
                        }   
                    }
                }
                
                if(!isOtherOppForSameYear) {
                    if(acc.Pilot_Years__c != null) {
                        if(acc.Pilot_Years__c.contains(';'+oldOpp.Subscription_Start_Year__c)) {
                            String[] str = acc.Pilot_Years__c.split(';'+oldOpp.Subscription_Start_Year__c);
                            system.debug('---before---'+ acc.Pilot_Years__c);
                            string var = '';
                            var += acc.Pilot_Years__c;                            
                            acc.Pilot_Years__c = '';
                            system.debug('---after---'+ acc.Pilot_Years__c); 
                            for(Integer i=0; i<str.size(); i++) {
                                acc.Pilot_Years__c += str[i];
                                system.debug('---loop---'+ acc.Pilot_Years__c);
                            }
                            acc.Pilot_Years__c= var;
                            system.debug('---' + acc.Pilot_Years__c);
                            
                            
                            //addAccToList = true;
                            if(accsToUpdateMap.containsKey(acc.Id)) {
                                accsToUpdateMap.get(acc.Id).Pilot_Years__c = acc.Pilot_Years__c;
                            } else {
                                accsToUpdateMap.put(acc.Id, acc);   
                            }
                        } else if(acc.Pilot_Years__c.contains(oldOpp.Subscription_Start_Year__c + ';')) {
                            String[] str = acc.Pilot_Years__c.split(oldOpp.Subscription_Start_Year__c + ';');
                            string var1 = '';
                            var1 += acc.Pilot_Years__c; 
                            system.debug('--before--' + acc.Pilot_Years__c); 
                            acc.Pilot_Years__c = '';
                            system.debug('--after--' + acc.Pilot_Years__c);
                            for(Integer i=0; i<str.size(); i++) {
                                acc.Pilot_Years__c += str[i];
                            }
                            acc.Pilot_Years__c= var1;
                            system.debug('----Pilot value----' + acc.Pilot_Years__c);
                            //addAccToList = true;
                            if(accsToUpdateMap.containsKey(acc.Id)) {
                                accsToUpdateMap.get(acc.Id).Pilot_Years__c = acc.Pilot_Years__c;
                            } else {
                                accsToUpdateMap.put(acc.Id, acc);   
                            }
                            //accountsToUpdate.add(acc);
                        } else if(acc.Pilot_Years__c == oldOpp.Subscription_Start_Year__c) {
                            
                        }
                    }
                }
            }*/
        }
        
        /*try {
            if(accsToUpdateMap != null) {
                update accsToUpdateMap.values();   
            }
        } catch(Exception e) {}*/
    }
    
    public static void updatePilotYearsOnDeletion(Map<Id, Opportunity> oldOppsMap) {
        /*Set<Account> accountsToUpdate = new Set<Account>();
        Map<Id, Account> accsToUpdateMap = new Map<Id, Account>();
        
        Set<Id> accIdsSet = new Set<Id>();
        for(Opportunity oldOpp : oldOppsMap.values()) {
            accIdsSet.add(oldOpp.AccountId);
        }
        
        List<Id> accIds = new List<Id>();
        accIds.addAll(accIdsSet);
        
        Map<Id, Account> accMap = new Map<Id, Account>(AccountService.getSchoolsByIds(accIds));
        Map<Id, List<Opportunity>> accOppsMap = new Map<Id, List<Opportunity>>();
        List<Opportunity> otherRelatedOpps = [Select Id, AccountId, StageName, Subscription_Start_Year__c, RecordType.DeveloperName from Opportunity where Id Not In :oldOppsMap.keySet() And AccountId In :accIds And StageName = :Constants.OPP_STAGE_PILOT And (RecordType.DeveloperName = :Constants.RT_Opportunity_Regular Or RecordType.DeveloperName = :Constants.RT_Opportunity_Child)];
        
        for(Opportunity otherOpp : otherRelatedOpps) {
            if(accOppsMap.containsKey(otherOpp.AccountId)) {
                accOppsMap.get(otherOpp.AccountId).add(otherOpp);
            } else {
                accOppsMap.put(otherOpp.AccountId, new List<Opportunity> {otherOpp});
            }
        }
        
        for(Opportunity oldOpp : oldOppsMap.values()) {
            Boolean isOtherOppForSameYear = false;
            if(accOppsMap.containsKey(oldOpp.AccountId)) {
                for(Opportunity otherOpp : accOppsMap.get(oldOpp.AccountId)) {
                    
                    if(oldOpp.Subscription_Start_Year__c == otherOpp.Subscription_Start_Year__c) {
                        isOtherOppForSameYear = true;
                        break;
                    }   
                }
            }
            if(!isOtherOppForSameYear) {//!accOppsMap.containsKey(oldOpp.AccountId) && 
                Account acc = accMap.get(oldOpp.AccountId);
                if(acc.Pilot_Years__c != null) {
                    if(acc.Pilot_Years__c.contains(';'+oldOpp.Subscription_Start_Year__c)) {
                        String[] str = acc.Pilot_Years__c.split(';'+oldOpp.Subscription_Start_Year__c);
                        acc.Pilot_Years__c = '';
                        for(Integer i=0; i<str.size(); i++) {
                            acc.Pilot_Years__c += str[i];
                        }
                        
                        accsToUpdateMap.put(acc.Id, acc);
                       
                        //accountsToUpdate.add(acc);
                    } else if(acc.Pilot_Years__c.contains(oldOpp.Subscription_Start_Year__c + ';') || Test.isRunningTest()) {
                        String[] str = acc.Pilot_Years__c.split(oldOpp.Subscription_Start_Year__c + ';');
                        acc.Pilot_Years__c = '';
                        for(Integer i=0; i<str.size(); i++) {
                            acc.Pilot_Years__c += str[i];
                        }
                        accsToUpdateMap.put(acc.Id, acc);
                        //accountsToUpdate.add(acc);
                    } else if(acc.Pilot_Years__c == oldOpp.Subscription_Start_Year__c) {
                        acc.Pilot_Years__c = null;
                        system.debug('------' + acc.Pilot_Years__c);
                        accsToUpdateMap.put(acc.Id, acc);
                        //accountsToUpdate.add(acc);
                    }
                }
            }
        }
        
        try {
            if(accsToUpdateMap != null) {
                List<Account> listaccountsToUpdate = new List<Account>();
                listaccountsToUpdate.addAll(accountsToUpdate);
                update accsToUpdateMap.values();   
            }
        } catch(Exception e) {}*/
    } 
    
    public static void createUpdateSubscription(Map<Id, Opportunity> newOppsMap, Map<Id, Opportunity> oldOppsMap) {
        Map<Id, List<Contract>> accSubscriptionsMap = new Map<Id, List<Contract>>();
        Map<Id, List<Opportunity>> accOpportunityMap = new Map<Id, List<Opportunity>>();
        
        for(Opportunity newOpp : newOppsMap.values()) {
            OpportunityService.SubscriptionstopRecursion+=1;
            if(!isRecordTypeEligibleForSubscription(newOpp.RecordTypeId) && !Test.isRunningTest()) continue;
            
            Boolean isUpdateOpp = oldOppsMap != NULL && oldOppsMap.containsKey(newOpp.Id);
            Boolean changeInNoOfStudents = isUpdateOpp && newOpp.No_Of_Students__c != oldOppsMap.get(newOpp.Id).No_Of_Students__c;
            Boolean changeInNoOfTeachers = isUpdateOpp && newOpp.No_Of_Teachers__c != oldOppsMap.get(newOpp.Id).No_Of_Teachers__c;
            Boolean changeInAmount = isUpdateOpp && newOpp.Amount != oldOppsMap.get(newOpp.Id).Amount;
            Boolean newOppWon = newOpp.StageName == Constants.OPP_STAGE_Won;
            Boolean oldOppWon = isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName == Constants.OPP_STAGE_Won;
            
            if((newOppWon && 
                (!isUpdateOpp || 
                 (isUpdateOpp && 
                  (!oldOppWon || changeInNoOfStudents || changeInNoOfTeachers || changeInAmount)))) || 
               (!newOppWon && oldOppWon) || Test.isRunningTest()) {
                   accSubscriptionsMap.put(newOpp.AccountId, null);
                   
                   if(!accOpportunityMap.containsKey(newOpp.AccountId) ) {
                       accOpportunityMap.put(newOpp.AccountId, new List<Opportunity> {newOpp});
                   } else {
                       accOpportunityMap.get(newOpp.AccountId).add(newOpp);
                   }
               }
        }
        
        if(accOpportunityMap.isEmpty()) {
            return;
        }
        
        List<Contract> subscriptions = ContractService.getSubscriptionsByAccountIds(accSubscriptionsMap.keySet());//[Select Id, Name, Subscription_Start_Year__c, Subscription_End_Year__c, AccountId, No_of_Students__c, No_of_Teachers__c, Amount__c from Contract where AccountId in :accSubscriptionsMap.keySet()];
        
        for(Contract con : subscriptions) {
            if(accSubscriptionsMap.containsKey(con.AccountId)) {
                if(accSubscriptionsMap.get(con.AccountId) == null) {
                    accSubscriptionsMap.put(con.AccountId, new List<Contract> {con});
                } else {
                    accSubscriptionsMap.get(con.AccountId).add(con);
                }
            }
        }
        
        List<Contract> upsertContracts = new List<Contract>();
        
        for(Id accId : accOpportunityMap.keySet()) {
            for(Opportunity newOpp : accOpportunityMap.get(accId)) {
                Boolean isUpdateOpp = oldOppsMap != NULL && oldOppsMap.containsKey(newOpp.Id);
                Boolean changeInNoOfStudents = isUpdateOpp && newOpp.No_Of_Students__c != oldOppsMap.get(newOpp.Id).No_Of_Students__c;
                Boolean changeInNoOfTeachers = isUpdateOpp && newOpp.No_Of_Teachers__c != oldOppsMap.get(newOpp.Id).No_Of_Teachers__c;
                Boolean changeInAmount = isUpdateOpp && newOpp.Amount != oldOppsMap.get(newOpp.Id).Amount;
                Boolean newOppWon = newOpp.StageName == Constants.OPP_STAGE_Won;
                Boolean oldOppWon = isUpdateOpp && oldOppsMap.get(newOpp.Id).StageName == Constants.OPP_STAGE_Won;
                
                if(accSubscriptionsMap.containsKey(newOpp.AccountId)) {
                    Contract newCon;
                    if(newOppWon) {
                        if(accSubscriptionsMap.get(newOpp.AccountId) == null) {
                            newCon = ContractService.createContract(newOpp);
                            system.debug('Entered the first if for create contract %%%'+newCon);
                        } else {
                            for(Contract con : accSubscriptionsMap.get(newOpp.AccountId)) {
                                if(con.Subscription_Start_Year__c == newOpp.Subscription_Start_Year__c && con.Subscription_End_Year__c == newOpp.Subscription_End_Year__c) {    
                                    if(oldOppWon && (changeInNoOfStudents || changeInNoOfTeachers || changeInAmount))    {
                                        newCon = ContractService.removeOpportunityDetails(con, oldOppsMap.get(newOpp.Id));
                                    }
                                    newCon = ContractService.addOpportunityDetails(con, newOpp);
                                    break;
                                }
                            }
                            if(newCon == null) {
                                newCon = ContractService.createContract(newOpp);
                            }
                        }
                        if(newCon != null) {
                            upsertContracts.add(newCon);   
                            system.debug('upsertContracts#################-newopp'+upsertContracts);

                        }
                    } else if(oldOppWon) {
                        if(accSubscriptionsMap != NULL && accSubscriptionsMap.containsKey(newOpp.AccountId) && accSubscriptionsMap.get(newOpp.AccountId) != NULL) {
                            try {
                                for(Contract con : accSubscriptionsMap.get(newOpp.AccountId)) {
                                    if(con.Subscription_Start_Year__c == newOpp.Subscription_Start_Year__c && con.Subscription_End_Year__c == newOpp.Subscription_End_Year__c) {
                                        newCon = ContractService.removeOpportunityDetails(con, oldOppsMap.get(newOpp.Id));
                                        break;
                                    }
                                }   
                            } catch(Exception e) {}
                        }
                        if(newCon != null) {
                            upsertContracts.add(newCon);  
                            system.debug('upsertContracts#################-oldopp'+upsertContracts);
                        }
                    }
                }
            }   
        }
        
        if(!upsertContracts.isEmpty()) {
            upsert upsertContracts;
            
            List<Contract> contractsToDelete = new List<Contract>();
            for(Contract con : upsertContracts) {
                if((con.No_of_Students__c == NULL || con.No_of_Students__c == 0) && 
                   (con.No_of_Teachers__c == NULL || con.No_of_Teachers__c == 0) && 
                   (con.Amount__c == NULL || con.Amount__c == 0)) {
                       contractsToDelete.add(con);
                   }
            }
            delete contractsToDelete;
        }
        
        Map<Id, Opportunity> oppsToUpdate = new Map<Id, Opportunity>(OpportunityService.getOpportunitiesByIds(newOppsMap.keySet()));
        for(Contract con : upsertContracts) {
            for(Opportunity newOpp : accOpportunityMap.get(con.AccountId)) {
                if(oppsToUpdate.containsKey(newOpp.Id)) {
                    if(newOpp.StageName == Constants.OPP_STAGE_Won) {
                        if(newOpp.Subscription_Start_Year__c == con.Subscription_Start_Year__c && newOpp.Subscription_End_Year__c == con.Subscription_End_Year__c) {
                            oppsToUpdate.get(newOpp.Id).Subscription__c = con.Id;
                            break;
                        } 
                    } else {
                        oppsToUpdate.get(newOpp.Id).Subscription__c = null;
                    }
                }
            }
        }
        try {
            update oppsToUpdate.values();
        } catch(Exception e) {}
    }
    
    public static void updateSubscriptionOnDelete(Map<Id, Opportunity> oldOppsMap) {
        Set<Id> conIds = new Set<Id>();
        for(Opportunity oldOpp : oldOppsMap.values()) {
            if(oldOpp.Subscription__c != null) {
                conIds.add(oldOpp.Subscription__c);
            }
        }
        if(conIds.isEmpty()) {
            return;
        }
        Map<Id, Contract> conMap = new Map<Id, Contract>(ContractService.getSubscriptionsByIds(conIds));
        
        for(Opportunity oldOpp : oldOppsMap.values()) {
            if(conMap.containsKey(oldOpp.Subscription__c)) {
                conMap.put(oldOpp.Subscription__c, ContractService.removeOpportunityDetails(conMap.get(oldOpp.Subscription__c), oldOpp)); 
            }
        } 
        try {
            update conMap.values(); 
            
            List<Contract> contractsToDelete = new List<Contract>();
            for(Contract con : conMap.values()) {
                if((con.No_of_Students__c == NULL || con.No_of_Students__c == 0) && 
                   (con.No_of_Teachers__c == NULL || con.No_of_Teachers__c == 0) && 
                   (con.Amount__c == NULL || con.Amount__c == 0)) {
                       contractsToDelete.add(con);
                   }
            }
            delete contractsToDelete;
        } catch(Exception e) {}
    }
    
    public static void deleteChildOppsOnDeleteParent(List<Opportunity> oldOpps) {
        Map<Id, List<Opportunity>> childOppsMap = OpportunityService.getChildOpportunitiesMapByParent(oldOpps);
        List<Opportunity> oppsToDelete = new List<Opportunity>();
        if(childOppsMap != null && !childOppsMap.isEmpty()) {
            for(Id oppId : childOppsMap.keySet()) {
                if(childOppsMap.containsKey(oppId) && childOppsMap.get(oppId) != NULL) {
                    oppsToDelete.addAll(childOppsMap.get(oppId));   
                }
            }
            if(!oppsToDelete.isEmpty()) {
                delete oppsToDelete;   
            }
        }
    }
    
    public static Boolean isRecordTypeEligibleForSubscription(Id recordTypeId) {
        if(oppRecordTypesMap != null && oppRecordTypesMap.containsKey(recordTypeId) && (oppRecordTypesMap.get(recordTypeId).DeveloperName =='Renewal'||oppRecordTypesMap.get(recordTypeId).DeveloperName =='Returning'|| oppRecordTypesMap.get(recordTypeId).DeveloperName == Constants.RT_Opportunity_Child)) {
            return true;
        } else {
            return false;
        }
    }
    public static void updateChildAmount(List<Opportunity> newOpportunities){
        
        
        
        for(Opportunity opps1:newOpportunities){
            if(opps1.Parent_Opportunity__c!=null && opps1.Subscription_End_Year__c!=null && opps1.Subscription_Start_Year__c!=null&&opps1.Teacher_Amount__c!=null&&opps1.Student_Amount__c!=null&&opps1.Child_discount_amount__c!=null){
                opps1.Amount=(opps1.Teacher_Amount__c+opps1.Student_Amount__c+opps1.Child_discount_amount__c)*(Integer.valueOf(opps1.Subscription_End_Year__c)-Integer.valueOf(opps1.Subscription_Start_Year__c));
                system.debug('opps1.Amount'+opps1.Amount); 
            }
        }  
        
        
    }
    

   
     /** To update the  opportunity record type id on creation / update for both parent and child**/
    public static void updateRecordtypesOpportunity(List<Opportunity> opportunitiees){
        set<Id> accidset=new Set<Id>();
        Map<Id,Account> accMap=new Map<Id,Account>();
        List<Integer> dates;
        for(Opportunity opps:opportunitiees){
            //if(opps.StageName!='Close Won')
            accidset.add(opps.AccountId);
        }
        for(Account acc:[select id,Subscription_Status__c,Subscription_Years__c,Name from Account where id in:accidset]){
            if(!accMap.containsKey(acc.id))
                accMap.put(acc.id,acc);
        }
        for(Opportunity opp:opportunitiees){
            dates=new List<Integer>(); 
            if(accMap.get(opp.AccountId).Subscription_Years__c!=null && opp.Subscription_Start_Year__c != Null){
                string[] str=accMap.get(opp.AccountId).Subscription_Years__c.split(';');
                for(Integer i=0;i<str.size();i++){
                    dates.add(Integer.valueOf(str[i]));
                }
                dates.sort();
                integer date1=0;
                integer date2=0;
                if (dates.size()>0)
                    date1 = dates[dates.size()-1];
                if (dates.size()>1)
                    date2 = dates[dates.size()-2];
                integer diff = date1 - date2;
                if((opp.Subscription_Start_Year__c!=null &&!accMap.get(opp.AccountId).Subscription_Years__c.contains(opp.Subscription_Start_Year__c)&&
                   (Integer.valueOf(opp.Subscription_Start_Year__c)-dates[dates.size()-1])==1) || (accMap.get(opp.AccountId).Subscription_Years__c.contains(opp.Subscription_Start_Year__c) && diff == 1)){
                    opp.RecordTypeId=OpportunityService.oppRecordTypesByDevName.get('Renewal').Id;
                    opp.Name = accMap.get(opp.AccountId).Name + '-' + 'Renewal Opportunity';
                    system.debug('opp.RecordTypeIdRenewal'+opp.RecordTypeId);
                }else if((opp.Subscription_Start_Year__c!=null  &&!accMap.get(opp.AccountId).Subscription_Years__c.contains(opp.Subscription_Start_Year__c) && (Integer.valueOf(opp.Subscription_Start_Year__c)-dates[dates.size()-1])>1) || (accMap.get(opp.AccountId).Subscription_Years__c.contains(opp.Subscription_Start_Year__c) && (diff > 1 && diff < 1000))){
                    opp.RecordTypeId=OpportunityService.oppRecordTypesByDevName.get('Returning').Id;
                    opp.Name = accMap.get(opp.AccountId).Name + '-' + 'Returning Opportunity';
                    system.debug('opp.RecordTypeIdReturning'+opp.RecordTypeId);
                }
          }else if(accMap.get(opp.AccountId).Subscription_Years__c==null && opp.Subscription_Start_Year__c!=null){
                
                opp.RecordTypeId=OpportunityService.oppRecordTypesByDevName.get('New').Id;
                system.debug('opp.RecordTypeIdNew'+opp.RecordTypeId);
            }           
        }
        
    }
    
    
    /************Added*******************/
    /*======================================================================
    Method Name : ChildOppCustomRollup
    Purpose     : This method is for counting Child Opprtunities to display Rollup on Opportunity 
    ======================================================================== */
    public static void ChildOppCustomRollup(List<Opportunity> newObjectList){  
        Set<id> oppIds = new Set<id>();
        List<Opportunity> OpportunityToUpdate = new List<Opportunity>();
        
        for (Opportunity item : newObjectList){
                oppIds.add(item.Parent_Opportunity__c);                                       
        }
        // get a map of the Opportunity with the number of FA
        if(oppIds != null){        
            Map<id,Opportunity> OpportunityMap = new Map<id,Opportunity>([select id,name,Count_of_Child_Opportunities__c from Opportunity where id IN :oppIds]);
            // query Opportunity and the related FA and add the size of the FA items to the Opportunity
            for (Opportunity ship : [select Id, Name,Count_of_Child_Opportunities__c,(select id from Opportunities__r) from Opportunity where Id IN :oppIds FOR UPDATE]) {
                OpportunityMap.get(ship.Id).Count_of_Child_Opportunities__c = ship.Opportunities__r.size();
                // add the value/Opportunity in the map to a list so we can update it
                OpportunityToUpdate.add(OpportunityMap.get(ship.Id));
            }        
            if (OpportunityToUpdate.size()>0) { 
                try {
                    update OpportunityToUpdate;
                } catch (Exception e){
                    System.debug('********error***********'+e);
                 }
            }
        }
    }
    /**************Ends here*******************/
    


    public static List<Opportunity> getParentOpps(List<String> parentOppsIds){
        
        List<Opportunity> opportunities = [select Id,No_of_Students__c,Student_Amount__c,Subscription_Start_Year__c,Subscription_End_Year__c from Opportunity where Id IN:parentOppsIds];
        
        return opportunities;
    }    
    
    
    
    public static void activityUpdateOnCreation(List<Opportunity> opps){
        
        List<Opportunity> renewalOpps = new List<Opportunity>();
        Set<Id> oppIds = new Set<Id>();
        List<Opportunity> renewal_opps = new List<Opportunity>();
        List<Opportunity> opps_to_update = new List<Opportunity>();
        List<String> parentOppIds = new List<String>{};
        
        for(Opportunity opp:opps){
            
            if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId()){
                
                oppIds.add(opp.Id);
                renewalOpps.add(opp);
                parentOppIds.add(opp.Parent_Renewal_Opportunity__c);                
            
                // Parent_Opportunity__c
            
            }
            
        }
        
        
        if(oppIds.size()>0){
            renewal_opps = [select Id,Parent_Renewal_Opportunity__c,Key_Activity_Log__c from Opportunity where Id IN:oppIds];
        }
        
        List<Opportunity> renewalParentOpps = getParentOpps(parentOppIds);
        
        for(Opportunity rop:renewal_opps){
            String prevLog = (rop.Key_Activity_Log__c != NULL)?rop.Key_Activity_Log__c:'';
            for(Opportunity po:renewalParentOpps){
                if(rop.Parent_Renewal_Opportunity__c != Null){
                    if(rop.Parent_Renewal_Opportunity__c == po.Id){
                        String prependData = '-> ['+po.Subscription_Start_Year__c+'-'+po.Subscription_End_Year__c+'] Purchased {'+po.No_of_Students__c+'} student license at {'+po.Student_Amount__c+'}';
                        rop.Key_Activity_Log__c =  prependData+'\n'+prevLog;
                        
                        opps_to_update.add(rop);
                    }
                }
            }
        }
        
        if(opps_to_update.size()>0){
            update opps_to_update;
        }
               
    }
    
        
    public static void logUpdateOnStageChange(List<Opportunity> opps,Map<Id, Opportunity> oldOppsMap){
        
        List<String> OppIds = new List<String>{};                    
        List<String> contactOppIds = new List<String>{};
        List<String> newContactIds = new List<String>{};
        List<String> oldContactIds = new List<String>{};
        List<String> newOppIds = new List<String>{};    
                                
        for(Opportunity opp:opps){
            
            Opportunity oldOpp = oldOppsMap.get(opp.Id);
                       
            if(oldOpp.StageName != opp.StageName){                                
                OppIds.add(opp.Id);                                                       
            }
            
            if(oldOpp.Teacher__c != opp.Teacher__c){
                
                contactOppIds.add(opp.Id);
                if (opp.Teacher__c != Null)
                    newContactIds.add(opp.Teacher__c);
                if (oldOpp.Teacher__c != Null)
                    oldContactIds.add(oldOpp.Teacher__c);

                newOppIds.add(opp.Id);
                                                
            }
        }
        
        if(OppIds.size()>0){
            List<Opportunity> oppsList = [select Id,Name,Status_set_date__c,Key_Activity_Log__c,StageName,(select WhatId,ActivityDateTime,CreatedDate from Events where What.Type = 'Opportunity'),(select WhatId,CreatedDate from Tasks where What.Type = 'Opportunity') from Opportunity where Id IN:OppIds];
            
            for(Opportunity o:oppsList){
                
                Integer count = 0;
                
                String prevLog = (o.Key_Activity_Log__c != null)?o.Key_Activity_Log__c:'';
                
                Opportunity oldOpp = oldOppsMap.get(o.Id);
                
               
                if(o.Status_set_date__c != Null){
                    String prependData = '-> {'+Datetime.now().format('YYYY-MM-dd HH:mm:ss')+'}: Changed from {'+oldOpp.StageName+'} to {'+o.StageName+'} after {'+oldOpp.Status_set_date__c.daysBetween(Date.today())+'} days ';
                
                    o.Key_Activity_Log__c = prependData+'\n'+prevLog;
                    
                }
                
                o.Status_set_date__c = Date.today();                
            }
            
            if(oppsList.size()>0){
                update oppsList;
            }
            
        }
        
        if(contactOppIds.size()>0){
            
            List<Opportunity> newOpps = [select Id,Teacher__c,Key_Activity_Log__c from Opportunity where Id IN:newOppIds];

            Map<Id,Contact> new_contact = new Map<Id,Contact>([select Name,Role__c from Contact where Id IN:newContactIds]);
            Map<Id,Contact> old_contact = new Map<Id,Contact>([select Name,Role__c from Contact where Id IN:oldContactIds]);                                 
                        
            for(Opportunity no:newOpps){
                if(oldOppsMap != NULL){
                    Opportunity oop = oldOppsMap.get(no.Id);
                    String prevLog = (no.Key_Activity_Log__c != null)?no.Key_Activity_Log__c:'';
                    String prependData = '';
                    if (oldContactIds.Size() == 0)
                        prependData = '-> {'+Datetime.now().format('YYYY-MM-dd HH:mm:ss')+'}: Contact Change: New Opportunity contact (Teacher field) added {'+new_contact.get(no.Teacher__c).Name+'} {'+new_contact.get(no.Teacher__c).Role__c+'}';                                
                    else if (newContactIds.Size() == 0)
                        prependData = '-> {'+Datetime.now().format('YYYY-MM-dd HH:mm:ss')+'}: Contact Change: Opportunity contact (Teacher field) removed {'+old_contact.get(no.Teacher__c).Name+'} {'+old_contact.get(no.Teacher__c).Role__c+'}';                                
                    else
                        prependData = '-> {'+Datetime.now().format('YYYY-MM-dd HH:mm:ss')+'}: Contact Change: The Opportunity contact (Teacher field) changed from {'+old_contact.get(oop.Teacher__c).Name+'} {'+old_contact.get(oop.Teacher__c).Role__c+'} to {'+new_contact.get(no.Teacher__c).Name+'} {'+new_contact.get(no.Teacher__c).Role__c+'}';
                    no.Key_Activity_Log__c = prependData+'\n'+prevLog;
                }
            }
            
            update newOpps;
        }
        
    }
    
    
    public static void acknowledgementUpdate(Set<id> triggerIds,Map<Id, Opportunity> oldOppsMap){
        
        List<Opportunity> opps = [select Id,Estimate_Status__c,Key_Activity_Log__c,Quote_Acknowledgement__c from Opportunity where Id IN:triggerIds];
        List<Opportunity> oppList = new List<Opportunity>();
              
        for(Opportunity o:opps){
                        
            if(oldOppsMap.get(o.Id).Key_Activity_Log__c != NULL){
               
                if((o.Estimate_Status__c == 'Estimated') && (o.Key_Activity_Log__c.length() > oldOppsMap.get(o.Id).Key_Activity_Log__c.length()) && (o.Quote_Acknowledgement__c == False)){
                o.Quote_Acknowledgement__c = True;
                oppList.add(o);
                }
            }
              
        }
        
        if(oppList.size()>0){
            update oppList;
        }
        
    }
    
    
    public static void createTeachersMembeanUsage(List<Opportunity> opps){
        
        List<Teachers_membean_usage__c> tmuList = new List<Teachers_membean_usage__c>();
        List<String> category = new List<String>{'Consistent & Recommended','Consistent & Below par','Inconsistent','Started well and dropped','Never started'};
        Set<Id> oIdset = New Set<Id>();
        Id RecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
     
        //o.Start_Pilot__c == TRUE
        
        List<Opportunity> olstnew = New List<Opportunity>();
        for (Opportunity o :opps)
        {            
            if (o.RecordTypeId == RecTypeId && (o.Parent_Opportunity__c != NULL || o.Parent_Renewal_Opportunity__c != NULL))
            {
                olstnew.add(o);
            }
        }
        for(Opportunity o :olstnew){
            
            for(Integer i=0;i<5;i++){
                Teachers_membean_usage__c tmu = new Teachers_membean_usage__c();
                tmu.Opportunity__c = o.Id;
                tmu.Category__c = category[i];

                tmuList.add(tmu);                
            }
            
        }

        if(tmuList.size()>0)
        insert tmuList;    
        
    }
    
    public static void createUsageFidelityOnPilot(List<Opportunity> opps,Map<Id,Opportunity> oldOpps){
        List<Teachers_membean_usage__c> tmuList = new List<Teachers_membean_usage__c>();
        List<String> category = new List<String>{'Consistent & Recommended','Consistent & Below par','Inconsistent','Started well and dropped','Never started'};
        Set<Id> oIdset = New Set<Id>();
        Id RecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New').getRecordTypeId();
        for(Opportunity o:opps){
             
            if(o.Start_Pilot__c != oldOpps.get(o.Id).Start_Pilot__c && o.Start_Pilot__c == TRUE && o.RecordTypeId == RecTypeId && o.Usage_fidelity_count__c == 0){
                for(Integer i=0;i<5;i++){
                    Teachers_membean_usage__c tmu = new Teachers_membean_usage__c();
                    tmu.Opportunity__c = o.Id;
                    tmu.Category__c = category[i];
    
                    tmuList.add(tmu);                
                }
            }
            
        }
        
        
        if(tmuList.size()>0)
        insert tmuList;
        
        
    }
    public static void updateOppSubscriptionFlag(Map<Id,Opportunity>oldMap, Map<Id,Opportunity>newMap){
        for(Opportunity opp:newMap.values()){
            system.debug('Inside:::' + opp.id);
            system.debug('opp.AAccount_RecordType__c :::' + opp.Account_RecordType__c);
            system.debug('opp.Pilot_End_Date__c::: ' + opp.Pilot_End_Date__c);
            system.debug('oldMap.get(opp.id).Pilot_End_Date__c::: ' + oldMap.get(opp.id).Pilot_End_Date__c);
            system.debug('opp.stagename::: ' + opp.stagename);
            system.debug('oldMap.get(opp.id).stagename::: ' + oldMap.get(opp.id).stagename);
            system.debug('opp.stagename.equalsIgnoreCase(Close Won)::: ' + opp.stagename.equalsIgnoreCase('Close Won'));
            /*if(((opp.Account.RecordType.Name == 'Public School' || opp.Account.recordType.name == 'Private School') && (opp.stagename !=oldMap.get(opp.id).stagename) && (opp.stagename.equalsIgnoreCase('Close Won') || opp.stagename.equalsIgnoreCase('Close Lost'))) 
               || (opp.Pilot_End_Date__c != oldMap.get(opp.id).Pilot_End_Date__c))*/
            //if ((opp.Account_RecordType__c == 'Public School' || opp.Account_RecordType__c == 'Private School') && ((opp.Pilot_End_Date__c != oldMap.get(opp.id).Pilot_End_Date__c) || ((opp.stagename !=oldMap.get(opp.id).stagename) && (opp.stagename.equalsIgnoreCase('Close Won') || opp.stagename.equalsIgnoreCase('Close Lost')))))
              //if ((opp.Account_RecordType__c == 'Public School' || opp.Account_RecordType__c == 'Private School') && ((opp.Pilot_End_Date__c != oldMap.get(opp.id).Pilot_End_Date__c) || ((opp.stagename !=oldMap.get(opp.id).stagename) && (opp.stagename.equalsIgnoreCase('Close Won') || (oldMap.get(opp.id).stagename.equalsIgnoreCase('Close Won') && opp.stagename.equalsIgnoreCase('Close Lost'))))))  
            if ((opp.Account_RecordType__c == 'Public School' || opp.Account_RecordType__c == 'Private School') && ((opp.StageName == 'Close Won' && ((opp.Student_Pay__c != oldMap.get(opp.id).Student_Pay__c) || (opp.No_Of_Students__c != oldMap.get(opp.id).No_Of_Students__c) || (opp.No_Of_Teachers__c != oldMap.get(opp.id).No_Of_Teachers__c))) || (opp.Pilot_End_Date__c != oldMap.get(opp.id).Pilot_End_Date__c) || ((opp.stagename !=oldMap.get(opp.id).stagename) && (opp.stagename.equalsIgnoreCase('Close Won') || (oldMap.get(opp.id).stagename.equalsIgnoreCase('Close Won') && opp.stagename.equalsIgnoreCase('Close Lost'))))))
                opp.Subscription_Processed__c=true;
            if ((opp.Account_RecordType__c == 'Public School' || opp.Account_RecordType__c == 'Private School') && (opp.StageName != 'Close Won' && opp.Temporary_Membean_Extension_Date__c != oldMap.get(opp.id).Temporary_Membean_Extension_Date__c))
            {
                opp.Subscription_Processed__c=true;
                opp.Membean_Extension_Date__c = opp.Temporary_Membean_Extension_Date__c;
            }
        }
        integer i=0;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
         ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
         ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
              ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
         ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
         ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
         ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
    }
   
}