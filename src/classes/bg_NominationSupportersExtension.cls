/*****************************************************************
 *  Class: bg_NominationSupportersExtension
 *
 *  An extension of the Base virtual class to support the pages where Supporters Details change
 *
 *	Test Class: bg_NominationSupportersExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes: 08/09/2016 NF Added populateProperties() including getSupporters() to populate the list if supporters exist
 ****************************************************************/
public class bg_NominationSupportersExtension extends bg_NominationBaseExtension
{
	public List<Supporter__c> Supporters {get; set;}
	public Id supporterId {get; set;}

	//Constructor
	public bg_NominationSupportersExtension(ApexPages.StandardController stdController)
	{
		super(stdController);

	}

	/*
        overridden populate properties to setup the Posts property
    */
    protected override void populateProperties()
    {
		System.debug('### Nomination Id: ' + Nomination.Id);
		Supporters = bg_FormUtils.getSupporters(Nomination.Id);

        SaveNominee = false;
        SaveNominator = false;

		/*
			Check that the required number of supporters has been added before proceeding to save.
			If there are less than or equal to the number specified in the custom setting we should call
			back to the base Controller Extension and attempt to save the record or if not, display a
			helpful error message.
		*/
		if (Supporters.size() < 2)
		{
			// Display a helpful error to remedy the issue
			ValidData = false;
		}
		else
		{
			// Set save to true
			ValidData = true;

		}

		readOnlyMode = Nomination.Progress__c == Label.HAS_Nomination_Completed_Status;

    }

	/* method used to add a supporter record to the list
    * this is called on the VF page
    */
    public PageReference openSupporterForm()
    {
        PageReference pageRef = Page.HAS_SupportersForm;
        pageRef.getParameters().put('submissionId',Nomination.Id);
		pageRef.getParameters().put('retURL',CurrentPageName);

        pageRef.setRedirect(true);
        return pageRef;
    }

    /* method used to edit a supporter record to the list
    * this is called on the VF page
    */

    public PageReference editSupporter()
    {

        PageReference pageRef = Page.HAS_SupportersForm;
        pageRef.getParameters().put('submissionId',Nomination.Id);
        pageRef.getParameters().put('Id',supporterId);
		pageRef.getParameters().put('retURL', CurrentPageName);

        pageRef.setRedirect(true);
        return pageRef;
    }

    /* method used to delete a supporter record to the list
    * this is called on the VF page
    */

    public PageReference deleteSupporter()
    {
      PageReference pageRef = Page.HAS_FormPage17;
      pageRef.getParameters().put('Id',Nomination.Id);
      try
      {
        Supporter__c recordToDelete = new Supporter__c(id=supporterId);
        delete recordToDelete;
      }
      catch(Exception ex)
      {
        System.debug(LoggingLevel.ERROR, '##### ERROR - unexpected msg: ' + ex.getMessage());
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));
      }
      pageRef.setRedirect(true);
      return pageRef;
    }

}