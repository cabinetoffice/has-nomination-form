/********************************************************************
 * bg_formUtils
 *
 * Utilities class for bg_formUtils
 *
 *
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 06-04-2016
 * Changes: 22/04/16 SL:	added getNominator, getNominee, getSupporters, getAttachments, getInitialSupporters
 *			31/08/16 NF:    added getNominationAttachments to return a list of attachment records
 *			31/08/16 NF:    added nomination attachment picklist values for use
 *			02/09/16 CPE	Added HAS_DEFAULT_NOMINATION_STATUS constant
 *			10/09/16 NF: 	Added GetRedirectionPage method to obtain the redirection page from the supplied bg_PageSettingWrapper
 * 			10/09/16 NF: 	Added PREVIOUS_STATUS_URL_PARAMETER
 * 			15/09/16 NF: 	Added NOMINATION_ATTACHMENT_EVIDENCE and NOMINATION_ATTACHMENT_LETTER as constants
 ********************************************************************/
public class bg_formUtils
{
	// series of string representing the vaues expecting in the Case.Progress__c field
	// when each page of the form has been completed.
	// these are referenced in bg_NominationFormController
	public static final String NO_PAGES_COMPLETE_STATUS = '';
	public static final String PAGE1_COMPLETE_STATUS = 'Nominator Name';
	public static final String PAGE2_COMPLETE_STATUS = 'Nominator Address';
	public static final String PAGE3_COMPLETE_STATUS = 'Nominator Contact Details';
	public static final String PAGE4_COMPLETE_STATUS = 'Nominee Name';
	public static final String PAGE5_COMPLETE_STATUS = 'Nominee Address';
	public static final String PAGE6_COMPLETE_STATUS = 'Nominee Contact Details';
	public static final String PAGE7_COMPLETE_STATUS = 'Nominee DoB or Age';
	public static final String PAGE8_COMPLETE_STATUS = 'Nominee Nationality';
	public static final String PAGE9_COMPLETE_STATUS = 'Relationship to Nominee';
	public static final String PAGE10_COMPLETE_STATUS = 'Nominee service';
	public static final String PAGE11_COMPLETE_STATUS = 'Nominee Posts';
	public static final String PAGE12_COMPLETE_STATUS = 'Nominee Impact Statement';
	public static final String PAGE13_COMPLETE_STATUS = 'Nominee Similar Service';
	public static final String PAGE14_COMPLETE_STATUS = 'Nominee Other Awards/Recognition';
	public static final String PAGE15_COMPLETE_YES_STATUS = 'Nominee Evidence will be attached now';
	public static final String PAGE15_COMPLETE_NO_STATUS = 'Nominee Evidence will be sent later';
	public static final String PAGE16_COMPLETE_STATUS = 'Nominee Evidence';
	public static final String PAGE17_COMPLETE_STATUS = 'Nominee Supporters';
	public static final String PAGE18_COMPLETE_YES_STATUS = 'Nominee Supporter Letters will be attached now';
	public static final String PAGE18_COMPLETE_NO_STATUS = 'Nominee Supporter Letters will be attached later';
	public static final String PAGE19_COMPLETE_STATUS = 'Nominee Supporter Letters Uploaded';
	public static final String PAGE20_COMPLETE_STATUS = 'Equality Monitoring';
	public static final String PAGE21_COMPLETE_STATUS = 'Nomination Complete';
	public static final String AWAITING_LETTERS_OF_SUPPORT = 'Awaiting Letters of Support';
	public static final String SUBMISSION_COMPLETE_STATUS = 'Nomination Complete';
	public static final String FORM_PAGE1_NAME = 'has_formpage1';
	public static final String FORM_PAGE2_NAME = 'has_formpage2';
	public static final String FORM_PAGE3_NAME = 'has_formpage3';
	public static final String FORM_PAGE4_NAME = 'has_formpage4';
	public static final String FORM_PAGE5_NAME = 'has_formpage5';
	public static final String FORM_PAGE6_NAME = 'has_formpage6';
	public static final String FORM_PAGE7_NAME = 'has_formpage7';
	public static final String FORM_PAGE8_NAME = 'has_formpage8';
	public static final String FORM_PAGE9_NAME = 'has_formpage9';
	public static final String FORM_PAGE10_NAME = 'has_formpage10';
	public static final String FORM_PAGE11_NAME = 'has_formpage11';
	public static final String FORM_PAGE12_NAME = 'has_formpage12';
	public static final String FORM_PAGE13_NAME = 'has_formpage13';
	public static final String FORM_PAGE14_NAME = 'has_formpage14';
	public static final String FORM_PAGE15_NAME = 'has_formpage15';
	public static final String FORM_PAGE16_NAME = 'has_formpage16';
	public static final String FORM_PAGE17_NAME = 'has_formpage17';
	public static final String FORM_PAGE18_NAME = 'has_formpage18';
	public static final String FORM_PAGE19_NAME = 'has_formpage19';
	public static final String FORM_PAGE20_NAME = 'has_formpage20';
	public static final String FORM_PAGE21_NAME = 'has_formpage21';
	public static final String FORM_PAGE22_NAME = 'has_formpage22';

