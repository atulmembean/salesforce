global class UpdatePilotStatusBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        UpdatePilotStatusBatch batch = new UpdatePilotStatusBatch();
        ID idBatch = Database.executeBatch(batch,1);
    }
}