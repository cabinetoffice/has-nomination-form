/*****************************************************************
 *  Class: bg_NominationAttachmentsExtension
 *
 *  An extension of the Base virtual class to support the pages where Attachments Details change
 *
 *	Test Class: bg_NominationAttachmentsExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes: 19/09/2016 Nic Flook - Added override to for previousPage() to use the return url parameter as
 *									atttachents are outside of the form pageReference framework
 *
 ****************************************************************/
public class bg_NominationAttachmentsExtension extends bg_NominationBaseExtension
{
	public List<Nomination_Attachment__c> LetterAttachments {get; set;}
	public List<Nomination_Attachment__c> EvidenceAttachments {get; set;}
	public Id nominationAttachmentId {get; set;}
	public String previousPageName {get; set;}
	public String uploadPage {get; set;}
	public String evidenceKeyword
	{
		get
		{
			evidenceKeyword = bg_FormUtils.NOMINATION_ATTACHMENT_EVIDENCE;
			return evidenceKeyword;
		}
		set;
	}

	public String letterKeyword
	{
		get
		{
			letterKeyword = bg_FormUtils.NOMINATION_ATTACHMENT_LETTER;
			return letterKeyword;
		}
		set;
	}

	//Constructor
	public bg_NominationAttachmentsExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}

	protected override void populateProperties()
	{
		// Get attachments for the Letters attachment page list
		LetterAttachments = bg_FormUtils.getNominationAttachments(Nomination.Id, letterKeyword);

		// Get attachments for the Evidence attachment page list
		EvidenceAttachments = bg_FormUtils.getNominationAttachments(Nomination.Id, evidenceKeyword);

		SaveNominee = false;
		SaveNominator = false;

	}

	public PageReference deleteAttachment()
    {
		PageReference pageRef;

		try
        {
            Nomination_Attachment__c attachmentToDelete = new Nomination_Attachment__c(id = nominationAttachmentId);
            delete attachmentToDelete;
        }
        catch(Exception ex)
        {
            System.debug(LoggingLevel.ERROR, '##### ERROR - unexpected msg: ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));
        }

		/*
		   After successful delete, refresh the attachment page with parameters intact
		*/
		if(uploadPage == Label.HAS_Form_Upload_Evidence_Page_Name)
		{
			pageRef = new pageReference(bg_FormUtils.HAS_FORM_UPLOAD_EVIDENCE_URL);
		}
		else if(uploadPage == Label.HAS_Form_Upload_Letters_Page_Name)
		{
			pageRef = new pageReference(bg_FormUtils.HAS_FORM_UPLOAD_LETTERS_URL);
		}

		pageRef.getParameters().put('Id',Nomination.Id);
		pageRef.getParameters().put('retURL',previousPageName);

		pageRef.setRedirect(true);
        return pageRef;
    }

	// Override the previousPage in the base extension to take the user back to the options form page.
	public override PageReference previousPage()
	{
			return bg_formUtils.GetRedirectUrl(Nomination.Id);
	}


}