/********************************************************************
 * bg_CaseUtils
 *
 * Utilities class for Case methods
 *
 *
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 11-04-2016
 * Changes:
 *	02/09/2016 CPE	Removed erroneous @Test Visible
 *	07/09/2016 NF 	Added CreateNewCase() to set up a new case records wth any required default values
 *
 ********************************************************************/
global class bg_CaseUtils
{

	/*
		Returns a list of Cases associated with the Account Passed in. If none are found, an empty list is returned
	*/
	public static List<Case> GetCasesForAccount(Account parentAccount)
	{
		List<Case> result = [
                            SELECT	Id, CaseNumber, Nominee_Name__c, Progress__c, Progress_Status__c, Number_of_Supports_Added__c
                            FROM	Case
                            WHERE	AccountId = :parentAccount.Id
                        	];
		return result;

	}

	/*
		Returns a new case record with any default values we require
	*/
	public static Case CreateNewCase()
	{
		Case newCase = New Case(
		Progress__c = bg_formUtils.HAS_DEFAULT_NOMINATION_STATUS,
		Origin = 'Web');

		return newCase;
	}

}