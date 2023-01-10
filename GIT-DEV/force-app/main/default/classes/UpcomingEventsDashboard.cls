public class UpcomingEventsDashboard {
    public List<Event> upcomingevents {get;set;}
         
   //Display all events  based on Activity Dashboard
    Public  UpcomingEventsDashboard(){
        upcomingevents=[SELECT Id,Owner.Name,Account.Name,Who.Name,Subject,Type,ActivityDate,StartDateTime,What.Name,LeadAccountName__c,who.type,SchoolAccountName__c,SchoolAccountName__r.Company FROM Event Where ActivityDate >:system.Date.today().addDays(-1) Order by StartDateTime];
    } 
}