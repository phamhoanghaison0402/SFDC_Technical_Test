/**********************************************************************
 * 
 *
 * @url: /services/apexrest/ContactRest
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/ContactRest/*')
global with sharing class ContactRest {
    
    @HttpPost
    global static String createContact(String firstname, String lastname, String email, String phone) {
    	Contact newContact = new Contact(
    		FirstName = firstname,
    		LastName = lastname,
    		Email = email,
    		Phone = phone
    	);

    	Database.SaveResult contactInsertResult = Database.insert(newContact);

    	if (contactInsertResult.isSuccess()){
    		return String.valueOf(contactInsertResult.getId());
    	}

        return null;
    } 

    @HttpGet
    global static List<Contact> getAll() {
		List<Contact> contacts = new List<Contact>();

		contacts = [SELECT Id, Name 
                    FROM Contact];

        return contacts;
    }

    @HttpPatch
    global static ErrorMessageModel updateContact() {
 		RestRequest request = RestContext.request;
        String jSONRequestBody = request.requestBody.toString().trim();

 		List<ContactRequestModel> contactRequestModels = (List<ContactRequestModel>) JSON.deserializeStrict(jSONRequestBody, List<ContactRequestModel>.class);
       
       List<Contact> updateContacts = new List<Contact>();

 		for (ContactRequestModel c : contactRequestModels) {
 				List<Contact> thisContact = [SELECT Id, FirstName 
 									   		FROM Contact 
 									   		WHERE Id =: c.ContactId];

 				if (thisContact.size() == 0) {
					return new ErrorMessageModel('Contact does not exits in system!!!');
 				}
 				
 				thisContact[0].FirstName = c.ContactName;

 				updateContacts.addAll(thisContact); 
        } 

         if(updateContacts.size() > 0){
         	Database.SaveResult[] contactInsertResult = Database.update(updateContacts);
        }

        return new ErrorMessageModel('');
    }

     global class ContactRequestModel {
        public String ContactId { get; set; }
        public String ContactName { get; set; }
    }

    global class ErrorMessageModel {    
        public String ErrorMessage { get; set; }
        public boolean isSuccess { get; set; }

        public ErrorMessageModel() {}

        public ErrorMessageModel(String message) {
			ErrorMessage = message;

			if (String.isEmpty(ErrorMessage)){
				isSuccess = true;
			}
			else
			{
				isSuccess = false;
			}
        }
    }
}