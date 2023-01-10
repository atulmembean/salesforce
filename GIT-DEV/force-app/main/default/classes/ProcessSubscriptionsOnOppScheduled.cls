global class ProcessSubscriptionsOnOppScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessSubscriptionsOnOpportunity batch = new ProcessSubscriptionsOnOpportunity();
        ID idBatch = Database.executeBatch(batch,1);
    }
}