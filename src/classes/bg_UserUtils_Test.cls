/********************************************************************
 * bg_UserUtils_Test
 *
 * Unit tests for bg_UserUtils
 * 
 * Author: Chris Eales - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 *
 ********************************************************************/
@IsTest
private class bg_UserUtils_Test 
{
	static testMethod void testgetUserById()
	{
		User result;
		Id userId;
		
		result = bg_UserUtils.getUserById(UserInfo.getUserId());
		system.assertEquals(UserInfo.getName(), result.Name);
		system.assertEquals(UserInfo.getProfileId(), result.ProfileId);
	}
	
	static testMethod void testgetUserByUsernameEmailNickname()
	{
		User result;
		User testUser;
		String username;
		String email;
		String nickname;
		
		testUser = bg_UserUtils.getUserById(UserInfo.getUserId());
		
		result = bg_UserUtils.getUserByUsernameEmailNickname(testUser.Username, testUser.Email, testUser.CommunityNickname);
		

		system.assertEquals(testUser.Name, result.Name);
		system.assertEquals(testUser.Id, result.Id);
		system.assertEquals(testUser.ProfileId, result.ProfileId);
	}
}