/*****************************************************************
 *  Class: bg_NominationEvidenceOptionExtension
 *
 *  An extension of the Base virtual class to evidence option is selected
 *
 *	Test Class: bg_NominationEvidenceOptionExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 ****************************************************************/
public class bg_NominationEvidenceOptionExtension extends bg_NominationBaseExtension
{
	/* public property to create options for attaching evidence
    */
    public List<SelectOption> evidenceOptions
    {

        get
        {
            if(evidenceOptions == null || evidenceOptions.isEmpty())
            {
                evidenceOptions = new List<selectOption>();
                evidenceOptions.addAll(bg_SObjectUtils.getSelectOptionTypes(Case.getSObjectType(), 'Evidence_Option__c'));
            }

            return evidenceOptions;
        }
        set;
    }

	//Constructor
	public bg_NominationEvidenceOptionExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}


	public override PageReference saveRecords()
	{
		// Save does not update the status during save and then redirects based on the answer = if no via the next page wrapper - if yes to form 16
		String statusToUse = Nomination.Progress__c;
		Boolean saveSuccess = true; //assume succeess
		Boolean useBaseRedirection = false; //assume yes is selected
		PageReference returnPage;
		if ((Nomination.Evidence_Option__c != null) &&
			(Nomination.Evidence_Option__c == Label.HAS_Attachment_Evidence_Option_No))
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
				returnPage = new PageReference(bg_formUtils.HAS_FORM_UPLOAD_EVIDENCE_URL);
				returnPage.getParameters().put('Id', Nomination.Id);
				returnPage.getParameters().put('retURL',CurrentPageName);
				returnPage.setRedirect(true);
			}
		}

		return returnPage;
	}
}