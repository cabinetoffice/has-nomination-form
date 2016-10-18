/*****************************************************************
 *  Class: bg_NominationDiversityExtension_Test
 *
 *  Test Class for bg_NominationDiversityExtension
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationDiversityExtension_Test
{
    /*
        Test that a list of select options is returned by the property disability on Page 20 of the form.
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Monitoring', 20, 'HAS_FormPage20');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 21, 'HAS_FormPage21');
            bg_UnitTestHelper.createHASPageRefSettings('Submitted', 22, 'HAS_FormPage22');


            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationDiversityExtension diversityOptExtension = new bg_NominationDiversityExtension(caseController);

            // Set current page property
            diversityOptExtension.CurrentPageName = 'has_formpage20';

            // If the property is being set correctly it shouldn't be empty
            System.assert(!diversityOptExtension.disability.isEmpty());

        }
    }

    /*
        Test method to make sure our nominee and nominator save booleans
        correctly override the base extension class and save the data
        to the nomination record
    */
    public static testMethod void saveDiversityValues_test()
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
            nomineeContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Wilma', 'Flintstone', 'wilma.flintstone@test.com', testCommunityAdminUser.Id);
            communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Fred', 'Flintstone', 'fred.flintstone@test.com', testCommunityAdminUser.Id);
            testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Fred', 'Flintstone', 'test@test.com', communityProfileId, communityContact.Id);
        }

        System.runAs(testCommunityUser)
        {

            //Create and insert a new Case
            Case testCase = new Case(Nominee__c = nomineeContact.Id);
            insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Monitoring', 20, 'HAS_FormPage20');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 21, 'HAS_FormPage21');
            bg_UnitTestHelper.createHASPageRefSettings('Submitted', 22, 'HAS_FormPage22');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationDiversityExtension diversityOptExtension = new bg_NominationDiversityExtension(caseController);

            // Assign the case to the Nomination property
            diversityOptExtension.Nomination = testCase;
            testCase = diversityOptExtension.Nomination;

            // Set current page property
            diversityOptExtension.CurrentPageName = 'has_formpage20';

            // Set values for nominator and nominee diversity
            diversityOptExtension.Nominator.Disability__c = 'Yes';
            diversityOptExtension.Nominee.Ethnic_Origin_Group__c = 'Mixed ethnic background';
            diversityOptExtension.Nominee.Ethnic_Origin__c = 'Black African and white';

            List<Contact> testNominatorDisability = [SELECT Id from Contact WHERE Email =: 'fred.flintstone@test.com' AND Disability__c =: 'Yes'];
            List<Contact> testNomineeOrigin = [SELECT Id from Contact WHERE Email =: 'wilma.flintstone@test.com' AND Ethnic_Origin_Group__c =: 'Mixed ethnic background'];
            List<Contact> testNomineeOriginGroup = [SELECT Id from Contact WHERE Email =: 'wilma.flintstone@test.com' AND Ethnic_Origin__c = 'Black African and white'];

            System.assertNotEquals(1, testNominatordisability.size());
            System.assertNotEquals(1, testNomineeOrigin.size());
            System.assertNotEquals(1, testNomineeOriginGroup.size());

            diversityOptExtension.saveRecords();

            List<Contact> testNominatorDisabilityAs = [SELECT Id from Contact WHERE Email =: 'fred.flintstone@test.com' AND Disability__c =: 'Yes'];
            List<Contact> testNomineeOriginAs = [SELECT Id from Contact WHERE Email =: 'wilma.flintstone@test.com' AND Ethnic_Origin_Group__c =: 'Mixed ethnic background'];
            List<Contact> testNomineeOriginGroupAs = [SELECT Id from Contact WHERE Email =: 'wilma.flintstone@test.com' AND Ethnic_Origin__c = 'Black African and white'];

            System.assertEquals(1, testNominatorDisabilityAs.size());
            System.assertEquals(1, testNomineeOriginAs.size());
            System.assertEquals(1, testNomineeOriginGroupAS.size());

        }
    }

    /*
        Test that saving will return the page reference of the next page in the navigation
    */

    /*
        Test method to make sure our nominee and nominator save booleans
        correctly override the base extension class and save the data
        to the nomination record
    */
    public static testMethod void returnCorrectPagereference_test()
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
            nomineeContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Wilma', 'Flintstone', 'wilma.flintstone@test.com', testCommunityAdminUser.Id);
            communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Fred', 'Flintstone', 'fred.flintstone@test.com', testCommunityAdminUser.Id);
            testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Fred', 'Flintstone', 'test@test.com', communityProfileId, communityContact.Id);
        }

        System.runAs(testCommunityUser)
         {

            System.debug(System.LoggingLevel.Error, '### testCommunityUser : ' + testCommunityUser);
            //Create and insert a new Case
            Case testCase = new Case(Nominee__c = nomineeContact.Id,Progress__c = 'Equality Monitoring', ContactId = communityContact.Id);
            insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Monitoring', 20, 'HAS_FormPage20');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 21, 'HAS_FormPage21');
            bg_UnitTestHelper.createHASPageRefSettings('Submitted', 22, 'HAS_FormPage22');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationDiversityExtension diversityOptExtension = new bg_NominationDiversityExtension(caseController);

            // Assign the case to the Nomination property
            diversityOptExtension.Nomination = testCase;
            testCase = diversityOptExtension.Nomination;

            // Set current page property
            diversityOptExtension.CurrentPageName = 'has_formpage20';

            // Set values for nominator and nominee diversity
             diversityOptExtension.Nominator.Disability__c = 'Yes';
             diversityOptExtension.Nominee.Ethnic_Origin_Group__c = 'Mixed ethnic background';
             diversityOptExtension.Nominee.Ethnic_Origin__c = 'Black African and white';

            PageReference successPageRef = new PageReference('/HAS_FormPage21');
            successPageRef.getParameters().put('Id', testCase.Id);

            PageReference actualPageRef = diversityOptExtension.saveRecords();

            // Assert that a PageReference has been returned and that it is the correct one
            System.assertNotEquals(null, actualPageRef);
            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

         }
    }
}