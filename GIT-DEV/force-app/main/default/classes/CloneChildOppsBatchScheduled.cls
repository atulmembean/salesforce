global class CloneChildOppsBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        CloneChildOppsBatch batch = new CloneChildOppsBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}