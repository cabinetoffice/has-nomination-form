/********************************************************************
 * bg_CommunitiesSelfRegController_Test
 *
 * Unit tests for bg_CommunitiesSelfRegController
 * 
 * Author: Chris Eales - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 * 16-03-2015 CPE	Updated to take into account new Salutation field
 * 20-04-2016 N*F   Removed references to VAT field and associated tests 
                    as HAS does not use these.
 ********************************************************************/
@IsTest
private class bg_CommunitiesSelfRegController_Test 
{
    static testMethod void testController()
    {
    	User testUser = new User();
    	Apexpages.standardController stdController = new Apexpages.Standardcontroller(testUser);
    	
        bg_CommunitiesSelfRegController ctrl = new bg_CommunitiesSelfRegController(stdController);
        Test.setCurrentPage(Page.HAS_Create_Account);
             
        ctrl.newAccount.Type = 'Company';
        ctrl.newAccount.Name = 'Test Controller Name';
        ctrl.newAccount.OwnerId = UserInfo.getUserId();
        ctrl.newUser.FirstName = 'Testy';
        ctrl.newUser.LastName = 'McTester';
        ctrl.newUser.Email = 'test.Controller@testing.com';
        ctrl.newUser.Phone = '12345 67890';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        system.assert(ctrl.registerUser() == null);    

    }

    static testMethod void testControllerAccountErrorCoverage()
    {
    	User testUser = new User();
    	Apexpages.standardController stdController = new Apexpages.Standardcontroller(testUser);
        
        bg_CommunitiesSelfRegController ctrl = new bg_CommunitiesSelfRegController(stdController);
        Test.setCurrentPage(Page.HAS_Create_Account);
             
        ctrl.newAccount.Type = 'Company';
        ctrl.newAccount.Name = 'Test Controller Name';
        ctrl.newUser.Title = 'Mr';
        ctrl.newUser.FirstName = 'Testy';
        ctrl.newUser.LastName = 'McTester';
        ctrl.newUser.Email = 'test.Controller@testing.com';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        system.assertEquals(true, ctrl.registerUser() == null);    
		system.assertEquals(true, ApexPages.hasMessages());
    }


    static testMethod void testControllerAccountUserCreatedCodeCoverage()
    {
    	User testUser = new User();
    	Apexpages.standardController stdController = new Apexpages.Standardcontroller(testUser);
        
        bg_CommunitiesSelfRegController ctrl = new bg_CommunitiesSelfRegController(stdController);
        Test.setCurrentPage(Page.HAS_Create_Account);
        String title = 'Mr';
        String firstName = 'Testy';
        String lastName = 'McTester';
        String email = 'test.Controller@testing.com';

        ctrl.newAccount.Type = 'Company';
        ctrl.newAccount.Name = 'Test Controller Name';
        ctrl.newAccount.OwnerId = UserInfo.getUserId();
        ctrl.newUser.Title = title;
        ctrl.newUser.FirstName = firstName;
        ctrl.newUser.LastName = lastName;
        ctrl.newUser.Email = email;
        ctrl.newUser = bg_UnitTestHelper.getUser(title, firstName, lastName, email, UserInfo.getProfileId());
        
		PageReference returnPage;
		PageReference expectedPage;
		
		// site.createPortalUser does not work in test context so will always return null
		system.assertEquals(null, ctrl.registerUser());
		
		List<Account> newAccount = [SELECT	Id, Name
									FROM		Account
									WHERE		Name = 'Test Controller Name'
									LIMIT 1];
							  
		system.assertEquals(true, newAccount.isEmpty());
	}
	
}