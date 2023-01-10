trigger EventType on Event (before insert, before update) {

     for(Event tsk:trigger.new){
         if(tsk.Subject.containsIgnoreCase('Calendly')){
              if(tsk.Subject.containsIgnoreCase('Demo')){
                  tsk.Type='Demo';
                  
              }else if(tsk.Subject.containsIgnoreCase('Data Review')){
                  tsk.Type='Data Review';
              }else if(tsk.Subject.containsIgnoreCase('Call')){
                          tsk.Type='Meeting';
              }
         }
         if(tsk.Subject.containsIgnoreCase('Email')){
              tsk.Type='Email';
         }
      }
   

}