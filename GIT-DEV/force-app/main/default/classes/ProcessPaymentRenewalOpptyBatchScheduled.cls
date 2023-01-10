global class ProcessPaymentRenewalOpptyBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessPaymentRenewalOpptyBatch batch = new ProcessPaymentRenewalOpptyBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}