global class RemoveDuplicateContactRoleBatchScheduled implements Schedulable {
    global void execute(SchedulableContext SC) {
        RemoveDuplicateContactRoleBatch b = new RemoveDuplicateContactRoleBatch();
        ID idBatch = Database.executeBatch(b,1);
    }
}