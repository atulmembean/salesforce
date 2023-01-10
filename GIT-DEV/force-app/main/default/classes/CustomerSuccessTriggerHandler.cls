public class CustomerSuccessTriggerHandler {
	 //Auto naming name
    public static void updateCustomerSuccessName(List<Customer_Success__C> newCustomerSuccess){
        for(Customer_Success__C cust:newCustomerSuccess){
            cust.Name=cust.Merge_Customer_Success_Name__c;
        }
    }
}