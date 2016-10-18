/********************************************************************
 * bg_LoginController_Test
 *
 * Unit tests for bg_LoginController
 * 
 * Author: Chris Eales - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 *
 ********************************************************************/
@IsTest
private class bg_LoginController_Test 
{
	@IsTest(SeeAllData=true)
    static void testSiteLoginController ()
	{
		// Instantiate a new controller with all parameters in the page
		bg_LoginController controller = new bg_LoginController();
		controller.username = 'test@salesforce.com';
		controller.password = '123456'; 
                
        system.assertEquals(null, controller.login());                           
		
		PageReference expectedPage = Page.HAS_Create_Account;
		expectedPage.setRedirect(true);

		PageReference registerPage = controller.register();
		system.assertEquals(expectedPage.getURL(), registerPage.getURL());
		
    }
		
}