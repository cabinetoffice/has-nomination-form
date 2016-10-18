/*****************************************************************
 *  Class: bg_NominationBaseExtension_Test
 *
 *  Test Class for bg_NominationBaseExtension Base virtual class that supports the Nomination VF Pages
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationBaseExtension_Test
{

    /*
        Test populateNominee() to make sure a new contact is created if there is no Nominator contact found
    */

    public static testMethod void populateNomineeNewContact_Test()
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
            communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Community', 'Testing', 'test@test.com', testCommunityAdminUser.Id);
            testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Community', 'Testing', 'test@test.com', communityProfileId, communityContact.Id);
        }

        System.runAs(testCommunityUser)
        {

                // Create and insert a new Case
                Case testCase = new Case();

                // Get a new instance of the baseExtension controller
                ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
                bg_NominationBaseExtension baseExtension = new bg_NominationBaseExtension(caseController);

                System.assertNotEquals(baseExtension.Nominee, null);

            }


    }

    /*
        Test populateNominee() to make sure a new contact is not created if the nomination already has a nominee
    */

    public static testMethod void populateNomineeExistingContact_Test()
    {
        Id sysAdminProfileId = bg_UnitTestHelper.GetProfileIdByName('System Administrator');
        Id communityProfileId = bg_UnitTestHelper.GetProfileIdByName('Registered Nominator');
        User testCommunityAdminUser = bg_UnitTestHelper.GetUser('Mr', 'Community', 'Admin', 'testadmin@test.com', sysAdminProfileId);
        User testCommunityUser;
        Contact communityContact;
        Contact nomineeContact;
        Account communityAccount;

        System.runAs(testCommunityAdminUser)
        {
            communityAccount = bg_UnitTestHelper.getAccount('Community User Account', testCommunityAdminUser.Id);
            communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Community', 'Testing', 'test@test.com', testCommunityAdminUser.Id);
            nomineeContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Community', 'Testing', 'test@test.com', testCommunityAdminUser.Id);
            testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Community', 'Testing', 'test@test.com', communityProfileId, communityContact.Id);
        }

        System.runAs(testCommunityUser)
        {

                // Create and insert a new Case
                Case testCase = new Case(Nominee__c = nomineeContact.Id);
                Insert testCase;

                // Get a new instance of the baseExtension controller
                ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
                bg_NominationBaseExtension baseExtension = new bg_NominationBaseExtension(caseController);

                // Set up the case
                baseExtension.Nomination = testCase;
                testCase = baseExtension.Nomination;

                System.assertnotEquals(baseExtension.Nomination.Nominee__c, null);

            }
    }

    /*
        Test populateNominee() to make sure a new contact is not created if the nomination already has a nominee
    */

    public static testMethod void populateNominatorExisitingContact_Test()
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
            communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Community', 'Testing', 'test@test.com', testCommunityAdminUser.Id);
            testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Community', 'Testing', 'test@test.com', communityProfileId, communityContact.Id);
        }

        System.runAs(testCommunityUser)
        {
                // Create and insert a new Case
                Case testCase = new Case();

                // Get a new instance of the baseExtension controller
                ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
    			bg_NominationBaseExtension baseExtension = new bg_NominationBaseExtension(caseController);

                System.assertNotEquals(baseExtension.Nominator, null);

            }

    }

    /*
        Test populateNominator() to make sure a new contact is created if there is no Nominator contact found
    */

    public static testMethod void populateNominatorNewContact_Test()
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
            communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Community', 'Testing', 'test@test.com', testCommunityAdminUser.Id);
            testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Community', 'Testing', 'test@test.com', communityProfileId, communityContact.Id);
        }

                // Create and insert a new Case
                Case testCase = new Case();

                // Get a new instance of the baseExtension controller
                ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
    			bg_NominationBaseExtension baseExtension = new bg_NominationBaseExtension(caseController);

                // Set up the case
                baseExtension.Nomination = testCase;
                testCase = baseExtension.Nomination;


                System.assertNotEquals(baseExtension.Nominator, null);


    }

    /* Test to see if page reference settings are returned correctly from custom settings */

    public static testMethod void populatePageSettings_test()
    {

        //Create and insert a new Case
        Case testCase = new Case();

        // Create some page custom settings
        bg_UnitTestHelper.createHASPageRefSettings('Nominator Name', 1, 'HAS_FormPage1');
        bg_UnitTestHelper.createHASPageRefSettings('Nominator Address', 2, 'HAS_FormPage2');
        bg_UnitTestHelper.createHASPageRefSettings('Nominator Contact Details', 3, 'HAS_FormPage3');
        bg_UnitTestHelper.createHASPageRefSettings('Nominee Name', 4, 'HAS_FormPage4');

        // Get a new instance of the baseExtension controller
        ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
		bg_NominationBaseExtension baseExtension = new bg_NominationBaseExtension(caseController);

        // Set current page property
        baseExtension.CurrentPageName = 'has_formpage2';

        System.assertNotEquals(baseExtension.CurrentPageWrapper, null);

    }

    /*
        Test to determine is saveRecords() can successfully update a nominator's name
    */

    public static testMethod void saveRecords_test()
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

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominator Name', 1, 'HAS_FormPage1');
            bg_UnitTestHelper.createHASPageRefSettings('Nominator Address', 2, 'HAS_FormPage2');
            bg_UnitTestHelper.createHASPageRefSettings('Nominator Contact Details', 3, 'HAS_FormPage3');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Name', 4, 'HAS_FormPage4');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
    		bg_NominationBaseExtension baseExtension = new bg_NominationBaseExtension(caseController);

            // Set current page property
            baseExtension.CurrentPageName = 'has_formpage1';

            System.assertEquals(baseExtension.Nominator.firstName, 'Fred');

            baseExtension.Nominator.firstName = 'Barney';
            baseExtension.Nominator.lastName = 'Rubble';

            baseExtension.saveNominator = true;
            baseExtension.saveRecords();

            System.assertNotEquals(baseExtension.Nominator.firstName, 'Fred');

            List<Case> testAttachmentList = [SELECT Nominator__c from Case WHERE Nominator__c =: 'Barney Rubble'];


            System.assertNotEquals(1, testAttachmentList.size());

        }
    }

}