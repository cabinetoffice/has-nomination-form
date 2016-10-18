/********************************************************************
 * bg_CookiePageController_Test
 *
 * Unit tests for bg_CookiePageController
 * 
 * Author: Chris Eales - BrightGen Ltd
 * Created: 24-03-2014
 * Changes: 
 *
 ********************************************************************/
@isTest
private class bg_CookiePageController_Test 
{
	static testMethod void testController()
	{
		bg_CookiePageController testController = new bg_CookiePageController();
		system.assertEquals(1, testController.CookiesHAS.size());
		system.assertEquals(system.label.HAS_Cookies_Seen_Message_Label, testController.CookiesHAS[0].CookieName);

		system.assertEquals(4, testController.CookiesSFDC.size());
		system.assertEquals(system.label.HAS_Cookies_Salesforce_Required_Label, testController.CookiesSFDC[0].CookieName);
		system.assertEquals(system.label.HAS_Cookies_Salesforce_Performance_Label, testController.CookiesSFDC[1].CookieName);
		system.assertEquals(system.label.HAS_Cookies_Salesforce_Functionality_Label, testController.CookiesSFDC[2].CookieName);
		system.assertEquals(system.label.HAS_Cookies_Salesforce_Advertising_Label, testController.CookiesSFDC[3].CookieName);
	}
}