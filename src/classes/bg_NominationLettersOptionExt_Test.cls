/*****************************************************************
 *  Class: bg_NominationLettersOptionExt_Test
 *
 *  Test Class for bg_NominationLettersOptionExtension extension class that supports the diversity options Page
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationLettersOptionExt_Test
{
    /*
        Test that a list of select options is returned by the property letterOptions on Page 18 of the form.
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Monitoring', 20, 'HAS_FormPage20');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 21, 'HAS_FormPage21');


            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationLettersOptionExtension lettersOptExtension = new bg_NominationLettersOptionExtension(caseController);

            // Set current page property
            lettersOptExtension.CurrentPageName = 'has_formpage18';

            // If the property is being set correctly then we should have two values in the list (Yes and No)
            System.assertEquals(2, lettersOptExtension.letterOptions.size());

        }
    }

    /*
        Test to determine is saveRecords() can successfully progress the
        user to the correct page and override the base save method if
        the user wants to upload attachments.
    */

    public static testMethod void saveOptionPositive_test()
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

            //Create and insert a new Case with the correct progress stage
            Case testCase = new Case(Progress__c = 'Nominee Supporter Letters Options');
            Insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Monitoring', 20, 'HAS_FormPage20');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 21, 'HAS_FormPage21');


            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationLettersOptionExtension lettersOptExtension = new bg_NominationLettersOptionExtension(caseController);

            // Set our testcase to be used as the nomination
            testCase = lettersOptExtension.Nomination;
            lettersOptExtension.Nomination = testCase;

            System.assertEquals(null, lettersOptExtension.Nomination.Letters_of_Support_Option__c);

            // Set current page property
            lettersOptExtension.CurrentPageName = 'has_formpage18';

            // Set the Evidence upload option to the positive selection
            lettersOptExtension.Nomination.Evidence_Option__c = 'Yes, I am ready to attach them';

            // Set a benchmark successPageRef for comparison to the actualPageRef
            PageReference successPageRef = new PageReference('/' + bg_formUtils.FORM_PAGE19_NAME);
            successPageRef.getParameters().put('Id', testCase.Id);
            successPageRef.getParameters().put('retURL', 'has_formpage18');

            // For this class we are testing the result of overriding saveRecords()
            PageReference actualPageRef = lettersOptExtension.saveRecords();

            // The PageReferences should be the same
            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }

    /*
        Test to determine if saveRecords() can successfully progress the user
        to the correct page and override the base save method if the user
        doesn't want to upload attachments.
    */

    public static testMethod void saveOptionNegative_test()
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

            //Create and insert a new Case with the correct progress stage
            Case testCase = new Case(Progress__c = 'Nominee Supporter Letters Options');
            Insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Monitoring', 20, 'HAS_FormPage20');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 21, 'HAS_FormPage21');


            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationLettersOptionExtension lettersOptExtension = new bg_NominationLettersOptionExtension(caseController);

            // Set our testcase to be used as the nomination
            testCase = lettersOptExtension.Nomination;
            lettersOptExtension.Nomination = testCase;

            System.assertEquals(null, lettersOptExtension.Nomination.Letters_of_Support_Option__c);

            // Set current page property
            lettersOptExtension.CurrentPageName = 'has_formpage18';

            // Set the Evidence upload option to the positive selection
            lettersOptExtension.Nomination.Letters_of_Support_Option__c = 'No, I will send them later';

            // Set a benchmark successPageRef for comparison to the actualPageRef - a string is being used here for case reasons
            PageReference successPageRef = new PageReference('/HAS_FormPage20');
            successPageRef.getParameters().put('Id', testCase.Id);

            // For this class we are testing the result of overriding saveRecords()
            PageReference actualPageRef = lettersOptExtension.saveRecords();

            // The PageReferences should be the same
            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }
}