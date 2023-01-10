/**
* Schedular Class   : ScheduleBatchLeadInlinePageDetails
* Created by        : ETMarlabs (28-12-2017)
* Version           : 41.0
* Description       : schedular class will be used schedule batch class 'BatchLeadInlinePageDetails'
*                   : Inline comments are added to get specific details.
**/

global class ScheduleBatchLeadInlinePageDetails implements Schedulable {
    global void execute(SchedulableContext ctx) {
      
      //Create obj of batch class
      BatchLeadInlinePageDetails BatchLeadInlinePageDetailsObj =  new BatchLeadInlinePageDetails();
      // Execute bacth class for 200 records
      ID batchid = Database.executeBatch(BatchLeadInlinePageDetailsObj,8);
      
      /* Below line will be used to schedule batch job on 31st July - Schedule it using apex execute.
			System.schedule('ScheduledJob update LeadInlinePage values on fields',0 0 8 * * ? *, new ScheduleBatchLeadInlinePageDetails());
      */
    }
}