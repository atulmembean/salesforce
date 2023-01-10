@isTest(SeeAllData =  TRUE)
public class UpdatePilotStatusBatch_Test {
    static testMethod void testmethod1(){
        Date todayDate = System.Today();
        Opportunity o = [Select Id from Opportunity where Pilot_End_Date__c >= :todayDate LIMIT 1];
        if (o != Null)
        {
            o.Pilot_End_Date__c = System.Today();
            update o;
        }
        Test.startTest();
        UpdatePilotStatusBatch u = New UpdatePilotStatusBatch();
        database.executebatch(u);
        Test.stopTest();
}
}