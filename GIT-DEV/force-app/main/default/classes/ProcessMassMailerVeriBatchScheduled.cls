global class ProcessMassMailerVeriBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessMassMailerVerificationBatch batch = new ProcessMassMailerVerificationBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}