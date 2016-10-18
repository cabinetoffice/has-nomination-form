/*****************************************************************
 *  Class: bg_NominationReviewExtension_Test
 *
 *  Test Class for bg_NominationReviewExtension
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationReviewExtension_Test
{
    /*
        Test to assert whter the correct Page Reference is returned after saving the page
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
            Case testCase = new Case(Nominee__c = nomineeContact.Id, Progress__c = 'Reviewing Nomination', ContactId = communityContact.Id);
            insert testCase;

            // Create some page custom settings
            bg_UnitTestHelper.createHASPageRefSettings('Equality Monitoring', 20, 'HAS_FormPage20');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 21, 'HAS_FormPage21');
            bg_UnitTestHelper.createHASPageRefSettings('Submitted', 22, 'HAS_FormPage22');

            // Get a new instance of the baseExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationReviewExtension reviewExtension = new bg_NominationReviewExtension(caseController);

            // Assign the case to the Nomination property
            reviewExtension.Nomination = testCase;
            testCase = reviewExtension.Nomination;

            // Set current page property
            reviewExtension.CurrentPageName = 'has_formpage21';

            PageReference successPageRef = new PageReference('/HAS_FormPage22');
            successPageRef.getParameters().put('Id', testCase.Id);

            PageReference actualPageRef = reviewExtension.saveRecords();

            // Assert that a PageReference has been returned and that it is the correct one
            System.assertNotEquals(null, actualPageRef);
            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

         }
    }
}