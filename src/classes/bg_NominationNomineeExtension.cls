/*****************************************************************
 *  Class: bg_NominationNomineeExtension
 *
 *  An extension of the Base virtual class to support the pages where Nominee Details change
 *
 *	Test Class: bg_NominationNomineeExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 ****************************************************************/
public class bg_NominationNomineeExtension extends bg_NominationBaseExtension
{
	/*
		public property to get list options for the Disability picklist on the contact object
 	*/

   /* ***** HANDLE TO CURRENT INSTANCE OF CONTROLLER (to be passed to rendered VF components, avoids re-instantiation of controller) ***** */
    public bg_NominationNomineeExtension NomExtCon { get { return this; } }
   public List<SelectOption> isBritish
   {
       get
       {
           if(isBritish == null || isBritish.isEmpty())
           {
               isBritish = new List<selectOption>();
               isBritish.addAll(bg_SObjectUtils.getSelectOptionTypes(Contact.getSObjectType(), 'is_British__c'));
           }

           return isBritish;
       }
       set;
   }

	//Constructor
	public bg_NominationNomineeExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}

	/*
		Overwrite of default populate properties method
	*/
	protected override void populateProperties()
	{
		SaveNominee = true;
		SaveNominator = false;

		readOnlyMode = Nomination.Progress__c == Label.HAS_Nomination_Completed_Status; 
	}
}