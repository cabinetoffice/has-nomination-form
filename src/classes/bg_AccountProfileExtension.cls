/********************************************************************
 * bg_AccountProfileExtension 
 *
 * Extenstion controller for HAS Account Profile Visualforce page
 * 
 * Test Class: bg_AccountProfileExtension_Test
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 08-04-2016
 * Changes: 
 * 	
 ********************************************************************/
public with sharing class bg_AccountProfileExtension
{
	public Account thisAccount {get; set;}
	public List<Case> submissions {get; set;}
	

	/* 
	  Returns a list of nominatin cases associated with the current logged in user's account
	*/
	
	public bg_AccountProfileExtension(ApexPages.StandardController stdController)
	{
		try
		{
			thisAccount = (Account)stdController.getRecord();
			
			if (thisAccount.Id == null)
			{
				thisAccount = bg_AccountUtils.getAccountForCurrentUser();
			}

			submissions = bg_CaseUtils.getCasesForAccount(thisAccount);

		}
		catch (Exception ex)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, ex.getMessage()));
		}
	}
	

}