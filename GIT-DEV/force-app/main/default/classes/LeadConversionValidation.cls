public class LeadConversionValidation
{
    public id leadobjid {get; set;}
    public String error {get; set;}
    public Boolean sterr {get; set;}
    public LeadConversionValidation(ApexPages.StandardController controller)
    {
      sterr = false;
      error = 'Please fill out following fields before conversion:<br />';
      leadobjid = ((Lead) controller.getRecord()).id;
      Lead leadobj = [select Lead_Type__c, Opportunity_type__c from Lead where id =: leadobjid ];
      if(leadobj.Lead_Type__c  == null ||
        leadobj.Opportunity_type__c == null )

        { 

          if(leadobj.Lead_Type__c  == null){error = error + '- Lead Type<br />';}
          if(leadobj.Opportunity_type__c  == null){error = error + '- Opportunity Type<br />';}
                  }
    
        
    }
}