global class DailyLeadFutureEventReSetBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        DailyLeadFutureEventReSetBatch batch = new DailyLeadFutureEventReSetBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}