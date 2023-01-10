global class ProcessDistrictOpptyChildCountScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProcessDistrictOpptyChildCount batch = new ProcessDistrictOpptyChildCount();
        ID idBatch = Database.executeBatch(batch,1);
    }
}