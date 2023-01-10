/**
* Schedular Class   : ScheduleBatchJobs
* Created by        : ETMarlabs (24-08-2016)
* Version           : 1.0
* Description       : schedular class will be used schedule batch class 'UpdateAccountAtEndOfAcedemicYear'
*                   : Inline comments are added to get specific details.
**/

global class ScheduleBatchJobs implements Schedulable {
    global void execute(SchedulableContext ctx) {
    	
    	//Create obj of batch class
    	UpdateAccountAtEndOfAcedemicYear updateAccountAtEndOfAcedemicYearObj =  new UpdateAccountAtEndOfAcedemicYear();
    	// Execute bacth class for 200 records
    	ID batchprocessid = Database.executeBatch(updateAccountAtEndOfAcedemicYearObj,200);
    	
    	/* Below line will be used to schedule batch job on 31st July - Schedule it using apex execute.
    	system.schedule('Scheduled batch job for updating expired Account', '0 0 0 31 7 ? 2016-2022', new ScheduleBatchJobs());
    	*/
    }
}