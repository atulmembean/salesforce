global class updatePaypalInvoiceInvocable{
    @InvocableMethod (label='Update Paypa Invoice' description='Update Paypal Invoice')
    webservice static void updatepaypalinv(List<Id> invId)
    {
        for (String inv :invId)
        {
            system.debug('inv::: ' + inv);
            updatePaypalInvoice.updatePaypalInv(inv);
        }
    }
}