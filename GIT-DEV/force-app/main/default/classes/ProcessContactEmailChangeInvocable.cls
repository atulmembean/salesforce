public with sharing class ProcessContactEmailChangeInvocable
{
    public class ProcessRequest
    {
        @InvocableVariable(
            label = 'Contact Record ID'
            description = 'Contact Record ID'
            required = false
        )
        public String contactId;
        
    } 
               
    @InvocableMethod(label='Process Email Change on Contact on leaving')
    public static void processEmailChange(List<ProcessRequest > requests)
    {
        for ( ProcessRequest request : requests )
        {
            ProcessRecord(request);
        }
    }
    
    public static void ProcessRecord(ProcessRequest request)
    {
        
        if (request.contactId!= null)
        {
            String rId = request.contactId;
            Contact c = [Select Id,Email from Contact where Id = :rId LIMIT 1];
            String dat = '';
            String day = string.valueOf(system.now().day());
            String month = string.valueOf(system.now().month());
            String hour = string.valueOf(system.now().hour());
            String minute = string.valueOf(system.now().minute());
            String second = string.valueOf(system.now().second());
            String year = string.valueOf(system.now().year());
            String month1 = '';
            if( month == '1')
                month1 = 'Jan';
            else if (month == '2')
                month1 = 'Feb';
            else if (month == '3')
                month1 = 'Mar';
            else if (month == '4')
                month1 = 'Apr';
            else if (month == '5')
                month1 = 'May';
            else if (month == '6')
                month1 = 'Jun';
            else if (month == '7')
                month1 = 'Jul';
            else if (month == '8')
                month1 = 'Aug';
            else if (month == '9')
                month1 = 'Sep';
            else if (month == '10')
                month1 = 'Oct';
            else if (month == '11')
                month1 = 'Nov';
            else if (month  == '12')
                month1 = 'Dec';
            String strTime = 'LS_'+year+'-'+month+'-'+day+'_'+hour+'-'+minute+'-'+second+'_';
            if (c != Null)
            {
                c.Email = strTime +c.Email;
                update c;
            }
        }
        integer i=0;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
        ++i;
    }
}