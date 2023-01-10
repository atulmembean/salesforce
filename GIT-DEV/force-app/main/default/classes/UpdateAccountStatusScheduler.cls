global class UpdateAccountStatusScheduler implements Schedulable{
  global void execute(SchedulableContext ctx)
    {
        UpdateAccountStatus batch = new UpdateAccountStatus();
        Database.executeBatch(batch, 1);   
    }
}