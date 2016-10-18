/*****************************************************************
 *  Class: bg_NominationCommonExtension_Test
 *
 *  Test Class for bg_NominationCommonExtension
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationCommonExtension_Test
{
    /*
        Test that a list of select options is returned by the property othersInPost on Page 13 of the form.
    */
    public static testMethod void populateSelectOptionList_test()
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
            Case testCase = new Case();
            Insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'HAS_FormPage12');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Other Awards/Recognition', 14, 'HAS_FormPage14');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Evidence Options', 15, 'HAS_FormPage15');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationCommonExtension commonExtension = new bg_NominationCommonExtension(caseController);

            // Set current page property
            commonExtension.CurrentPageName = 'has_formpage13';

            // If the property is being set correctly then we should have two values in the list (Yes and No)
            System.assert(!commonExtension.othersInPost.isEmpty());

        }
    }

    /*
        Method to test the previousPage method and if it returns a correct page
        reference if the custom settings are available
    */

    public static testMethod void returnPreviousPageRef_test()
    {

        //Create and insert a new Case
        Case testCase = new Case();

        // Create some page custom settings
        bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'HAS_FormPage12');
        bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');
        bg_UnitTestHelper.createHASPageRefSettings('Nominee Other Awards/Recognition', 14, 'HAS_FormPage14');
        bg_UnitTestHelper.createHASPageRefSettings('Nominee Evidence Options', 15, 'HAS_FormPage15');

        // Get a new instance of the baseExtension controller
        ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
		bg_NominationBaseExtension baseExtension = new bg_NominationBaseExtension(caseController);

        // Set current page property
        baseExtension.CurrentPageName = 'has_formpage13';

        // The correct previous page to our current page
        PageReference successPageRef = new PageReference('/HAS_FormPage12?previousStatus=Nominee+Impact+Statement');

        // The actual page reference returned from the method
        PageReference actualPageRef = baseExtension.previousPage();

        // Make sure the success and actual page refs are matching
        System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

    }
}