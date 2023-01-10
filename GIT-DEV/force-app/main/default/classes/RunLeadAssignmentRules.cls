public class RunLeadAssignmentRules {

    @InvocableMethod
    public static void assignLeads(List<Id> leadIds){
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = TRUE;
        List<Lead> toAssign = [SELECT Id FROM Lead WHERE Id = :leadIds];
        Lead l = [Select Id, Owner.Name,State from Lead where Id = :toAssign[0].Id];
        system.debug('Old Owner ::: ' + l.Owner.Name);
        system.debug('Old State ::: ' + l.State);
        system.debug('Leadtoassign::' +toAssign);
        Database.update(toAssign,dmo);
        system.debug('Lead Assigned:::');
        l = [Select Id, Owner.Name,State from Lead where Id = :toAssign[0].Id];
        system.debug('New Owner ::: ' + l.Owner.Name);
        system.debug('New State ::: ' + l.State);
    }
}