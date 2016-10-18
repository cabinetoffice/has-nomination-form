/********************************************************************
 * bg_HAS_PostsFormController
 *
 * Custom controller for handling Post submission form data
 *
 *
 *
 * Author: Nic Flook - BrightGen Ltd
 * Created: 21-08-2016
 *
 *
 ********************************************************************/

public without sharing class bg_HAS_PostsFormController {

	public Post__c post {get; set;}
	public Id submissionId;
	public Case submission {get; set;}

	// Constructor method
	public bg_HAS_PostsFormController(ApexPages.StandardController postController)
	{
			// Assign the submissionId parameter to the submissionId property
			submissionId = ApexPages.currentPage().getParameters().get('submissionId');

			post = (Post__c)postController.getRecord();

			/*
				If a post doesn't exist we will use a new post record and set
			 	the nomination Id lookup so that it is associated with our active nomination.
			*/
			if(post.Nomination_Id__c == null)
			{
				post.Nomination_Id__c = submissionId;
			}
	}

	/*
		Once fields on the Post form are complete then the Post should be saved
		to the database and the nominator should be taken back to the
	*/

	public PageReference savePost()
	{
			PageReference pageRef;

			try
			{
					if(post != null)
					{
							upsert post;

							/*
								After successful Save, navigate back to the posts form
								page using a util method to determine the landing page
							*/
							pageRef = bg_formUtils.GetRedirectUrl(submissionId);
					}
					else
					{
							ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, 'Post upsert error encountered'));
					}
			}
			catch(Exception ex)
			{
					System.debug(LoggingLevel.ERROR, '##### ERROR - unexpected msg: ' + ex.getMessage());
					ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));
			}

			return pageRef;
		}

		/*
			Takes the nominator back to the Supporters page
			if they want to cancel a post submission.
		*/
		public PageReference cancelPost()
		{
			return bg_formUtils.GetRedirectUrl(submissionId);
		}
}