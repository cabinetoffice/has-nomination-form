/********************************************************************
 * bg_HAS_SupportersFormController
 *
 * Custom controller for handling Supporter submission form data
 *
 *
 *
 * Author: Nic FLook - BrightGen Ltd
 * Created: 18-08-2016
 *
 *
 ********************************************************************/

public without sharing class bg_HAS_SupportersFormController {

	public Supporter__c supporter {get; set;}
	public Id submissionId;
  	public Id supporterId;
	public Case submission {get; set;}

	// Constructor method
	public bg_HAS_SupportersFormController(ApexPages.StandardController supporterController)
	{
				submissionId = ApexPages.currentPage().getParameters().get('submissionId');

				supporter = (Supporter__c)supporterController.getRecord();

				if(supporter.Nomination_Id__c == null)
				{
					supporter.Nomination_Id__c = submissionId;
				}
	}

	public PageReference saveSupporter()
	{
		PageReference pageref;

		try
		{
				if(supporter != null)
				{
						upsert supporter;

						/*
							After successful Save, navigate back to the supporter form
							page using a util method to determine the landing page
						*/
						
						pageRef = bg_formUtils.GetRedirectUrl(submissionId);
				}
				else
				{
						ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, 'Supporter upsert error encountered'));
				}
		}
		catch(Exception ex)
		{

				System.debug(LoggingLevel.ERROR, '##### ERROR - unexpected msg: ' + ex.getMessage());
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));
		}


		return pageRef;

		}

		/* Takes the nominator back to the Supporters page if they want to cancel a supporter submission */
		public PageReference cancelSupporter()
		{
			return bg_formUtils.GetRedirectUrl(submissionId);
		}


	}