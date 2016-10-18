/********************************************************************
 * bg_HAS_Nomination_List_Controller_TEST
 *
 * test code for bg_HAS_Nomination_List_Controller
 *
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 20-04-2016
 * Changes:
 *
 ********************************************************************/
 @isTest
 public class bg_HAS_Nomination_List_Controller_TEST
 {

    /*
        Test the redirectToNomination() method actioned by the Edit nomination button, this should not return null
    */

 	public static testMethod void testSuccessfullRedirect()
 	{
        // Set up property for the page as AccountPage
	 	Pagereference AccountPage = Page.HAS_Account_Profile;

        // Set the page as AccountPage
		Test.setCurrentPage(AccountPage);

		ApexPages.currentPage().getParameters().put('nominationId', 'acb1234567890');

		bg_HAS_Nomination_List_Controller controller = new bg_HAS_Nomination_List_Controller();

		PageReference resultPage = controller.redirectToNomination();

		System.assertNotEquals(null, resultPage);
		System.assertEquals('acb1234567890',resultPage.getParameters().get('Id'));
	}

    /*
        Test the redirectToCompletedNomination() method actioned by the Edit nomination button, this should not return null
    */

 	public static testMethod void testViewCompletedNomination()
 	{
        // Create and insert a new Case
        Case testCase = new Case();
        insert testCase;

        // Set up property for the page as AccountPage
	 	Pagereference AccountPage = Page.HAS_Account_Profile;

        // Set the page as AccountPage
		Test.setCurrentPage(AccountPage);

		bg_HAS_Nomination_List_Controller controller = new bg_HAS_Nomination_List_Controller();

        controller.nominationId = testCase.Id;
        testCase.Id = controller.nominationId;

        ApexPages.currentPage().getParameters().put('nominationId', controller.nominationId);

		PageReference resultPage = controller.redirectToCompletedNomination();

		System.assertNotEquals(null, resultPage);
		System.assertNotEquals(null, resultPage.getParameters().get('Id'));
	}
 }