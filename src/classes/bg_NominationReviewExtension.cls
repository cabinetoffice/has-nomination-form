/*****************************************************************
 *  Class: bg_NominationReviewExtension
 *
 *  The generic extension of the Base virtual class to support the majority of the Nomination VF Pages
 *
 *	Test Class: bg_NominationReviewExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes: Remove supporterId - no longer required it seems.
 *
 ****************************************************************/
public class bg_NominationReviewExtension extends bg_NominationBaseExtension
{
	public List<Supporter__c> Supporters {get; set;}
	public List<Post__c> Posts {get; set;}
	public List<Nomination_Attachment__c> LetterAttachments {get; set;}
	public List<Nomination_Attachment__c> EvidenceAttachments {get; set;}

	//Constructor
	public bg_NominationReviewExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}

	protected override void populateProperties()
	{
		// Get attachments for the Letters attachment page list
		LetterAttachments = bg_FormUtils.getNominationAttachments(Nomination.Id, bg_FormUtils.NOMINATION_ATTACHMENT_LETTER);

		// Get attachments for the Evidence attachment page list
		EvidenceAttachments = bg_FormUtils.getNominationAttachments(Nomination.Id, bg_FormUtils.NOMINATION_ATTACHMENT_EVIDENCE);

		// Get Supporters for Nomination
		Supporters = bg_FormUtils.getSupporters(Nomination.Id);

		// Get Posts For Nomination
		Posts = bg_FormUtils.getPosts(Nomination.Id);

        readOnlyMode = Nomination.Progress__c == Label.HAS_Nomination_Completed_Status;

		SaveNominee = false;
		SaveNominator = false;

	}


}