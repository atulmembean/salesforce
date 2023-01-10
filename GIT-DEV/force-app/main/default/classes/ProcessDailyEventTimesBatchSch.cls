global class ProcessDailyEventTimesBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessDailyEventTimesBatch batch = new ProcessDailyEventTimesBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}