global class ProcessMMLeadLastContactTimeBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessMMLeadLastContactTimeBatch batch = new ProcessMMLeadLastContactTimeBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}