/********************************************************************
 * bg_LoginController 
 *
 * Controller class for HAS_Login_Page VF Page
 * 
 * Test Class: bg_LoginController_Test
 *
 * Author: Chris Eales - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 *
 ********************************************************************/
global with sharing class bg_LoginController 
{
    global String username {get; set;}
    global String password {get; set;}
    
    global String usernameError {get; set;}
    global String passwordError {get; set;}

	global bg_LoginController()
	{
	}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        if (CheckUserFields())
        {
        	return Site.login(username, password, startUrl);
        }
        else
        {
        	return null;
        }
    }
    
    global PageReference register()
    {
    	PageReference returnPage = Page.HAS_Create_Account;
    	returnPage.setRedirect(true); 
    	return returnPage;
    }


	/*
		Validates mandatory user fields and adds errors as required.  Return true if all required fields are populated
	*/
	private Boolean CheckUserFields()
	{
		Boolean fieldsValid = true; //assume fields populated
		usernameError = '';
		passwordError = '';

		if ((username == null) ||
			(username == ''))
		{
			usernameError = System.Label.HAS_Error_Field_Required.Replace('[field]', system.label.site.username);
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, usernameError));
			fieldsValid = false;
		}
		if ((password == null) ||
			(password == ''))
		{
			passwordError = System.Label.HAS_Error_Field_Required.Replace('[field]', system.label.site.password);
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, passwordError));
			fieldsValid = false;
		}
		return fieldsValid;
	}

}