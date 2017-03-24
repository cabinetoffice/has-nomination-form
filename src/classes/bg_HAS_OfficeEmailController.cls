public class bg_HAS_OfficeEmailController {

	public Id NominationId {get;
		set
		{
		 NominationId = value;
		 populateLists();
	 	}
	}
 	public Case Nomination
	 {
	 	get
	 	{
			return getNomination();
	 	}
		set;
	 }
	public Contact Nominee
	{
		get
		{
			return getNominee();
		}
		set;
	} // The Nominee Conact Record
    public Contact Nominator  // The Nominator Contact Record
	{
		get {
				return getNominator();
			}
		set;
	}

	public List<Supporter__c> Supporters {get; set;}
	public List<Post__c> Posts {get; set;}
	public List<Nomination_Attachment__c> LetterAttachments {get; set;}
	public List<Nomination_Attachment__c> EvidenceAttachments {get; set;}

	public bg_HAS_OfficeEmailController() {
		//Constructor is empty

	}


	// Get the nomination Case record from
	public Case getNomination()
	{
		return database.query('SELECT Progress__c, Nominator__c, Nominee__c, Other_Recognition__c, Others_In_Post__c, Post_Details__c, Standout_Details__c, Recommendation_summary__c, Benefits_Details__c, Drafting_Service_Used__c, Relationship_Nominator_to_Nominee__c, Evidence_Option__c, Letters_of_Support_Option__c, Progress_Status__c, ContactId FROM Case WHERE Id= \'' + NominationId + '\'');
	}

	public Contact getNominee()
    {

		// if ((NominationId != null) &&
        //     (Nomination.Nominee__c != null))
        // {
			Id nomineeId = Nomination.Nominee__c;
			return bg_FormUtils.getNominee(nomineeId);
        // }
    }

    /*
        Method to populate the nominator property - This is the Contact record associated with the logged in Portal user
    */
    public Contact getNominator()
    {
        // call to utility method to obtain the contact record from the current logged in user
		// if ((NominationId != null) &&
        //     (Nomination.ContactId != null))
		// {

			return bg_FormUtils.getNominator(Nomination.ContactId);
    	// }
	}

	public void populateLists()
	{
		if(Nomination != null)
		{
			// Populate the Nominator Property based on the current user
			//populateNominator();

			// Populate the Nominee Property based on the Case that has been passed in
			//populateNominee();

			// Get attachments for the Letters attachment page list
			LetterAttachments = bg_FormUtils.getNominationAttachments(NominationId, bg_FormUtils.NOMINATION_ATTACHMENT_LETTER);

			// Get attachments for the Evidence attachment page list
			EvidenceAttachments = bg_FormUtils.getNominationAttachments(NominationId, bg_FormUtils.NOMINATION_ATTACHMENT_EVIDENCE);

			// Get Supporters for Nomination
			Supporters = bg_FormUtils.getSupporters(NominationId);

			// Get Posts For Nomination
			Posts = bg_FormUtils.getPosts(NominationId);
		}
	}
}