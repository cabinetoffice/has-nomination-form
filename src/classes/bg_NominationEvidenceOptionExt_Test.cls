/*****************************************************************
 *  Class: bg_NominationEvidenceOptionExt_Test
 *
 *  Test Class for bg_NominationEvidenceOptionExtension extension class that supports the diversity options Page
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationEvidenceOptionExt_Test
{
    /*
        Test that a list of select options is returned by the property evidenceOptions on Page 15 of the form.
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Other Awards/Recognition', 14, 'HAS_FormPage14');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Evidence Options', 15, 'HAS_FormPage15');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationEvidenceOptionExtension evidenceOptExtension = new bg_NominationEvidenceOptionExtension(caseController);

            // Set current page property
            evidenceOptExtension.CurrentPageName = 'has_formpage15';

            // If the property is being set correctly then we should have two values in the list (Yes and No)
            System.assertEquals(2, evidenceOptExtension.evidenceOptions.size());

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
            Case testCase = new Case(Progress__c = 'Nominee Evidence Options');
            Insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Other Awards/Recognition', 14, 'HAS_FormPage14');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Evidence Options', 15, 'HAS_FormPage15');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationEvidenceOptionExtension evidenceOptExtension = new bg_NominationEvidenceOptionExtension(caseController);

            // Set our testcase to be used as the nomination
            testCase = evidenceOptExtension.Nomination;
            evidenceOptExtension.Nomination = testCase;

            System.assertEquals(null, evidenceOptExtension.Nomination.Evidence_Option__c);

            // Set current page property
            evidenceOptExtension.CurrentPageName = 'has_formpage15';

            // Set the Evidence upload option to the positive selection
            evidenceOptExtension.Nomination.Evidence_Option__c = 'Yes, I am ready to attach them';

            // Set a benchmark successPageRef for comparison to the actualPageRef
            PageReference successPageRef = new PageReference('/' + bg_formUtils.FORM_PAGE16_NAME);
            successPageRef.getParameters().put('Id', testCase.Id);
            successPageRef.getParameters().put('retURL', 'has_formpage15');

            // For this class we are testing the result of overriding saveRecords()
            PageReference actualPageRef = evidenceOptExtension.saveRecords();

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
            Case testCase = new Case(Progress__c = 'Nominee Evidence Options');
            Insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Other Awards/Recognition', 14, 'HAS_FormPage14');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Evidence Options', 15, 'HAS_FormPage15');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationEvidenceOptionExtension evidenceOptExtension = new bg_NominationEvidenceOptionExtension(caseController);

            // Set our testcase to be used as the nomination
            testCase = evidenceOptExtension.Nomination;
            evidenceOptExtension.Nomination = testCase;

            System.assertEquals(null, evidenceOptExtension.Nomination.Evidence_Option__c);

            // Set current page property
            evidenceOptExtension.CurrentPageName = 'has_formpage15';

            // Set the Evidence upload option to the positive selection
            evidenceOptExtension.Nomination.Evidence_Option__c = 'No, I will send them later';

            // Set a benchmark successPageRef for comparison to the actualPageRef - a string is being used here for case reasons
            PageReference successPageRef = new PageReference('/HAS_FormPage17');
            successPageRef.getParameters().put('Id', testCase.Id);

            // For this class we are testing the result of overriding saveRecords()
            PageReference actualPageRef = evidenceOptExtension.saveRecords();

            // The PageReferences should be the same
            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }
}