	public static final String HAS_FORM_UPLOAD_EVIDENCE_URL = '/' + Label.HAS_Form_Upload_Evidence_Page_Name; // The Add Evidence page
	public static final String HAS_FORM_UPLOAD_LETTERS_URL = '/' + Label.HAS_Form_Upload_Letters_Page_Name; // The Add Letters page

	public static final String HAS_POSTS_PAGE_STATUS = Label.HAS_Posts_Page_Status;
	public static final String HAS_SUPPORTERS_PAGE_STATUS = Label.HAS_Supporters_Page_Status;

	public static final String HAS_DEFAULT_NOMINATION_STATUS = Label.HAS_Default_Nomination_Status;
	public static final String PREVIOUS_STATUS_URL_PARAMETER = 'previousStatus';

	// Nomination Attachment categories based on picklist values
	public static final String NOMINATION_ATTACHMENT_EVIDENCE = 'Evidence';
	public static final String NOMINATION_ATTACHMENT_LETTER = 'Supporting letter';

	// String for the name of the custom setting entry being used for the HASFormSettings__c
	public static final String HAS_FORM_CUSTOM_SETTING = 'Default';

	// list of fields required on the case object in the form pages
	public static final List<String> CASE_FORM_FIELDS = new List<String> {'Progress__c', 'Nominator__c', 'Nominee__c', 'Other_Recognition__c', 'Others_In_Post__c', 'Post_Details__c', 'Standout_Details__c', 'Recommendation_summary__c', 'Benefits_Details__c', 'Drafting_Service_Used__c', 'Relationship_Nominator_to_Nominee__c', 'Evidence_Option__c', 'Letters_of_Support_Option__c', 'Contact', 'Progress_Status__c'};

	// // takes in a case record and returns its Progress__c value if present and an empty string if not
	// public static String getFormStatus(Case submission)
	// {
	// 	if(submission.Progress__c == null)
	// 	{
	// 		System.debug('##### submission Progesss is NULL in Form Utils');
	// 		return '';
	// 	}
	// 	else
	// 	{
	// 		System.debug('##### submission Progress: ' + submission.Progress__c);
	// 		return submission.Progress__c;
	// 	}
	// }

    // method to return the Nominator Contact record by performing a SOQL on the ID passed in
    public static Contact getNominator(Id currentUserContactId)
    {
    	return 	[
        		SELECT Id, Salutation, FirstName, LastName, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalcode, Phone, Email, Ethnic_Origin__c, Ethnic_Origin_Group__c, Disability__c
		        FROM Contact
		        WHERE Id =: currentUserContactId
		        ];
    }

    // method to return the Nominee Contact record by performing a SOQL on the ID passed in
    public static Contact getNominee(Id nomineeId)
    {
    	return 	[
				SELECT Id, Salutation, FirstName, LastName, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalcode, Phone, Email, Date_Of_Birth__c, Ethnic_Origin__c, Ethnic_Origin_Group__c, Disability__c, Nationality__c, Is_British__c, Post_Nominal__c, Known_As__c, Nationalities__c
				FROM Contact
				WHERE Id =: nomineeId
				];
	}

	// method to return the list of Supporter__c records by performing a SOQL on the Case ID passed in
    public static List<Supporter__c> getSupporters(Id submissionId)
    {
    	return 	[
				SELECT Id, Name, Knew_From__c, Knew_Until__c, Knew_From_Knew_Until__c, Letter_Submitted__c, Relationship__c
				FROM Supporter__c
				WHERE Nomination_Id__c =: submissionId
				];
    }

	// // method to return the a Supporter__c record by performing a SOQL on the Supporter ID passed in
	// 	public static Supporter__c getSupporter(Id supporterId)
    // {
    // 	return 	[
	// 			SELECT Id, Name, Knew_From__c, Knew_Until__c, Knew_From_Knew_Until__c, Letter_Submitted__c, Relationship__c, Nomination_Id__c
	// 			FROM Supporter__c
	// 			WHERE Id =: supporterId
	// 			];
    // }

		// method to return the list of Post__c records by performing a SOQL on the Case ID passed in
	    public static List<Post__c> getPosts(Id submissionId)
	    {
	    	return 	[
					SELECT Id, Name, Start_Date__c, End_Date__c, Start_Date_End_Date__c, Position_Status__c, Nomination_Id__c
					FROM Post__c
					WHERE Nomination_Id__c =: submissionId
					];
	    }

		// // method to return a Post__c record by performing a SOQL on the record ID passed in
		// 	public static Post__c getPost(Id recordId)
	    // {
	    // 	return 	[
		// 			SELECT Id, Name, Start_Date__c, End_Date__c, Start_Date_End_Date__c, Position_Status__c, Nomination_Id__c
		// 			FROM Post__c
		// 			WHERE Id =: recordId
		// 			];
	    // }

