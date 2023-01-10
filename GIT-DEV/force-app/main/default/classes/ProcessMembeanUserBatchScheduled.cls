global class ProcessMembeanUserBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessMembeanUserBatch batch = new ProcessMembeanUserBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}