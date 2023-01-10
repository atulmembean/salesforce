/**
* Schedular Class   : ScheduleBatchUpdateOpportuntiy
* Created by        : Nirosha (04-10-2016)
* Version           : 1.0
* Description       : schedular class will be used schedule batch class 'BatchUpdateOpportunity'
*                   : Inline comments are added to get specific details.
**/

global class ScheduleBatchUpdateOpportuntiy implements Schedulable {
    global void execute(SchedulableContext ctx) {
      
      //Create obj of batch class
      BatchUpdateOpportunity batchStageUpdate =  new BatchUpdateOpportunity();
      // Execute bacth class for 200 records
      ID batchprocessid = Database.executeBatch(batchStageUpdate,200);
      
    } 
}