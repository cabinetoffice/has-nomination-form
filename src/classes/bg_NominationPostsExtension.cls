/*****************************************************************
 *  Class: bg_NominationPostsExtension
 *
 *  An extension of the Base virtual class to support the pages where Posts Details change
 *
 *	Test Class: bg_NominationPostsExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes: 08/09/2016 NF Added populateProperties() including getPosts() to populate the list if posts exist
 *
 ****************************************************************/
public class bg_NominationPostsExtension extends bg_NominationBaseExtension
{
	public List<Post__c> Posts {get; set;}
	public Id postId {get; set;}

	//Constructor
	public bg_NominationPostsExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}

	/*
        overridden populate properties to setup the Posts property
    */
    protected override void populateProperties()
    {
		// Return a list of posts for the page
		Posts = bg_FormUtils.getPosts(Nomination.Id);

		/*
			Check that the required number of posts has been added before proceeding to save.
			If there are less than or equal to the number specified in the custom setting we should call
			back to the base Controller Extension and attempt to save the record or if not, display a
			helpful error message.
		*/
		if (Posts.size() < 1)
		{
			// Display a helpful error to remedy the issue
			ValidData = false;
		}
		else
		{
			// Set save to true
			ValidData = true;

		}

		SaveNominee = false;
        SaveNominator = false;

        readOnlyMode = Nomination.Progress__c == Label.HAS_Nomination_Completed_Status;

    }


	/* method used to add a post record to the list
	* this is called on the VF page
	*/
	public PageReference openPostForm()
	{
		PageReference pageRef = Page.HAS_PostsForm;
		pageRef.getParameters().put('submissionId',Nomination.Id);
		pageRef.getParameters().put('retURL', CurrentPageName);

		pageRef.setRedirect(true);
		return pageRef;
	}

	/*
		method used to edit a post record from the list on the VF page
	*/

	public PageReference editRecord()
	{
		PageReference pageRef = Page.HAS_PostsForm;
		pageRef.getParameters().put('submissionId',Nomination.Id);
		pageRef.getParameters().put('Id',postId);
		pageRef.getParameters().put('retURL', CurrentPageName);

		pageRef.setRedirect(true);
		return pageRef;
	}

	/*
		method used to delete a post record on the VF page
	*/

	public PageReference deleteRecord()
	{

	  PageReference pageRef = Page.HAS_FormPage11;
	  pageRef.getParameters().put('Id',Nomination.Id);


	  try
	  {
		Post__c recordToDelete = new Post__c(id=postId);
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