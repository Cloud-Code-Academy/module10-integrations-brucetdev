public with sharing class contactTriggerHandler {
  
 public static void setDummyJSONId(List<Contact> newContacts) {
    List<Contact> contactsForUpdate = new List<Contact>();
    for (Contact con : newContacts){
        System.debug('you are in the for loop of the setDummyJSONId function');
        //if statement to check each contact in newContacts to see if the DummyJSON_Id__c field is empty
        if(con.DummyJSON_Id__c == ''  || con.DummyJSON_Id__c == null) {
            //get a random number between 0 and 100
            //cast the result to an integer and assign it to the DummyJSON_Id__c field
            con.DummyJSON_Id__c = String.valueOf((Math.random()*100).intValue());
            //System.debug('the random number is: ' + con.DummyJSON_Id__c);
            //add the con tact to the contactsForUpdate list
            contactsForUpdate.add(con);
            //System.debug('the contact id is: ' + con.Id);
            //System.debug('the contact DummyJSON_Id__c is:
    }
    //System.debug('the contacts for update list is: ' + contactsForUpdate);
    
}

 }
}
    
    