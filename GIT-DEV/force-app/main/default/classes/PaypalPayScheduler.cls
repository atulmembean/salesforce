global class PaypalPayScheduler implements Schedulable{
	global void execute(SchedulableContext ctx)
    {
        PaypalPayStatusBatch batch = new PaypalPayStatusBatch();
        Database.executeBatch(batch, 1);   
    }
}