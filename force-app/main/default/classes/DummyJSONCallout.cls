/*
 * DummyJSONCallout Class Description:
 * 
 * This class, DummyJSONCallout, facilitates HTTP callouts to an external system (presumably 'DummyJsonUser' in this context) 
 * to either fetch or send user information based on a given identifier. The class supports both GET (to fetch data) 
 * and POST (to send data) operations.
 * 
 * Overview of HTTP Callouts:
 * 
 * HTTP callouts are a way for Salesforce to communicate with external systems using HTTP protocols. Through HTTP callouts, 
 * you can invoke external web services, collect data from them, or send data for further processing. Apex provides 
 * classes that enable you to both send and receive HTTP data. The primary classes for this are `HttpRequest`, which 
 * represents the request you're sending, and `HttpResponse`, which represents the response you receive.
 * 
 * Best Practices:
 * 1. Handle Exceptions: Always handle exceptions that might be thrown, to ensure your code doesn't break unexpectedly.
 * 2. Named Credentials: Use Named Credentials to store endpoint URLs and authentication details securely.
 * 3. Test Callouts: Use mock classes and interfaces to test HTTP callouts without making actual callouts.
 * 
 * For more detailed information on HTTP callouts in Apex, refer to the official Salesforce documentation: 
 * https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_classes_restful_http_httprequest.htm
 */