    // method to return the list of Attachment records by performing a SOQL on the parent ID passed in
	// TODO: remove this method as it's no longer required I think
    // public static List<Attachment> getAttachments(Id parentId)
    // {
    // 	return 	[
	// 			SELECT Name
	// 			FROM Attachment
	// 			WHERE ParentId =: parentId
	// 			];
    // }

	// method to return a list of nomination attachment records by performing a SOQL for a given submission Id
	public static List<Nomination_Attachment__c> getNominationAttachments(Id submissionId, String attachmentType)
    {
    	return 	[
				SELECT Id, Name, Attachment_Url__c, Attachment_Type__c
				FROM Nomination_Attachment__c
				WHERE Nomination__c =: submissionId AND Attachment_Type__c =: attachmentType
				];
    }

    /* method to check HASFormSettings custom setting for InitialNumberofSupporters__c value
     * this is used to set up the initial number of supporters viewed in the form
     * if there is no value in the cutstom settings then it defaults to 2
	*/
    public static Integer getInitialSupporters()
    {
    	HASFormSettings__c currentHASFormSettings = bg_customSettingsUtils.getFormSettings();

	    if(currentHASFormSettings != null && currentHASFormSettings.InitialNumberofSupporters__c > 0)
        {
            return Integer.valueOf(currentHASFormSettings.InitialNumberofSupporters__c);
        }
        else
        {
            return 2;
        }
    }

    /*
    	Method to obtain a redirection page from the supplied bg_PageSettingWrapper class
    */
    public static PageReference GetRedirectionPage(bg_PageSettingWrapper pageWrapper, Id recordId)
    {
    	PageReference result;
    	if ((pageWrapper != null) &&
    		(pageWrapper.NextPageName != null))
    	{
    		result = new PageReference('/' + pageWrapper.NextPageName);
    		result.getParameters().put('Id', recordId);
    		result.setRedirect(true);
    	}
    	return result;
    }

	/*
    	Method to obtain a the current page from the supplied bg_PageSettingWrapper class
    */
    public static PageReference GetCurrentPage(bg_PageSettingWrapper pageWrapper, Id recordId)
    {
    	PageReference result;
    	if ((pageWrapper != null) &&
    		(pageWrapper.PageName != null))
    	{
    		result = new PageReference('/' + pageWrapper.PageName);
    		result.getParameters().put('Id', recordId);
    		result.setRedirect(true);
    	}
    	return result;
    }

	/*
    	Method to obtain a redirection page from the supplied bg_PageSettingWrapper class
    */
    public static PageReference GetPreviousPage(bg_PageSettingWrapper pageWrapper, Id recordId)
    {
    	PageReference result;
    	if ((pageWrapper != null) &&
    		(pageWrapper.HasPrevious))
    	{
    		result = new PageReference('/' + pageWrapper.PreviousPageName);
    		result.getParameters().put('Id', recordId);
			result.getParameters().put(PREVIOUS_STATUS_URL_PARAMETER, pageWrapper.PreviousPageStatus);
    		result.setRedirect(true);
    	}
    	return result;
    }

	/*
        Method to evaluate the upsertResult record and add an error to the ApexPage as appropriate
    */
    public static Boolean EvaluateUpsertResult(Database.UpsertResult result)
    {
        Boolean saveSuccess = true;  // Assume success
        if (!result.isSuccess())
        {
            saveSuccess = false;
			System.debug(System.LoggingLevel.error, '### EvaluateUpsertResult : ' + result.getErrors()[0].getMessage());
            ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, result.getErrors()[0].getMessage()));
        }
        return saveSuccess;
    }

	/*
        Method to return picklist options for radio buttons HAS_FormGroup_Radio component
    */

	public static List<SelectOption> GetRadioOptions(String picklistField, List<SelectOption> radioList, Schema.sObjectType mySObjectType)
	{
		List<SelectOption> result = new List<SelectOption>();

		if(radioList == null || radioList.isEmpty())
		{
			radioList = new List<selectOption>();
			radioList.addAll(bg_SObjectUtils.getSelectOptionTypes(mySObjectType, picklistField));
		}
		else
		{
			result = radioList;
		}

		return result;
	}

	/*
		Utility method for getting a return url pageReference for supporter and
		post forms from the retURl parameter passed from the previous page
	*/

	public static PageReference getRedirectUrl(Id submissionId)
	{
		String returnURL = null;
		PageReference redirectUrl;

		returnURL = ApexPages.currentPage().getParameters().get('retURL');

		if (returnURL != null && returnURL != '')
		{
			redirectUrl = new PageReference(returnURL);
			redirectUrl.getParameters().put('Id',submissionId);
			redirectUrl.setRedirect(true);
		}
		return (redirectUrl);
	}
 }