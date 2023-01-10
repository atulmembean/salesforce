public class InvoiceService {
	
    public static Integer runBeforeTriggerCount = 1;
    public static boolean runBeforeTrigger = true;
   
    public static boolean runBeforeOnce() {
        if(runBeforeTrigger) {
            if(runBeforeTriggerCount > 1)
                runBeforeTrigger = false;
            runBeforeTriggerCount++;
            return true;
        } else {
            return runBeforeTrigger;
        }
    }
    
    /*public static Integer runAfterTriggerCount = 1;
    public static boolean runAfterTrigger = true;
    public static boolean runAfterOnce() {
        if(runAfterTrigger) {
            if(runAfterTriggerCount > 2)
                runAfterTrigger = false;
            runAfterTriggerCount++;
            return true;
        } else {
            return runAfterTrigger;
        }
    }*/
}