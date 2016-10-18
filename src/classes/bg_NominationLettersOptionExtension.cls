/*****************************************************************
 *  Class: bg_NominationLettersOptionExtension
 *
 *  An extension of the Base virtual class to support the pages where Letter option is selected
 *
 *	Test Class: bg_NominationLettersOptionExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 ****************************************************************/
public class bg_NominationLettersOptionExtension extends bg_NominationBaseExtension
{
	/* public property to create options for attaching supporting letters
    */
    public List<SelectOption> letterOptions
    {

        get
        {
            if(letterOptions == null || letterOptions.isEmpty())
            {
                letterOptions = new List<selectOption>();
                letterOptions.addAll(bg_SObjectUtils.getSelectOptionTypes(Case.getSObjectType(), 'Letters_Of_Support_Option__c'));
            }

            return letterOptions;
        }
        set;
    }

	//Constructor
	public bg_NominationLettersOptionExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}


	public override PageReference saveRecords()
	{
		// Needs its own Custom extension that extends from base with override of Save method
		// Save does not update the status during save and then redirects based on the answer = if no via the next page wrapper - if yes to form 16
		String statusToUse = Nomination.Progress__c;
		Boolean saveSuccess = true; //assume succeess
		Boolean useBaseRedirection = false; //assume yes is selected
		PageReference returnPage;

		if ((Nomination.Letters_Of_Support_Option__c != null) &&
			(Nomination.Letters_Of_Support_Option__c == System.Label.HAS_Attachment_Letters_Option_No))
		{
			statusToUse = CurrentPageWrapper.NextPageStatus;
			useBaseRedirection = true;
		}
		saveSuccess = super.upsertNomination(statusToUse);

		if (saveSuccess)
		{
			if (useBaseRedirection)
			{
				returnPage = bg_formUtils.GetRedirectionPage(CurrentPageWrapper, Nomination.Id);
			}
			else
			{
				returnPage = new PageReference(bg_FormUtils.HAS_FORM_UPLOAD_LETTERS_URL);
				returnPage.getParameters().put('Id', Nomination.Id);
				returnPage.getParameters().put('retURL',CurrentPageName);
				returnPage.setRedirect(true);
			}
		}

		return returnPage;
	}
}