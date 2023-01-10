/*
* @Purpose : Controller for Registration VF Page 
  @Author  : Amritesh
  @CreatedDate: 11/09/2016
*/
public class Registration_Clr {
    
    Public String stateList         {get; set;}
    Public String roleList          {get; set;}
    Public String conferenceList    {get; set;}
    public string stateDefault    {get; set;}
    Public String nextstep       {get; set;}
    public Registration_Clr(){
        stateList       = '';
        roleList        = '';
        conferenceList  = '';
        stateDefault  = '';
        nextstep	=	'';
        stateList       = JSON.serialize(Utility.getStateList());
        roleList        = JSON.serialize(Utility.getPicklistValues(Utility.LEAD_OBJ, Utility.ROLE_FIELD));
        nextstep		= JSON.serialize(Utility.getPicklistValues(Utility.LEAD_OBJ, Utility.NEXTSTEP_FIELD));
        //conferenceList    = JSON.serialize(getConferenceList());
         try{
            stateDefault  = Teacher_Registration_Settings__c.getInstance().State_Default_Value__c;
        }catch(Exception e){}
    }
    
    @RemoteAction
    Public static String getCities(string state){
        return JSON.serialize(Utility.getStateCityList(state));
    }
    
    @RemoteAction
    Public static String getSchools(string state, String city){
        if(state != null && city != null){
          return JSON.serialize(Utility.getSchoolList(state, city));  
        }else{
            return null;
        }
        
    }
    
    @RemoteAction 
    Public static boolean createLead(Lead leadRecord){
        try{
            List<String> confList = getConferenceList();
            if(confList.size() > 0){
                leadRecord.Hear_About_Us__c = confList[0];
            }
            List<Lead> existingLead = new List<Lead>();
            if(leadRecord.Email != null){
               existingLead = Utility.checkExistingLead(leadRecord.Email); 
                if(existingLead.size() > 0){
                    leadRecord.id               =   existingLead[0].id;
                    if(existingLead[0].Hear_About_Us__c != null && leadRecord.Hear_About_Us__c != null){
                        leadRecord.Hear_About_Us__c = existingLead[0].Hear_About_Us__c+','+leadRecord.Hear_About_Us__c;   
                    }else if(existingLead[0].Hear_About_Us__c != null && leadRecord.Hear_About_Us__c == null){
                        leadRecord.Hear_About_Us__c = existingLead[0].Hear_About_Us__c;   
                    }
                    
                }
            }
            

            
            leadRecord.isSiteLead__c=true;  
            system.debug('this is the lead record'+leadRecord);
            upsert leadRecord;
                        
            // Call Lead Assignment method
            Utility.runLeadAssignmentRule(new List<Lead>{leadRecord});
            //send Email Notification
            List<EmailTemplate> mailTemplate    = Utility.getEmailTemplateName(Utility.TEACHER_REG_TEMPLATE_NAME);
            if(mailTemplate.size() > 0){
               Utility.SendEmailNotification(leadRecord.id, mailTemplate[0].id); 
            }
            
            return true;
        }catch(Exception e){
            return false;
        }
    }
    
    /* @Purpose: Get Conference List from Conference_Name_for_Teacher_Registration__c
     *           Custom settings
     * @returnType:List<String>
     */
    @TestVisible
    private static List<String> getConferenceList(){
        List<String> confList = new List<String>();
        List<Conference_Name_for_Teacher_Registration__c> confs = Conference_Name_for_Teacher_Registration__c.getall().values();
        for(Conference_Name_for_Teacher_Registration__c c : confs){
            confList.add(c.Name);
        }
        return confList;
    }
    
   
}