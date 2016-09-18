package
{	
	/*
	
	This class contains all the error responses the Firebase API may output.
	These responses have been taken from the Firebase 3.4.0 JavaScript SDK.
	The response strings have been modified for clearer readibility.
	
	To use this class, you need to convert a Firebase JSON response into an AS3 Object using the JSON.parse() method
	
	var response:Object = JSON.parse(event.currentTarget.data);	
	Alert.show(Responses[response.error.message], "Error");
	
	*/
	public class Responses extends Object
	{		
		Responses["INVALID_CUSTOM_TOKEN"] = "Invalid Custom Token";
		Responses["CREDENTIAL_MISMATCH"] = "Custom Token Mismatch";
		Responses["MISSING_CUSTOM_TOKEN"] = "Missing Custom Token";
		Responses["INVALID_IDENTIFIER"] = "Invalid Email";
		Responses["MISSING_CONTINUE_URI"] = "Missing Continue URI";
		Responses["INVALID_EMAIL"] = "Invalid Email";
		Responses["INVALID_PASSWORD"] = "Wrong Password";
		Responses["USER_DISABLED"] = "User Disabled";
		Responses["MISSING_PASSWORD"] = "Missing Password";
		Responses["EMAIL_EXISTS"] = "Email Already in Use";
		Responses["PASSWORD_LOGIN_DISABLED"] = "Operation Not Allowed";
		Responses["INVALID_IDP_RESPONSE"] = "Invalid Credential";
		Responses["FEDERATED_USER_ID_ALREADY_LINKED"] = "Credential Already in Use";
		Responses["EMAIL_NOT_FOUND"] = "User Not Found";
		Responses["EXPIRED_OOB_CODE"] = "Expired Action Code";
		Responses["INVALID_OOB_CODE"] = "Invalid Action Code";
		Responses["MISSING_OOB_CODE"] = "Missing Action Code";
		Responses["CREDENTIAL_TOO_OLD_LOGIN_AGAIN"] = "Requires Recent Login";
		Responses["INVALID_ID_TOKEN"] = "Invalid User Token";
		Responses["TOKEN_EXPIRED"] = "User Token Expired";
		Responses["USER_NOT_FOUND"] = "User Token Expired";
		Responses["CORS_UNSUPPORTED"] = "Cross-Origin Resource Sharing Unsupported";
		Responses["TOO_MANY_ATTEMPTS_TRY_LATER"] = "Too Many Attempts, Try Later";
		Responses["WEAK_PASSWORD"] = "Weak Password";
		Responses["OPERATION_NOT_ALLOWED"] = "Operation Not Allowed";
		Responses["USER_CANCELLED"] = "User Cancelled"	
	}			
}