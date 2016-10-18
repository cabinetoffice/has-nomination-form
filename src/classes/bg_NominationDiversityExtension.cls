/*****************************************************************
 *  Class: bg_NominationDiversityExtension
 *
 *  An extension of the Base virtual class to support the pages where Nominator and Nominee Details change
 *
 *	Test Class: bg_NominationDiversityExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 ****************************************************************/
public without sharing class bg_NominationDiversityExtension extends bg_NominationBaseExtension
{
	/* public property to get list options for the Disability picklist on the contact object
    */
    public List<SelectOption> disability
    {
   	 get
   	 {
   		 if(disability == null || disability.isEmpty())
   		 {
   			 disability = new List<selectOption>();
   			 disability.addAll(bg_SObjectUtils.getSelectOptionTypes(Contact.getSObjectType(), 'Disability__c'));
   		 }

   		 return disability;
   	 }
   	 set;
    }

	//Constructor
	public bg_NominationDiversityExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}

	/*
		Overwrite of default populate properties method
	*/
	protected override void populateProperties()
	{
		SaveNominee = true;
		SaveNominator = true;
	}
}