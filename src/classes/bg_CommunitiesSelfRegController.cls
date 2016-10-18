/********************************************************************
 * bg_CommunitiesSelfRegController 
 *
 * Controller class for HAS Create Account VF Page
 * 
 * Test Class: bg_CommunitiesSelfRegController_Test
 *
 * Author: Chris Eales - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 * 17-03-2015 CPE	Populate field error from Contact.Firstname Label not User.FirstName as field label cannot be overwritten
 * 18-03-2015 CPE	Extended the error messaging to replace '[eMailAddress]' with custom label
 * 13-04-2016 N*F   Removed references to account and VAT checks
 ********************************************************************/
public without sharing class bg_CommunitiesSelfRegController 
{
	public Account newAccount {get; set;}
	public User newUser {get; set;}
	
	public bg_CommunitiesSelfRegController(Apexpages.standardController stdController) 
	{
		newAccount = new Account();
		newUser = (User)stdController.getRecord();
	}

	/*
		Register User method.  This method creates an Account record storing the elements populated on the VF Page.
		It sets the account owner to the Site Admin Id.  Next it attempts to create a Community User and redirects
		the user to the Confirmation Page;  If any elements fail the transaction is rolled back
	*/	
	public PageReference registerUser() 
	{
		PageReference page;
		Id newUserId; 
		System.savePoint sp = Database.setSavePoint();

		system.debug(system.logginglevel.info, '### Register User is executing');

		if (newAccount.OwnerId == null)
		{
			newAccount.OwnerId = Site.getAdminId();
		}


		//Validate fields
		Boolean userFieldsValid = CheckUserFields();

		
		system.debug(system.logginglevel.error, 'userFieldsValid: ' + userFieldsValid);

		if (userFieldsValid)
		{
			newAccount.Individual_FirstName__c = newUser.FirstName;
			newAccount.Individual_LastName__c = newUser.LastName;
			
			newAccount.Name = newAccount.Individual_FirstName__c.trim() + ' ' +
			newAccount.Individual_LastName__c.trim();
			
			Database.saveResult sr = Database.insert(newAccount, false);

			if (!sr.isSuccess())
			{
				Database.rollback(sp);
				Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error, sr.getErrors()[0].getMessage()));
			}
			else
			{

				newUser.Username = newUser.Email; 
				String nickName = newUser.Email.left(newUser.Email.indexOf('@')) + Datetime.now().format('hh_mm_ss');
				newUser.CommunityNickname = nickName;  
				
				newUserId = Site.createPortalUser(newUser, newAccount.Id, '', false);
	
				if (newUserId == null)
				{ 
					database.rollback(sp);
					newAccount.Id = null;
					Apexpages.getMessages().clear();
					String createError = System.Label.HAS_User_Create_Failed.replace('[emailAddress]', system.label.HAS_Feedback_Email);
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, createError));
				}
				else
				{
					page = System.Page.HAS_CommunitiesSelfRegConfirm;
					page.setRedirect(true);
				}
			} 
		}
		return page;
	}

	/*
		Validates mandatory user fields and adds errors as required.  Return true if all required fields are populated
	*/
	private Boolean CheckUserFields()
	{
		Boolean fieldsValid = true; //assume fields populated
		List<String> madatoryFields = new List<String>{ 'FirstName', 'LastName', 'Email'};
		Map<String, Boolean> fieldValidity = new Map<String, Boolean>();
		
		fieldValidity = bg_SObjectUtils.CheckMandatoryFields(newUser, madatoryFields);		

		if ((fieldValidity.containsKey('FirstName')) &&
			(!fieldValidity.get('FirstName')))
		{
			newUser.FirstName.addError(System.Label.HAS_Error_Field_Required.Replace('[field]', Schema.sObjectType.Contact.fields.FirstName.Label));
			fieldsValid = false;
		}
		if ((fieldValidity.containsKey('LastName')) &&
			(!fieldValidity.get('LastName')))
		{
			newUser.LastName.addError(System.Label.HAS_Error_Field_Required.Replace('[field]', Schema.sObjectType.User.fields.LastName.Label));
			fieldsValid = false;
		}
		if ((fieldValidity.containsKey('Email')) &&
			(!fieldValidity.get('Email')))
		{
			newUser.Email.addError(System.Label.HAS_Error_Field_Required.Replace('[field]', Schema.sObjectType.User.fields.Email.Label));
			fieldsValid = false;
		}
		
		return fieldsValid;
	}
}