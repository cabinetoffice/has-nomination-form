/*****************************************************************
 *  Class: bg_NominationNomineeExtension_Test
 *
 *  Test Class for bg_NominationNomineeExtension
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationNomineeExtension_Test
{
    /*
        Test method to make sure our nominee and nominator save booleans
        correctly override the base extension class and save the data
        to the nomination record for only the nominator.
    */
    public static testMethod void saveNomineeValuesOnly_test()
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Address', 5, 'HAS_FormPage5');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Contact Details', 6, 'HAS_FormPage6');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee DoB or Age', 7, 'HAS_FormPage7');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Nationality', 8, 'HAS_FormPage8');


            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationNomineeExtension nomineeExt = new bg_NominationNomineeExtension(caseController);

            // Assign the case to the Nomination property
            nomineeExt.Nomination = testCase;
            testCase = nomineeExt.Nomination;

            // Set current page property
            nomineeExt.CurrentPageName = 'has_formpage6';

            List<Contact> testNomineeEmail = [SELECT Id from Contact WHERE Email =: 'wilma.flintstone@test.com'];
            List<Contact> testNominatorEmail = [SELECT Id from Contact WHERE Email =: 'fred.flintstone@test.com'];

            System.assertEquals(1, testNominatorEmail.size());
            System.assertEquals(1, testNomineeEmail.size());

            // Set values for nominator and nominee emails
            nomineeExt.Nominee.Email = 'aNother.Nominee@email.com';
            nomineeExt.Nominator.Email = 'aNother.Nominee@email.com';

            nomineeExt.saveRecords();

            List<Contact> testNomineeEmailAs = [SELECT Id from Contact WHERE Email =: 'aNother.Nominee@email.com'];
            List<Contact> testNominatorEmailAs = [SELECT Id from Contact WHERE Email =: 'aNother.Nominator@email.com'];

            System.assertEquals(1, testNomineeEmailAs.size());
            System.assertEquals(0, testNominatorEmailAs.size());

        }
    }

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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee DoB or Age', 7, 'HAS_FormPage7');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Nationality', 8, 'HAS_FormPage8');
            bg_UnitTestHelper.createHASPageRefSettings('Relationship to Nominee', 9, 'HAS_FormPage9');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Service', 10, 'HAS_FormPage10');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationNomineeExtension nomineeExt = new bg_NominationNomineeExtension(caseController);

            // Set current page property
            nomineeExt.CurrentPageName = 'has_formpage8';

            // If the property is being set correctly it shouldn't be empty
            System.assert(!nomineeExt.isBritish.isEmpty());

        }
    }
}