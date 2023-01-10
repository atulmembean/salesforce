/**
* Class Type        : Constants Container
* Created by        : Swayam Arora
* Version           : 1.0
* Description       : To define all the Constants to be used by other Classes.
**/
public class Constants {
    //Account RecordTypes Developer Names
    public static final String RT_Account_District = 'District';
    public static final String RT_Account_Agency = 'Agency';
    public static final String RT_Account_PublicSchool = 'Public_School';
    public static final String RT_Account_PrivateSchool = 'Private_School';
    
    //Opportunity RecordTypes Developer Names
    public static final String RT_Opportunity_Regular = 'Regular';
    public static final String RT_Opportunity_Grouped = 'Grouped';
    public static final String RT_Opportunity_Multiyear = 'Multiyear';
    public static final String RT_Opportunity_GroupedMultiyear = 'Grouped_Multiyear';
    public static final String RT_Opportunity_Child = 'New';
    
    //Opportunity RecordTypes Labels
    public static final String RT_Label_Opportunity_Regular = 'Regular';
    public static final String RT_Label_Opportunity_Grouped = 'Grouped';
    public static final String RT_Label_Opportunity_Multiyear = 'Multiyear';
    public static final String RT_Label_Opportunity_GroupedMultiyear = 'Grouped Multiyear';
    public static final String RT_Label_Opportunity_Child = 'Child';
    
    //Profiles
    public static final String Profile_SalesHead = 'Sales Head';
    public static final String Profile_SalesManager = 'Sales Manager';
    public static final String Profile_SalesExecutive = 'Sales Executive';
    
    //Quote RecordTypes
    public static final String QUOTE_RECORDTYPE_NAME_REJECTED = 'Rejected';
    public static final String QUOTE_RECORDTYPE_NAME_ACTIVE = 'Active';
    
    //Quote Status Values
    public static final String QUOTE_STATUS_ACCEPTED = 'Accepted';
    public static final String QUOTE_STATUS_PRESENTED = 'Presented';
    public static final String QUOTE_STATUS_DRAFT = 'Draft';
    public static final String QUOTE_STATUS_REJECTED = 'Rejected';
    
    //Opportunity Stage Values
    public static final String OPP_STAGE_PILOT = 'Pilot';
    //public static final String OPP_STAGE_WON = 'Won';
    public static final String OPP_STAGE_WON = 'Close Won';
    public static final String OPP_STAGE_NEW = 'New';
    public static final String OPP_STAGE_INTERESTED = 'Interested';
    public static final String OPP_STAGE_RENEWAL = 'Renewal';
    
    //Opportunity Estimate Status Values
    public static final String OPP_ESTIMATE_STATUS_NOT_INVOICED = 'Not Invoiced';
    
    //Product Familiy Values
    public static final String PRODUCT_FAMILY_STUDENT = 'Student Subscriptions';
    public static final String PRODUCT_FAMILY_TEACHER = 'Teacher Subscriptions';
    public static final String PRODUCT_FAMILY_DISCOUNT = 'Discounts';
    
    //Account Subscription Status Values
    public static final String ACC_SUBSCRIPTION_STATUS_PILOT = 'Pilot';
    public static final String ACC_SUBSCRIPTION_STATUS_CUSTOMER = 'Customer';
    public static final String ACC_SUBSCRIPTION_STATUS_EXPIRED = 'Expired';
    public static final String ACC_SUBSCRIPTION_STATUS_DISCONTINUED = 'Discontinued';
    public static final String ACC_SUBSCRIPTION_STATUS_PILOT_EXPIRED = 'Pilot Expired';
    public static final String ACC_SUBSCRIPTION_STATUS_PILOT_DISCONTINUED = 'Pilot Discontinued';
    
    //Account Low and High Grades Default
    public static final Integer ACC_LOWGRADE = 5;
    public static final Integer ACC_HIGHGRADE = 12;
    
    //Account - Type of School Picklist Values
    public static final String ACC_SCHOOL_TYPE_ELEMENTARY = 'Elementary';
    public static final String ACC_SCHOOL_TYPE_MIDDLE = 'Middle School';
    public static final String ACC_SCHOOL_TYPE_HIGH = 'High School';
    public static final String ACC_SCHOOL_TYPE_OTHERS = 'Others';
    
    //Lead ID Initials
    public static final String LEAD_ID_INITIALS_3_LETTERS = '00Q';
    
    //Task Status
    public static final String TASK_STATUS_COMPLETED = 'Completed';
    
    //Lead Status
    public static final String LEAD_STATUS_NEW = 'New';
    public static final String LEAD_STATUS_CONTACTED = 'Contacted';
    
    //Task subtype
    public static final String TASK_SUBTYPE_CALL = 'Call';
    public static final String TASK_SUBTYPE_EMAIL = 'Email';
    
}