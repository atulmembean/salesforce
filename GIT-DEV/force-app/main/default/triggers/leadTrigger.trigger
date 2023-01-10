trigger leadTrigger on Lead (before update, after insert) {
    List<String> nameGroup = New List<String>();
    String new_name = '';
    Set<Id> lId = New Set<Id>();
    List<String> emaillst = New List<String>();
    List<Contact> conlst = New List<Contact>();
    List<Contact> conlstupd = New List<Contact>();
    List<Lead> leadlstupd = New List<Lead>();
    if (trigger.isInsert)
    {
         for (Lead ld : Trigger.new)
         {
             if (ld.Bulk_Import__c == FALSE && ld.Email != Null)
             {
                 lId.add(ld.Id);
                 emaillst.add(ld.Email);
             }
         }
         if (emaillst.Size()>0)
         {
             conlst = [Select Id,Merged_Lead__c,Email,Attention_Required__c,Additional_Sales_Inquiries__c,AccountId from Contact where Email in :emaillst];
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
             String strTime = 'CM_'+year+'-'+month+'-'+day+'_'+hour+'-'+minute+'-'+second+'_';
             List<Lead> lleadlst = [Select Id,Status,Invalid_Lead__c,FirstName,LastName,Email,Company,Phone,City,State,Country,Role__c,Hear_About_Us__c,Additional_Comments__c,School_Description__c,Highest_Grade__c,Lowest_Grade__c from Lead where Id in :lId];
          
             for (Lead ld1 :lleadlst)
             {
                 for (contact c :conlst)
                 {
                     if (c.Email == ld1.Email)
                     {
                         c.Attention_Required__c = TRUE;
                         c.Additional_Sales_Inquiries__c = 'A duplicate sales inquiry was received on ' + month1+ ' ' + day + ', ' + year + ':' + '\r\n';
                         if (ld1.FirstName != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'First Name: ' + ld1.FirstName + '\r\n';
                         if (ld1.LastName != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Last Name: ' + ld1.LastName+ '\r\n';
                         if (ld1.Email != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Email: ' + ld1.Email + '\r\n';
                         c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Company: ' + ld1.Company+ '\r\n';
                         if (ld1.Phone != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Phone: ' + ld1.Phone+ '\r\n';
                         if (ld1.City != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'City: ' + ld1.City+ '\r\n';
                         if (ld1.State != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'State: ' + ld1.State+ '\r\n';
                         if (ld1.Country!= Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Country: ' + ld1.Country+ '\r\n';
                         if (ld1.Role__c != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Role: ' + ld1.Role__c+ '\r\n';
                         if (ld1.Hear_About_Us__c != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Hear About Us: ' + ld1.Hear_About_Us__c+ '\r\n';
                         if (ld1.Additional_Comments__c != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Additional Comments: ' + ld1.Additional_Comments__c + '\r\n';
                         if (ld1.School_Description__c!= Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'School Description: ' + ld1.School_Description__c+ '\r\n';
                         if (ld1.Highest_Grade__c != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Highest Grade: ' + ld1.Highest_Grade__c+ '\r\n';
                         if (ld1.Lowest_Grade__c != Null)
                             c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Lowest Grade: ' + ld1.Lowest_Grade__c+ '\r\n';
                         c.Additional_Sales_Inquiries__c = c.Additional_Sales_Inquiries__c + 'Lead Id: ' + ld1.Id;
                         c.Merged_Lead__c = ld1.Id;
                         conlstupd.add(c);
                         ld1.Merged_Contact__c = c.Id;
                         ld1.Email = strTime+ld1.Email;
                         ld1.School_Account__c = c.AccountId;
                         ld1.Status = 'Nurturing';
                         ld1.Invalid_Lead__c = TRUE;
                         leadlstupd.add(ld1);
                         break;
                     }    
                 }
            } 
            if (conlstupd.size()>0)
             update conlstupd;
            if (leadlstupd.size()>0)
             update leadlstupd;
        } 
    }
    if (trigger.isUpdate)
    {
        for (Lead l :trigger.New)
        {
            new_name = '';
            if (l.FirstName != Null)
            {
                nameGroup = l.FirstName.split(' ');
                for (String part : nameGroup)
                {
                    if(part.length() == 1 ){
                        part = part.toUpperCase()+ ' ';
                        new_name += part;
                    }
                    else if (part.length() >= 2){
                        System.debug(part);
                        new_name += part.subString(0,1).toUpperCase()+part.subString(1,part.length())+ ' ';
                    }
                }
                l.FirstName = new_name;
            }
            if (l.LastName != Null)
            {
                new_name = '';
                nameGroup = l.LastName.split(' ');
                for (String part : nameGroup){
                    if(part.length() == 1 ){
                        part = part.toUpperCase()+ ' ';
                        new_name += part;
                    }
                    else if (part.length() >= 2){
                        System.debug(part);
                        new_name += part.subString(0,1).toUpperCase()+part.subString(1,part.length())+ ' ';
                    }
                }
                l.LastName = new_name;
            }
        }
    }
}