@isTest
public class bg_AccountUtils_Test {

	public static testMethod void testGetAccountForCurrentUser()
	{
		Id sysAdminProfileId = bg_UnitTestHelper.GetProfileIdByName('System Administrator');
		Id communityProfileId = bg_UnitTestHelper.GetProfileIdByName('Registered Nominator');
		User testCommunityAdminUser = bg_UnitTestHelper.GetUser('Mr', 'Community', 'Admin', 'testadmin@test.com', sysAdminProfileId);
		User testCommunityUser;
		Contact communityContact;
		Account communityAccount;
		
		System.runAs(testCommunityAdminUser)
		{
			communityAccount = bg_UnitTestHelper.getAccount('Community User Account', testCommunityAdminUser.Id);
			communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Community', 'Testing', 'test@test.com', testCommunityAdminUser.Id);
			testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Community', 'Testing', 'test@test.com', communityProfileId, communityContact.Id);
		}


		System.runAs(testCommunityUser)
		{
			Account resultAccount = bg_AccountUtils.GetAccountForCurrentUser();
			system.assertEquals(communityAccount.Id, resultAccount.Id, 'Account returned should match Account inserted');
		}
	}
}