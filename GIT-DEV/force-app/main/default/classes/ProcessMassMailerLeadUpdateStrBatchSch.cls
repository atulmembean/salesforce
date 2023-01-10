global class ProcessMassMailerLeadUpdateStrBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessMassMailerLeadUpdateStrBatch batch = new ProcessMassMailerLeadUpdateStrBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}