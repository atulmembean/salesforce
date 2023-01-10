global class ProcessSubStatusOnAccountScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessSubscriptionStatusOnAccount batch = new ProcessSubscriptionStatusOnAccount();
        ID idBatch = Database.executeBatch(batch,1);
    }
}