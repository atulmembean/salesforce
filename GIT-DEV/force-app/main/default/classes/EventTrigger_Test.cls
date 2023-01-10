@isTest(SeeAllData=TRUE)
public class EventTrigger_Test {
    static testMethod void testmesthodupdate(){
        Date dt = System.Today();
        Date dt1 = dt.addDays(10);
        Test.StartTest();
        Event e = [Select Id,ActivityDate,WhoId from Event where EndDate > :dt AND Cancelled__c = FALSE AND WhoId != Null LIMIT 1];
        if (e != Null)
        {
            if (e.whoId.getSObjectType().getDescribe().getName()=='Lead')
            {
                Lead l = [Select Id,Total_Events_COnducted__c from LEad where Id = :e.WhoId];
                l.Total_Events_COnducted__c = 2;
                update l;
            }
            else if (e.whoId.getSObjectType().getDescribe().getName()=='Contact')
            {
                Contact c = [Select Id,Total_Events_Conducted__c from Contact where Id = :e.WhoId];
                c.Total_Events_Conducted__c = 2;
                update c;
            }
            e.ActivityDate = dt1;
            update e;   
        }
        delete e;
        Test.StopTest();
    }
    static testMethod void testmesthodcancelupdate(){
        Date dt = System.Today();
        Date dt1 = dt.addDays(10);
        Test.StartTest();
        Event e = [Select Id,ActivityDate,Cancelled__c,WhoId from Event where EndDate > :dt AND Cancelled__c = FALSE AND WhoId != Null LIMIT 1];
        if (e != Null)
        {
            if (e.whoId.getSObjectType().getDescribe().getName()=='Lead')
            {
                Lead l = [Select Id,Total_Events_Conducted__c from LEad where Id = :e.WhoId];
                l.Total_Events_COnducted__c = 2;
                update l;
            }
            else if (e.whoId.getSObjectType().getDescribe().getName()=='Contact')
            {
                Contact c = [Select Id,Total_Events_Conducted__c from Contact where Id = :e.WhoId];
                c.Total_Events_Conducted__c = 2;
                update c;
            }
            e.ActivityDate = dt1;
            update e;
            e.Cancelled__c = TRUE;
            update e;   
        }
        Test.StopTest();
    }
    static testMethod void testmesthoddeletepast(){
        Date dt = System.Today();
        Date dt1 = dt.addDays(10);
        Date dt2 = dt.addDays(-1);
        Test.StartTest();
        Event e = [Select Id,ActivityDate,Cancelled__c,WhoId from Event where EndDate < :dt2 AND Cancelled__c = FALSE AND WhoId != Null LIMIT 1];
        if (e != Null)
        {
            if (e.whoId.getSObjectType().getDescribe().getName()=='Lead')
            {
                Lead l = [Select Id,Total_Events_COnducted__c from LEad where Id = :e.WhoId];
                l.Total_Events_COnducted__c = 2;
                update l;
            }
            else if (e.whoId.getSObjectType().getDescribe().getName()=='Contact')
            {
                Contact c = [Select Id,Total_Events_COnducted__c from Contact where Id = :e.WhoId];
                c.Total_Events_COnducted__c = 2;
                update c;
            }
            e.Cancelled__c = TRUE;
            update e;   
        }
        Test.StopTest();
    }
    static testMethod void testmesthodcontactupdate(){
        Date dt = System.Today();
        Date dt1 = dt.addDays(10);
        Date dt2 = dt.addDays(-1);
        Date dt3 = dt.addDays(-100);
        Test.StartTest();
        List<Contact> conlst = [select Id, Name from Contact where ID IN (SELECT RelationId from EventRelation where Relation.Type='Contact' AND createdDate > :dt3) LIMIT 1];
        conlst[0].Total_Events_COnducted__c = 2;
        update conlst[0];
        Event e = [Select Id,Cancelled__c,ActivityDate from Event where whoId = :conlst[0].Id LIMIT 1];
        if (e != Null)
        {
            e.Subject = 'Test';
            e.ActivityDate = dt2;
            e.Cancelled__c = FALSE;
            update e;
            e.Cancelled__c = TRUE;
            update e;
            e.ActivityDate = dt2;
            update e;
            e.Cancelled__c = FALSE;
            update e;
            delete e;   
        }
        Test.StopTest();
    }
    static testMethod void testmesthodcontactinsertupdate(){
        Contact c = [Select Id,Total_Events_COnducted__c from Contact order by CreatedDate DESC LIMIT 1];
        c.Total_Events_COnducted__c = 2;
        update c;
        List<Event> newEvents = New List<Event>();
        Event Event1= new Event(Subject='Testing 1',WhoId=c.id,StartDateTime=System.today()-2,
                          EndDateTime=System.today()-1);
        newEvents.add(Event1);
        insert newEvents;
        Event e = [Select Id,Cancelled__c from Event where whoId = :c.Id order by CreatedDate DESC LIMIT 1];
        e.Cancelled__c = TRUE;
        update e;
        e.Cancelled__c = FALSE;
        update e;
        c.Total_Events_COnducted__c = 0;
        update c;
        e.Cancelled__c = TRUE;
        update e;
        e.StartDateTime=System.today()+1;
        e.EndDateTime=System.today()+2;
        update e;
        e.Cancelled__c = FALSE;
        update e;
        delete e;
    }
    static testMethod void testmesthodleadinsertupdate(){
        Lead c = [Select Id,Total_Events_COnducted__c from Lead order by CreatedDate DESC LIMIT 1];
        c.Total_Events_COnducted__c = 2;
        update c;
        List<Event> newEvents = New List<Event>();
        Event Event1= new Event(Subject='Testing 1',WhoId=c.id,StartDateTime=System.today()-2,
                          EndDateTime=System.today()-1);
        newEvents.add(Event1);
        insert newEvents;
        Event e = [Select Id,Cancelled__c from Event where whoId = :c.Id order by CreatedDate DESC LIMIT 1];
        e.Cancelled__c = TRUE;
        update e;
        e.Cancelled__c = FALSE;
        update e;
        c.Total_Events_COnducted__c = 0;
        update c;
        e.Cancelled__c = TRUE;
        update e;
        e.StartDateTime=System.today()+1;
        e.EndDateTime=System.today()+2;
        e.Cancelled__c = FALSE;
        update e;
        delete e;
    }
}