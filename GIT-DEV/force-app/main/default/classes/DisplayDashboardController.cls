/**
* Class Name        : DisplayDashboardController
* Created by        : Pooja K (13-08-2018)
* Modified Date		: 16-08-2018
* Version           : 43.0 
* Description       : This is a controller for fething the dashboard data and passing this value to the vf page
*                   : This vf page is used in the Lightning Component using a iframe and then put in an Lightning app.
*Test Class			: DisplayDashboardControllerTest
**/
public class DisplayDashboardController {
    
    //Get the dashboard content by passing the Id of Dashboard stored in a Custom label. Create a blob data and pass to Vf Page.
    public string getdashboardBlob() 
    {
        PageReference dbPage = new PageReference('/'+Label.MembeanDashboard1);
        Blob pageBlob;
        if(Test.isRunningTest()){
            pageBlob =blob.valueOf('Unit.Test');
        }else{
            pageBlob = dbPage.getContent();
        }
        return pageBlob.toString(); 
    } 

}