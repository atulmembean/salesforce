global class ProcessDailyEmailTimesBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessDailyEmailTimesBatch batch = new ProcessDailyEmailTimesBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}