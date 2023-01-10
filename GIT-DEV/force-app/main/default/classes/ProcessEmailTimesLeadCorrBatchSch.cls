global class ProcessEmailTimesLeadCorrBatchSch implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessEmailTimesLeadCorrBatch batch = new ProcessEmailTimesLeadCorrBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}