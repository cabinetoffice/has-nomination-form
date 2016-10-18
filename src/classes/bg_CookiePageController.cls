/********************************************************************
 * bg_CookiePageController 
 *
 * Controller class for HAS_CookiePage
 * 
 * Test Class: bg_CookiePageController_Test
 *
 * Author: Chris Eales - BrightGen Ltd
 * Created: 24-03-2014
 * Changes: 
 * 
 ********************************************************************/
public class bg_CookiePageController 
{
	public List<bg_CookieWrapper> CookiesHAS {get; set;}
	public List<bg_CookieWrapper> CookiesSFDC {get; set;}
	public bg_CookiePageController()
	{
		setupData();
	}
	
	
	/*
		Method to control the setup of controller properties
	*/
	private void setupData()
	{
		setupCookiesHAS();
		setupCookiesSFDC();
	}
	
	/*
		Instantiates the CookiesHAS wrapper collection
	*/
	private void setupCookiesHAS()
	{
		CookiesHAS = new List<bg_CookieWrapper>();
		CookiesHAS.add(getCookieWrapper(system.label.HAS_Cookies_Seen_Message_Label, system.label.HAS_Cookies_Seen_Message_Purpose, system.label.HAS_Cookies_Seen_Message_Expires)); 
	}
	
	/*
		Instantiates the CookiesSFDC wrapper collection
	*/
	private void setupCookiesSFDC()
	{
		CookiesSFDC = new List<bg_CookieWrapper>();
		CookiesSFDC.add(getCookieWrapper(system.label.HAS_Cookies_Salesforce_Required_Label, system.label.HAS_Cookies_Salesforce_Required_Text)); 
		CookiesSFDC.add(getCookieWrapper(system.label.HAS_Cookies_Salesforce_Performance_Label, system.label.HAS_Cookies_Salesforce_Performance_Text)); 
		CookiesSFDC.add(getCookieWrapper(system.label.HAS_Cookies_Salesforce_Functionality_Label, system.label.HAS_Cookies_Salesforce_Functionality_Text)); 
		CookiesSFDC.add(getCookieWrapper(system.label.HAS_Cookies_Salesforce_Advertising_Label, system.label.HAS_Cookies_Salesforce_Advertising_Text_1 + system.label.HAS_Cookies_Salesforce_Advertising_Text_2)); 
	}
	
	
	/*
		Cookie Name, Description and Expires Constructor
	*/
	
	private bg_CookieWrapper getCookieWrapper(String cookieName, String description)
	{
		bg_CookieWrapper cookieWrapper = new bg_CookieWrapper();
		cookieWrapper.CookieName = cookieName;
		cookieWrapper.Description = description;
		cookieWrapper.Expires = '';
		return cookieWrapper;
	}
	/*
		Cookie Name, Description and Expires Constructor
	*/
	private bg_CookieWrapper getCookieWrapper(String cookieName, String description, String expires)
	{
		bg_CookieWrapper cookieWrapper = new bg_CookieWrapper();
		cookieWrapper.CookieName = cookieName;
		cookieWrapper.Description = description;
		cookieWrapper.Expires = expires;
		return cookieWrapper;
		
	}	

}