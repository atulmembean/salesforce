global class ProcessDailyListEmailTimesBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessDailyListEmailTimesBatch batch = new ProcessDailyListEmailTimesBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}