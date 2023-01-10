global class ProcessOpptyFutureActivityBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessOpptyFutureActivityBatch  pofab = new ProcessOpptyFutureActivityBatch();
        ID idBatch = Database.executeBatch(pofab,1);
    }
}