public with sharing class DummyJSONCallout {

	/* 
	 * Question 1 - test passed
     * Fetches user information from an external system https://dummyjson.com/user/{id} ('DummyJsonUser') based on the provided dummy user ID. 
     * If the callout is successful and returns an HTTP status of 200, the method will update a contact based on the DummyJSON_Id__c with the data returned from the external system.
	 * Use the createContactFromJson method to parse the JSON response and create a Salesforce Contact object.
     * Documentation: https://dummyjson.com/docs/users
	 * This callout method should work in triggers
	 * 
     * @param dummyUserId The ID of the user in the external system to fetch data for.
     */

	public static void getDummyJSONUserFromId(String dummyUserId) {
	 
		// Create HTTP request to send.
		HttpRequest req = new HttpRequest();

		// Set the endpoint URL. Use direct URL or for best practices use Named Credential.
		req.setEndpoint('callout:https://dummyjson.com/users' + dummyUserId);
		// Set the HTTP method to GET.
		req.setMethod('GET');
		// Send the HTTP request and get the response.
		Http http = new Http();
		HttpResponse response = http.send(req);
		// If the HTTP response code is successful, parse the JSON response and update the contact.
		// Add if statement to check if HTTP response code is 200
		if(response.getStatusCode() == 200) {
			String responseBody = response.getBody();
			// Deserialize the JSON string into a Map of String and Object
			Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
			System.debug('The parsed response is: ' + parsedResponse);
			System.debug('The parsed response for birthdate is: ' + parsedResponse.get('birthDate'));
			
			// //Print out the string and object for every entry in the Map called parsedResponse
			// for(String key : parsedResponse.keySet()) {
			// 	System.debug('The key is: ' + key);
			// 	System.debug('The value is: ' + parsedResponse.get(key));
			// 					}
			// }

			Contact cont = new Contact();
			cont.FirstName = (String) parsedResponse.get('firstName');
			cont.LastName = (String) parsedResponse.get('lastName');
			cont.Email = (String) parsedResponse.get('email');
			cont.Phone = (String) parsedResponse.get('phone');
			
			cont.Birthdate = Date.valueOf((String) parsedResponse.get('birthDate'));
			System.debug('the cont  birthdate is:	' + cont.Birthdate);

			// Cast the values in the 'address' key of the parsedResponse Map to a Map of String and Object
			Map<String, Object> parsedFullAddress = (Map<String, Object>) parsedResponse.get('address');
			//print out the value of the 'address' key of the parsedResponse Map
			System.debug('The value of the address key of the parsedFullAddress Map is: ' + parsedFullAddress);

			//Cast the value of the 'address' key of the parsedFullAddress Map to a String
			String parsedMailingStreet = (String) parsedFullAddress.get('address');
			System.debug('parsedMailingStreet contains: ' + parsedMailingStreet);

			String parsedMailingCity = (String) parsedFullAddress.get('city');
			System.debug('parsedMailingCity contains: ' + parsedMailingCity);

			String parsedMailingPostalCode = (String) parsedFullAddress.get('postalCode');
			System.debug('parsedMailingPostalCode contains: ' + parsedMailingPostalCode);

			String parsedMailingState = (String) parsedFullAddress.get('state');
			System.debug('parsedMailingState contains: ' + parsedMailingState);

			String parsedMailingCountry = (String) parsedFullAddress.get('country');
			System.debug('parsedMailingCountry contains: ' + parsedMailingCountry);

			cont.MailingStreet = parsedMailingStreet; 
			cont.MailingCity = parsedMailingCity;
			cont.MailingPostalCode = parsedMailingPostalCode; 
			cont.MailingState = parsedMailingState;
			cont.MailingCountry = parsedMailingCountry; 
			cont.DummyJSON_Id__c = dummyUserId;
			upsert cont DummyJSON_Id__c; //insert/update from the JSON response using the external id (dummyUserId)
			System.debug('The record was created successfully.');
		} else {
			System.debug('The callout was unsuccessful due to: ' + response.getStatusCode() + ' ' + response.getStatus());

	}

}
	

		/* 
	 * Question 2 - test passed
     * Transforms a JSON response from the external system https://dummyjson.com/users into a Salesforce Contact object.
     * The method parses the JSON string to extract user details and map them to a Salesforce Contact object.
     * The contact fields populated from the JSON include Email, Phone, Birthdate, and various address-related fields.
     * The method is primarily designed to work in conjunction with callouts that fetch user details from the external system. 
	 * 
	 * Fields from JSON used to populate Salesforce Contact
	 * Fields: Email, Phone, Birthdate, MailingStreet, MailingCity, MailingPostalCode, MailingState, MailingCountry
	 * 
     * Documentation: https://dummyjson.com/docs/users
     * 
     * @param String jsonResponse The JSON string from the external system that contains user details.
     * @return Contact The Salesforce Contact object populated with details from the JSON string.
     */
	@TestVisible // Allows test class to see this method. Since it is private, it would not be visible otherwise.
	private static Contact createContactFromJson(String jsonResponse) {
		// Deserialize the JSON string into map of primitive data types.
		Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
		// Create a new contact from the JSON response.
		Contact cont = new Contact();
		// Set the contact fields from the JSON response. email, phone, birthdate
			cont.FirstName = (String) parsedResponse.get('firstName');
			cont.LastName = (String) parsedResponse.get('lastName');
			cont.Email = (String) parsedResponse.get('email');
			cont.Phone = (String) parsedResponse.get('phone');
			cont.Birthdate = Date.valueOf((String) parsedResponse.get('birthDate'));

		// Deserialize the address from the JSON response.
		Map<String, Object> parsedFullAddress = (Map<String, Object>) parsedResponse.get('address');
		// Set the address fields on the contact: MailingStreet, MailingCity, MailingPostalCode, MailingState, MailingCountry
			cont.MailingStreet = (String) parsedFullAddress.get('address');
			cont.MailingCity = (String) parsedFullAddress.get('city');
			cont.MailingPostalCode = (String) parsedFullAddress.get('postalCode');
			cont.MailingState = (String) parsedFullAddress.get('state');
			cont.MailingCountry = (String) parsedFullAddress.get('country');
		
			//String DummyJsonLastUpdatedString = Datetime.now().format('yyyy-MM-dd');
			//String DummyJsonLastUpdatedString = Date.today().format();
		// Get the current Datetime
	Datetime myDateTime = Datetime.now();

	// Convert Datetime to String in the desired format (e.g., ISO 8601)
	//String DummyJsonLastUpdatedString = myDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

	// Assign the formatted String to the text field
	cont.DummyJSON_Last_Updated__c = myDateTime;

	Upsert cont;

	return cont;
	}

	/* 
	 * Question 3 - current focus as of Nov 26.
     * Sends Contact information to an external system https://dummyjson.com/users/add ('DummyJsonUser') to create or update a user based on the provided Salesforce Contact ID.
     * The method prepares a JSON payload with the contact's information and sends it to the 'DummyJsonUser' add endpoint.
     * If the callout is successful (HTTP status code between 200 and 299), the method updates the contact's 'DummyJSON_Last_Updated__c' field in Salesforce to the current time.
	 * Salesforce Contact should be used to generate the JSON payload
	 * Fields: Id, FirstName, LastName, Email, Phone
	 * This callout method should work in triggers
	 * 
     * Documentation: https://dummyjson.com/docs/users
     * 
     * @param contactId The Salesforce Contact ID used to generate the JSON payload for the external system.
     */
	
	public static void postCreateDummyJSONUser(String contactId) {
		// Create HTTP request to send. - drafted code

		HttpRequest req = new HttpRequest();

		// Set the endpoint URL. Use direct URL or for best practices use Named Credential. - drafted code

		req.setEndpoint('callout:https://dummyjson.com/users' + contactId);

		// Set the HTTP method to POST. - drafted code
		req.setMethod('POST');

		// Set the body using generateDummyJsonUserPayload method. - pause here because this step requires question 4 to be solved first
			req.setBody(generateDummyJsonUserPayload(contactId));
		// Send the HTTP request and get the response.
		Http http = new Http();
		HttpResponse response = http.send(req);
		
		// If the HTTP response code is successful, update the contact.
		if (response.getStatusCode() == 200) {
			Contact cont = [SELECT Id FROM Contact WHERE Id = :contactId];
			cont.DummyJSON_Last_Updated__c = Datetime.now();
			update cont;
		}
		
	}

	/*
	 * Question 4
     * Generates a JSON payload based on a Salesforce Contact's fields to be sent to an external system https://dummyjson.com/users/add for user creation or update.
     * The method queries a contact from Salesforce based on the provided contactId and maps its fields into a JSON payload.
     * The fields from Salesforce Contact that are transformed into the JSON payload include Id, FirstName, LastName, Email, and Phone.
     * The generated JSON payload can be sent to the external system for various operations like creating or updating a user.
	 * 
	 * Fields from Salesforce Contact used to generate JSON payload:
	 * Fields: Id => salesforceId, FirstName => firstName, LastName => lastName, Email => email, Phone => phone
	 * 
     * Documentation: https://dummyjson.com/docs/users
     * 
     * @param String contactId The Salesforce Contact ID used to fetch the contact's fields and generate the JSON payload.
     * @return String The JSON string payload that represents the Contact's details.
     */
	@TestVisible // Allows test class to see this method. Since it is private, it would not be visible otherwise.
	private static String generateDummyJsonUserPayload(String contactId) {
		// Query the contact to get the field values to generate the JSON payload. Step 1 is done!
		Contact cont = [SELECT ID, FirstName, LastName, Email, Phone FROM Contact WHERE ID = :contactId]; // WHERE ID =contactId];

		// Create a map of the field values. Step 2 is done!
		Map<String, Object> contactMapForJson = new Map<String, Object>();
		contactMapForJson.put('salesforceId', cont.Id);
		contactMapForJson.put('firstName', cont.FirstName);
		contactMapForJson.put('lastName', cont.LastName);
		contactMapForJson.put('email', cont.Email);
		contactMapForJson.put('phone', cont.Phone);

		// Serialize the map into a JSON string.
		String jsonString = JSON.serialize(contactMapForJson);

		// Make sure to check that required contacts fields have a value. Default the value to unknown if it does not exists.
		if (Cont.LastName == null) {
			cont.LastName = 'Unknown';
			jsonString = jsonString.replace('"salesforceId":"' + cont.Id + '"', '"salesforceId":"' + cont.LastName + '"');
		}
		
		// Integration data can change over time. It is a best practice to add safeguards/validation to ensure the integration does not break.
			// I don't understand the instruction in the line above. Is this above checking the HTTP status codes?
			
		return jsonString;
	}
}