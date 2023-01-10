global class ProcessLeadStatusUpdDailyBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessLeadStatusUpdDailyBatch batch = new ProcessLeadStatusUpdDailyBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}