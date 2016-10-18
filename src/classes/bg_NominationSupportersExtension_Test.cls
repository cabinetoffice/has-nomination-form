/*****************************************************************
 *  Class: bg_NominationSupportersExtension_Test
 *
 *  Test Class for bg_NominationSupportersExtension
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationSupportersExtension_Test
{

    /*
        Populate the list of supporters on the supporters page when a nomination with supporters exists
    */
    public static testMethod void populateSupporterListwithExistingSupporters_Test()
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
            Insert testCase;

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');

            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Add Supporters for the testCase nomination
            bg_UnitTestHelper.getSupporter('Driving Instructor', testCase.Id);
            bg_UnitTestHelper.getSupporter('Haberdasher', testCase.Id);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'has_formpage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;

            // Check to see if the supporter records are present on the page
            List<Supporter__c> supporterRecordCheck1 = [SELECT Name, Knew_From__c, Knew_Until__c from Supporter__c WHERE Nomination_Id__c =: testCase.Id AND Knew_Until__c =: '15/09/2016'];
            List<Supporter__c> supporterRecordCheck2 = [SELECT Name, Knew_From__c, Knew_Until__c from Supporter__c WHERE Nomination_Id__c =: testCase.Id AND Knew_Until__c =: '13/08/2016'];


            System.assertEquals(2, supportersExtension.Supporters.size());
            System.assertNotEquals(null,supporterRecordCheck1);
            System.assertNotEquals(null,supporterRecordCheck2);
        }
    }

    /*
        PTest that an empty list of supporters is returned on supporters page when a nomination without supporters exists, and that we do not return a null.
    */
    public static testMethod void populateSupporterListwithoutExistingSupporters_Test()
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
            Insert testCase;

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');

            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'HAS_FormPage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;

            System.assert(supportersExtension.Supporters.isempty());
            System.assertEquals(0, supportersExtension.Supporters.size());

        }
    }

    /*
        Check that the ValidData property is being set and that the
        nomination record is saved successfully if this is set to True.
        If so the next pagereference should be returned by the save method
    */

    public static testMethod void CheckValidDataPropertyTrue_Test()
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
            Insert testCase;

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'has_formpage18'); // This should be checked - as the case should be irrelevant - NF
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');


            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Add supporters for the testCase nomination
            bg_UnitTestHelper.getSupporter('Driving Instructor', testCase.Id);
            bg_UnitTestHelper.getSupporter('Haberdasher', testCase.Id);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'HAS_FormPage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;

            // Check we are returning a valid number of supporters
            System.assertEquals(2, supportersExtension.Supporters.size());

            // Check the ValidData property returns true
            System.assertNotEquals(false,supportersExtension.ValidData);

            /*
                Check that the correct sequential page reference is returned,
                a sign that a successful save has taken place and we can progress
            */
            PageReference successPageRef = new pageReference('/has_formpage18?Id=' + testCase.Id); // set the expected test pageRef value and assign it to a property.
            PageReference actualPageRef = supportersExtension.saveRecords();

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }

    /*
        Check that the ValidData property is not being set if there are
        not enough Supporters present and that the nomination record is saved
        successfully if this is set to True. If so the next pagereference
        should be returned by the save method
    */

    public static testMethod void CheckValidDataPropertyFalse_Test()
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
            Insert testCase;

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');

            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'HAS_FormPage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;

            // Check we are returning a valid number of supporters
            System.assertEquals(0, supportersExtension.Supporters.size());

            // Check the ValidData property returns true
            System.assertEquals(false,supportersExtension.ValidData);

            /*
                Check that the saveRecords() method returns an error with a
                useful page message and doesn't progress to the next step
            */

            PageReference PageRef = supportersExtension.saveRecords();

            List<Apexpages.Message> msgs = ApexPages.getMessages();
            boolean b = false;
            for(Apexpages.Message msg:msgs){
                if (msg.getDetail().contains(Label.HAS_Minimum_Supporter_Error)) b = true;
            }
            System.assert(b);

        }
    }

    // Test that the Add Supporter method will return a valid page reference with the correct parameters

    public static testMethod void addSupporterMethod_Test()
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
            Insert testCase;

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');

            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'HAS_FormPage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;


            /*
                Check that the correct sequential page reference is returned,
                a sign that a successful save has taken place and we can progress
            */
            PageReference successPageRef = Page.HAS_SupportersForm;
            successPageRef.getParameters().put('submissionId', testCase.Id);
    		successPageRef.getParameters().put('retURL', supportersExtension.CurrentPageName);

    		 // set the expected test pageRef value and assign it to a property.
            PageReference actualPageRef = supportersExtension.openSupporterForm();

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }

    /*
        Test that the editRecord() method will return a valid page reference with the correct parameters
    */

    public static testMethod void editRecordMethod_Test()
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
            Insert testCase;

            // Add supporter for the testCase nomination
            Supporter__c testSupporter = bg_UnitTestHelper.getSupporter('Driving Instructor',testCase.Id);

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');

            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'HAS_FormPage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;

            /*
                populate the supporterId property, as we would by clicking the link
                in the VF page
            */

            supportersExtension.supporterId = testSupporter.Id;

            /*
                Check that the correct page reference is returned with all
                parameters required for editing a supporter record and returning to
                the correct page

            */
            PageReference successPageRef = Page.HAS_SupportersForm;
            successPageRef.getParameters().put('submissionId', testCase.Id);
    		successPageRef.getParameters().put('retURL', supportersExtension.CurrentPageName);
            successPageRef.getParameters().put('Id', supportersExtension.supporterId);

    		 // set the expected test pageRef value and assign it to a property.
            PageReference actualPageRef = supportersExtension.editSupporter();

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }

    /*
        Test that a supporter record can be deleted when the delete button is clicked
        against a record in the datatable on the VF page. The record that has
        been selected for deletion should be removed, a page reference should be
        returned and the list should no longer contain the deleted record.
    */

    public static testMethod void deleteRecordMethod_Test()
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
            Insert testCase;

            // Add supporters for the testCase nomination
            Supporter__c rec1 = bg_UnitTestHelper.getSupporter('Driving Instructor', testCase.Id);
            Supporter__c rec2 = bg_UnitTestHelper.getSupporter('Haberdasher', testCase.Id);

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');

            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'HAS_FormPage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;

            // Assert that we have two records present in our list before delete
            System.assertEquals(2,supportersExtension.Supporters.size());

            /*
                populate the supporterId property, as we would by clicking the link
                in the VF page
            */

            supportersExtension.supporterId = rec1.Id;

            /*
                Then we action the deleteRecord() method which should remove rec1
            */

            PageReference actualPageRef = supportersExtension.deleteSupporter();

            /*
                Check that the correct page reference is returned with all
                parameters required for editing a supporter record and returning to
                the correct page

            */

            // set the expected test pageRef value and assign it to a property.

            PageReference successPageRef = HASSupporters;
            successPageRef.getParameters().put('Id', testCase.Id);

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

            List<Supporter__c> testSupporterList = bg_FormUtils.getSupporters(testCase.Id);

            System.assertEquals(1,testSupporterList.size());

        }
    }

    /*
        Test that the deleteRecord() method will throw an exception and return
        a page message if there is problem with deleting a record
    */

    public static testMethod void deleteRecordMethodException_Test()
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
            Insert testCase;


            // Add supporters for the testCase nomination
            Supporter__c rec1 = bg_UnitTestHelper.getSupporter('Driving Instructor', testCase.Id);
            Supporter__c rec2 = bg_UnitTestHelper.getSupporter('Haberdasher', testCase.Id);

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporters', 17, 'HAS_FormPage17');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Supporter Letters Options', 18, 'HAS_FormPage18');
            bg_UnitTestHelper.createHASPageRefSettings('Equality Montoring', 19, 'HAS_FormPage19');
            bg_UnitTestHelper.createHASPageRefSettings('Reviewing Nomination', 20, 'HAS_FormPage20');

            // Set current page property
			Pagereference HASSupporters = Page.HAS_FormPage17;

			Test.setCurrentPage(HASSupporters);

            // Get a new instance of the NominationSupporterExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationSupportersExtension supportersExtension = new bg_NominationSupportersExtension(caseController);

            // Set current page property
            supportersExtension.CurrentPageName = 'HAS_FormPage17';

            // Set up the case
            supportersExtension.Nomination = testCase;
            testCase = supportersExtension.Nomination;

            // Assert that we have two records present in our list before delete
            System.assertEquals(2,supportersExtension.Supporters.size());

            /*
                populate the supporterId property, as we would by clicking the link
                in the VF page
            */

            supportersExtension.supporterId = 'a024E000002KraCQAS';

            /*
                Then we action the deleteRecord() method which should remove rec1
            */

            PageReference actualPageRef = supportersExtension.deleteSupporter();

            /*
                Check that the correct page reference is returned with all
                parameters required for editing a supporter record and returning to
                the correct page

            */

            // set the expected test pageRef value and assign it to a property.

            PageReference successPageRef = HASSupporters;
            successPageRef.getParameters().put('Id', testCase.Id);

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());
            System.assertEquals(2,supportersExtension.Supporters.size());

        }
    }


}