global class ProcessMassMailerLeadUpdateBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessMassMailerLeadUpdateBatch batch = new ProcessMassMailerLeadUpdateBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}