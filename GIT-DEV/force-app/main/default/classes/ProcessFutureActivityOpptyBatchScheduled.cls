global class ProcessFutureActivityOpptyBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessFutureActivityOpptyBatch batch = new ProcessFutureActivityOpptyBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}