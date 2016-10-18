/*****************************************************************
 *  Class: bg_NominationNominatorExtension_Test
 *
 *  Test Class for bg_NominationNominatorExtension
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationNominatorExtension_Test
{
    /*
        Test method to make sure our nominee and nominator save booleans
        correctly override the base extension class and save the data
        to the nomination record for only the nominator.
    */
    public static testMethod void saveNominatorValuesOnly_test()
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominator Address', 2, 'HAS_FormPage2');
            bg_UnitTestHelper.createHASPageRefSettings('Nominator Contact Details', 3, 'HAS_FormPage3');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Name', 4, 'HAS_FormPage4');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Address', 5, 'HAS_FormPage5');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationNominatorExtension nominatorExt = new bg_NominationNominatorExtension(caseController);

            // Assign the case to the Nomination property
            nominatorExt.Nomination = testCase;
            testCase = nominatorExt.Nomination;

            // Set current page property
            nominatorExt.CurrentPageName = 'has_formpage3';

            List<Contact> testNominatorEmail = [SELECT Id from Contact WHERE Email =: 'fred.flintstone@test.com'];
            List<Contact> testNomineeEmail = [SELECT Id from Contact WHERE Email =: 'wilma.flintstone@test.com'];

            System.assertEquals(1, testNominatorEmail.size());
            System.assertEquals(1, testNomineeEmail.size());

            // Set values for nominator and nominee emails
            nominatorExt.Nominator.Email = 'aNother.Nominator@email.com';
            nominatorExt.Nominee.Email = 'aNother.Nominee@email.com';

            nominatorExt.saveRecords();

            List<Contact> testNominatorEmailAs = [SELECT Id from Contact WHERE Email =: 'aNother.Nominator@email.com'];
            List<Contact> testNomineeEmailAs = [SELECT Id from Contact WHERE Email =: 'aNother.Nominee@email.com'];

            System.assertEquals(1, testNominatorEmailAs.size());
            System.assertEquals(0, testNomineeEmailAs.size());

        }
    }
}