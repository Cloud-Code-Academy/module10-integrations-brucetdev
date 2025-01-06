/**
 * ContactTrigger Trigger Description:
 * 
 * The ContactTrigger is designed to handle various logic upon the insertion and update of Contact records in Salesforce. 
 * 
 * Key Behaviors:
 * 1. When a new Contact is inserted and doesn't have a value for the DummyJSON_Id__c field, the trigger generates a random number between 0 and 100 for it. // added to handler class
 * 2. Upon insertion, if the generated or provided DummyJSON_Id__c value is less than or equal to 100, the trigger initiates the getDummyJSONUserFromId API call. // in progress
 * 3. If a Contact record is updated and the DummyJSON_Id__c value is greater than 100, the trigger initiates the postCreateDummyJSONUser API call.
 * 
 * Best Practices for Callouts in Triggers:
 * 
 * 1. Avoid Direct Callouts: Triggers do not support direct HTTP callouts. Instead, use asynchronous methods like @future or Queueable to make the callout.
 * 2. Bulkify Logic: Ensure that the trigger logic is bulkified so that it can handle multiple records efficiently without hitting governor limits.
 * 3. Avoid Recursive Triggers: Ensure that the callout logic doesn't result in changes that re-invoke the same trigger, causing a recursive loop.
 * 
 * Optional Challenge: Use a trigger handler class to implement the trigger logic.
 */
trigger ContactTrigger on Contact(before insert) {
	// When a contact is inserted
	// If the contact does not have a value for the DummyJSON_Id__c field, set the value of the field to a random number between 0 and 100 // added to handler class
	if(Trigger.isBefore && Trigger.isInsert ){
		for (Contact contact : Trigger.new) {
			if (contact.DummyJSON_Id__c == '' || contact.DummyJSON_Id__c == null) {
			contactTriggerHandler.setDummyJSONId(Trigger.new);
			}
		}
		
	}
	
	// //When a contact is inserted and DummyJSON_Id__c value is less than or equal to 100
	// if(Trigger.isAfter && Trigger.isInsert){
	// 	Integer DummyJSONInteger = integer.valueof(Contact.DummyJSON_Id__c);
	// // if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
	// 	if(DummyJSONInteger <= 100){
	// 		System.debug('DummyJSON_Id__c is less than or equal to 100');
	// 		// for(Contact contact : Trigger.new){
	// 		// 	CalloutClass.getDummyJSONUserFromId(contact.DummyJSON_Id__c);
	// 		// }
	// //		CalloutClass.getDummyJSONUserFromId(contact.DummyJSON_Id__c); // RESUME HERE - look into the call out class next
	// 	}
	// }

// 	//When a contact is updated
	// if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
	if(Trigger.isBefore && Trigger.isUpdate){
		Integer DummyJSONInteger = integer.valueof(Contact.DummyJSON_Id__c);
		if(DummyJSONInteger > 100){
			//CalloutClass.postCreateDummyJSONUser(contact);
			//DummyJSONCallout.postCreateDummyJSONUser();
		}
	//update the DummyJSON Last Updated field with the current date and time
	String DummyJsonLastUpdatedString = Datetime.now().format('yyyy-MM-dd');
		Contact.DummyJSON_Last_Updated__c = DummyJsonLastUpdatedString;
	}
}
