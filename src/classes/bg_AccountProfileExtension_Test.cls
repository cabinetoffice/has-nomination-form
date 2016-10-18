/********************************************************************
 * bg_AccountProfileExtension_Test 
 *
 * Test coverage for bg_AccountProfileExtension
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 20-04-2016
 * Changes: 
 * 	
 ********************************************************************/
 @isTest
public class bg_AccountProfileExtension_Test
{
	public static testMethod void successfullConstructorInitialsation()
	{
		Id sysAdminProfileId = bg_UnitTestHelper.GetProfileIdByName('System Administrator');
		Id communityProfileId = bg_UnitTestHelper.GetProfileIdByName('Registered Nominator');
		User testCommunityAdminUser = bg_UnitTestHelper.GetUser('Mr', 'Community', 'Admin', 'testadmin@test.com', sysAdminProfileId);
		User testCommunityUser;
		Account communityAccount;
		Contact communityContact;
		List<Case> newCases = new List<Case>();
		
		System.runAs(testCommunityAdminUser)
		{
			communityAccount = bg_UnitTestHelper.getAccount('Community User Account', testCommunityAdminUser.Id);
			communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Community', 'Testing', 'test@test.com', testCommunityAdminUser.Id);
			testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Community', 'Testing', 'test@test.com', communityProfileId, communityContact.Id);
		}

		System.runAs(testCommunityUser)
		{
			newCases.add(new Case(accountId = communityAccount.Id));
			newCases.add(new Case(accountId = communityAccount.Id));
			newCases.add(new Case(accountId = communityAccount.Id));
			insert newCases;

			Account emptyAccount = new Account();

			ApexPages.StandardController accountController = new ApexPages.StandardController(emptyAccount);
			bg_AccountProfileExtension extenstionController = new bg_AccountProfileExtension(accountController);

			System.assertEquals(extenstionController.thisAccount.Id, communityAccount.Id);
			System.assertEquals(extenstionController.submissions.size(), 3);
		}
	}
}