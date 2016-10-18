/********************************************************************
 * bg_HAS_PageDispatcher
 *
 * Page dispatcher class to determine where a page request should redirect to for a new or current nomiantion.
 *
 *
 *
 * Author: Nic Flook - BrightGen Ltd
 * Created: 06-09-2016
 * Changes:
 *
 ********************************************************************/

@isTest
private class bg_HAS_PageDispatcher_Test
{
	/*
	   Test that the correct configuration settings are available
	   to direct users to pages and the correct page reference is
	   returned for the given nomination status
	*/

	public static testMethod void CheckConfigReturnsPageRef_test()
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
           communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Fred', 'Flintstone', 'test@test.com', testCommunityAdminUser.Id);
           testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Fred', 'Flintstone', 'test@test.com', communityProfileId, communityContact.Id);
       }

       System.runAs(testCommunityUser)
       {

           //Create and insert a new Case
           Case testCase = new Case(Progress__c = 'Nominee Nationality');
           Insert testCase;

           // Create some page custom settings
           bg_UnitTestHelper.createHASPageRefSettings('Nominee DoB or Age', 7, 'HAS_FormPage7');
           bg_UnitTestHelper.createHASPageRefSettings('Nominee Nationality', 8, 'HAS_FormPage8');
           bg_UnitTestHelper.createHASPageRefSettings('Relationship to Nominee', 9, 'HAS_FormPage9');
           bg_UnitTestHelper.createHASPageRefSettings('Nominee Service', 10, 'HAS_FormPage10');

		   // Create some page reference settings
		   Pagereference HASPageDispatcher = Page.HAS_PageDispatcher;

           // Set current page
           Test.setCurrentPageReference(HASPageDispatcher);

           // Get a new instance of the baseExtension controller
           ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
           bg_HAS_PageDispatcher hasDispatcher = new bg_HAS_PageDispatcher(caseController);

		   // set a test page reference that should be returned given the current status
		   PageReference successPageRef = new PageReference('/HAS_FormPage8');
		   successPageRef.getParameters().put('Id', testCase.Id);

		   // Return a pageReference using the redirect method in the controller
		   PageReference actualPageRef = hasDispatcher.Redirect();

		   // Assert that a PageReference has been returned and that it is the correct one
		   System.assertNotEquals(null, actualPageRef);
		   System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

		}
	}

	/*
   	Test that the destination page can be returned when the progress status is default.
   	In this case the nomination is new and so the first page in the form should be displayed
    */

    public static testMethod void CheckDefaultReturnsPageRef_Test()
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
	   		communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Fred', 'Flintstone', 'test@test.com', testCommunityAdminUser.Id);
	   		testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Fred', 'Flintstone', 'test@test.com', communityProfileId, communityContact.Id);
	   	}

	   	System.runAs(testCommunityUser)
	   	{

	   		// Create and insert a new Case
			Case testCase = new Case();

	   		// Create some page custom settings
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Name', 1, 'HAS_FormPage1');
			bg_UnitTestHelper.createHASPageRefSettings('Nominee DoB or Age', 7, 'HAS_FormPage7');
	   		bg_UnitTestHelper.createHASPageRefSettings('Nominee Nationality', 8, 'HAS_FormPage8');
	   		bg_UnitTestHelper.createHASPageRefSettings('Relationship to Nominee', 9, 'HAS_FormPage9');
	   		bg_UnitTestHelper.createHASPageRefSettings('Nominee Service', 10, 'HAS_FormPage10');

	   		// Create some page reference settings
	   		Pagereference HASPageDispatcher = Page.HAS_PageDispatcher;

	   		// Set current page
	   		Test.setCurrentPageReference(HASPageDispatcher);

	   		// Get a new instance of the baseExtension controller
	   		ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
	   		bg_HAS_PageDispatcher hasDispatcher = new bg_HAS_PageDispatcher(caseController);

	   		// set a test page reference that should be returned given the current status
	   		PageReference successPageRef = new PageReference('/HAS_FormPage1');

	   		// Return a pageReference using the redirect method in the controller
	   		PageReference actualPageRef = hasDispatcher.Redirect();

	   		// Assert that a PageReference has been returned and that it is the correct one
	   		System.assertNotEquals(null, actualPageRef);
	   		System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

	   	 }
   }

   /*
	  Test that the correct configuration settings error page message
	  is returned when settings are not available or misconfigured
   */

   	public static testMethod void CheckConfigurationSettingsError_test()
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
             communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Fred', 'Flintstone', 'test@test.com', testCommunityAdminUser.Id);
             testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Fred', 'Flintstone', 'test@test.com', communityProfileId, communityContact.Id);
         }

         System.runAs(testCommunityUser)
         {

             //Create and insert a new Case
             Case testCase = new Case(Progress__c = 'Invalid Test Status');
             Insert testCase;

             // Create some page custom settings
             bg_UnitTestHelper.createHASPageRefSettings('Nominee DoB or Age', 7, 'HAS_FormPage7');
             bg_UnitTestHelper.createHASPageRefSettings('Nominee Nationality', 8, 'HAS_FormPage8');
             bg_UnitTestHelper.createHASPageRefSettings('Relationship to Nominee', 9, 'HAS_FormPage9');
             bg_UnitTestHelper.createHASPageRefSettings('Nominee Service', 10, 'HAS_FormPage10');

  		   // Create some page reference settings
  		   Pagereference HASPageDispatcher = Page.HAS_PageDispatcher;

             // Set current page
             Test.setCurrentPageReference(HASPageDispatcher);

             // Get a new instance of the baseExtension controller
             ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
             bg_HAS_PageDispatcher hasDispatcher = new bg_HAS_PageDispatcher(caseController);

  		   	// Return a pageReference using the redirect method in the controller
  		   	PageReference actualPageRef = hasDispatcher.Redirect();

  		   	// Assert that a PageReference is not returned and that an error is displayed
  		   	System.assertEquals(null, actualPageRef);
		   	System.assert(hasDispatcher.ConfigurationError);
		   	System.assertEquals(System.Label.HAS_Page_Reference_Setting_Error,hasDispatcher.ConfigurationErrorMessage);

  		}
  	}



}