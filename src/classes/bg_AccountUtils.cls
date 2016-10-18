/********************************************************************
 * bg_AccountUtils 
 *
 * Utilities class for Account methods
 * 
 * Test Class: bg_AccountUtils_Test
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 08-04-2016
 * Changes: 
 *
 *
 ********************************************************************/
global class bg_AccountUtils
{

	/*
		Returns the Account that the current Portal User is associated with.  If current user is not a portal user
		then a null Account record is returned
	*/
	@TestVisible
	public static Account GetAccountForCurrentUser()
	{
		User currentUser = bg_UserUtils.getUserById(UserInfo.getUserId());
		System.debug('##### currentUser: ' + currentUser);
		Account result;
		
		if ((currentUser != null) &&
			(currentUser.ContactId != null) &&
			(currentUser.Contact.AccountId != null))
		{
 			result = [
 				SELECT	Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, Type,
						LastModifiedDate, CreatedDate
 				FROM	Account
 				WHERE	Id = :currentUser.Contact.AccountId
 			];
		}
		System.debug('##### Result: ' + result);
		return result;
		
	}
}