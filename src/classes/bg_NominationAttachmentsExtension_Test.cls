/*****************************************************************
 *  Class: bg_NominationAttachmentsExtension_Test
 *
 *  Test Class for bg_NominationAttachmentsExtension Extension generic extension class that supports the majority of Nomination VF Pages
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationAttachmentsExtension_Test
{

    /* Test whether a list of nomination attachments of the category 'Letters' is being returned on the apprpraite page */

    public static testMethod void populateAttachmentListwithExistingNominationAtt_Test()
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

            // Add posts for the testCase nomination
            Nomination_Attachment__c rec1 = bg_UnitTestHelper.createNominationAttachment('attachment1.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);
            Nomination_Attachment__c rec2 = bg_UnitTestHelper.createNominationAttachment('attachment2.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);

            // Set current page property and previous page property
			Pagereference HASAttachments = Page.HAS_FormPage19;

			Test.setCurrentPage(HASAttachments);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationAttachmentsExtension attachmentsExtension = new bg_NominationAttachmentsExtension(caseController);

            // Set current page property string
            attachmentsExtension.CurrentPageName = 'has_formpage19';
            attachmentsExtension.uploadPage = Label.HAS_Form_Upload_Letters_Page_Name; // We test with the Letters page

            // Set up the case
            attachmentsExtension.Nomination = testCase;
            testCase = attachmentsExtension.Nomination;

            // Check to see if the post records are present on the page
            List<Nomination_Attachment__c> nominationAttRecordCheck1 = [SELECT Name from Nomination_Attachment__c WHERE Nomination__c =: testCase.Id AND Name =: 'attachment1.jpg'];
            List<Nomination_Attachment__c> nominationAttRecordCheck2 = [SELECT Name from Nomination_Attachment__c WHERE Nomination__c =: testCase.Id AND Name =: 'attachment2.jpg'];


            System.assertEquals(2, attachmentsExtension.LetterAttachments.size());
            System.assertNotEquals(null,nominationAttRecordCheck1);
            System.assertNotEquals(null,nominationAttRecordCheck2);
        }
    }

    /*
        PTest that an empty list of posts is returned on posts page when a nomination without posts exists, and that we do not return a null.
    */
    public static testMethod void populateAttachmentListwithoutExistingNominationAtt_Test()
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

            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationAttachmentsExtension attachmentsExtension = new bg_NominationAttachmentsExtension(caseController);

            // Set current page property string
            attachmentsExtension.CurrentPageName = 'has_formpage19';
            attachmentsExtension.uploadPage = Label.HAS_Form_Upload_Letters_Page_Name; // We test with the Letters page

            // Set up the case
            attachmentsExtension.Nomination = testCase;
            testCase = attachmentsExtension.Nomination;

            System.assert(attachmentsExtension.LetterAttachments.isempty());
            System.assertEquals(0, attachmentsExtension.LetterAttachments.size());

        }
    }

    /* Test whether a list of nomination attachments of the category 'Letters' is being returned on the apprpraite page */

    public static testMethod void returnCategorySpecificAttachments()
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

            // Add posts for the testCase nomination
            Nomination_Attachment__c rec1 = bg_UnitTestHelper.createNominationAttachment('attachment1.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);
            Nomination_Attachment__c rec2 = bg_UnitTestHelper.createNominationAttachment('attachment2.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);
            Nomination_Attachment__c rec3 = bg_UnitTestHelper.createNominationAttachment('attachment3.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_EVIDENCE, testCase.Id);

            // Set current page property and previous page property
			Pagereference HASAttachments = Page.HAS_FormPage19;

			Test.setCurrentPage(HASAttachments);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationAttachmentsExtension attachmentsExtension = new bg_NominationAttachmentsExtension(caseController);

            // Set current page property string
            attachmentsExtension.CurrentPageName = 'has_formpage11';
            attachmentsExtension.uploadPage = Label.HAS_Form_Upload_Evidence_Page_Name; // We test with the Letters page

            // Set up the case
            attachmentsExtension.Nomination = testCase;
            testCase = attachmentsExtension.Nomination;

            // Only 1 out of the 3 inserted attachment records should be returned
            System.assertEquals(1, attachmentsExtension.EvidenceAttachments.size());
        }
    }

    /*
        Test that a letter attachment record can be deleted when the delete button is clicked
        against a record in the datatable on the VF page. The record that has
        been selected for deletion should be removed, a page reference should be
        returned and the list should no longer contain the deleted record.
    */

    public static testMethod void deleteLetterAttachmentMethod_Test()
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

            // Add posts for the testCase nomination
            Nomination_Attachment__c rec1 = bg_UnitTestHelper.createNominationAttachment('attachment1.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);
            Nomination_Attachment__c rec2 = bg_UnitTestHelper.createNominationAttachment('attachment2.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_EVIDENCE, testCase.Id);

            // Set current page property and previous page property
			Pagereference HASAttachments = Page.HAS_FormPage19;
            String testPreviousPage = 'has_formpage18';


			Test.setCurrentPage(HASAttachments);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationAttachmentsExtension attachmentsExtension = new bg_NominationAttachmentsExtension(caseController);

            // Set current page property string
            attachmentsExtension.CurrentPageName = 'has_formpage19';
            attachmentsExtension.uploadPage = Label.HAS_Form_Upload_Letters_Page_Name; // We test with the Evidence page

            // Set previous page name - this would normally be passed from an attribute
            attachmentsExtension.previousPageName = testPreviousPage;

            // Set up the case
            attachmentsExtension.Nomination = testCase;
            testCase = attachmentsExtension.Nomination;

            // Assert that we have a letter record present in our list before delete
            System.assertEquals(1,attachmentsExtension.LetterAttachments.size());

            /*
                populate the nominationAttachmentId property, as we would by clicking the link
                in the VF page
            */

            attachmentsExtension.nominationAttachmentId = rec1.Id;

            System.assertNotEquals(null,attachmentsExtension.Nomination.Id);

            /*
                Then we action the deleteRecord() method which should remove rec1
            */

            PageReference actualPageRef = attachmentsExtension.deleteAttachment();

            /*
                Check that the correct page reference is returned with all
                parameters required for returning to the correct page

            */

            // set the expected test pageRef value and assign it to a property.
            PageReference successPageRef = new PageReference('/' + bg_formUtils.FORM_PAGE19_NAME);
            successPageRef.getParameters().put('Id', testCase.Id);
            successPageRef.getParameters().put('retURL', testPreviousPage);

            // Test that the correct pageRef is being returned
            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

            List<Nomination_Attachment__c> testNominationAttList = bg_FormUtils.getNominationAttachments(testCase.Id, bg_FormUtils.NOMINATION_ATTACHMENT_LETTER);

            // Check that the Evidence attachment record has been deleted
            System.assertEquals(0,testNominationAttList.size());

        }
    }

    /*
        Test that an evidence attachment record can be deleted when the delete button is clicked
        against a record in the datatable on the VF page. The record that has
        been selected for deletion should be removed, a page reference should be
        returned and the list should no longer contain the deleted record.
    */

    public static testMethod void deleteEvidenceAttachmentMethod_Test()
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

            // Add posts for the testCase nomination
            Nomination_Attachment__c rec1 = bg_UnitTestHelper.createNominationAttachment('attachment1.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_EVIDENCE, testCase.Id);
            Nomination_Attachment__c rec2 = bg_UnitTestHelper.createNominationAttachment('attachment2.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);

            // Set current page property and previous page property
			Pagereference HASAttachments = Page.HAS_FormPage16;
            String testPreviousPage = 'has_formpage15';


			Test.setCurrentPage(HASAttachments);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationAttachmentsExtension attachmentsExtension = new bg_NominationAttachmentsExtension(caseController);

            // Set current page property string
            attachmentsExtension.CurrentPageName = 'has_formpage16';
            attachmentsExtension.uploadPage = Label.HAS_Form_Upload_Evidence_Page_Name; // We test with the Evidence page

            // Set previous page name - this would normally be passed from an attribute
            attachmentsExtension.previousPageName = testPreviousPage;

            // Set up the case
            attachmentsExtension.Nomination = testCase;
            testCase = attachmentsExtension.Nomination;

            // Assert that we have one record present in our list before delete
            System.assertEquals(1,attachmentsExtension.EvidenceAttachments.size());

            /*
                populate the nominationAttachmentId property, as we would by clicking the link
                in the VF page
            */

            attachmentsExtension.nominationAttachmentId = rec1.Id;

            System.assertNotEquals(null,attachmentsExtension.Nomination.Id);

            /*
                Then we action the deleteRecord() method which should remove rec1
            */

            PageReference actualPageRef = attachmentsExtension.deleteAttachment();

            /*
                Check that the correct page reference is returned with all
                parameters required for returning to the correct page
            */

            // set the expected test pageRef value and assign it to a property.

            PageReference successPageRef = new PageReference('/' + bg_formUtils.FORM_PAGE16_NAME);
            successPageRef.getParameters().put('Id', testCase.Id);
            successPageRef.getParameters().put('retURL', testPreviousPage);

            // Test that the correct pageRef is being returned
            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

            List<Nomination_Attachment__c> testNominationAttList = bg_FormUtils.getNominationAttachments(testCase.Id, bg_FormUtils.NOMINATION_ATTACHMENT_EVIDENCE);

            // Check that the Evidence attachment record has been deleted
            System.assertEquals(0,testNominationAttList.size());

        }
    }

    /*
        Test that the deleteAttachment() method will throw an exception and return
        a page message if there is problem with deleting a record
    */

    public static testMethod void deleteAttachmentMethodException_Test()
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

            // Add posts for the testCase nomination
            Nomination_Attachment__c rec1 = bg_UnitTestHelper.createNominationAttachment('attachment1.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);
            Nomination_Attachment__c rec2 = bg_UnitTestHelper.createNominationAttachment('attachment2.jpg',bg_FormUtils.NOMINATION_ATTACHMENT_LETTER, testCase.Id);

            // Set current page property and previous page property
			Pagereference HASAttachments = Page.HAS_FormPage19;
            String testPreviousPage = 'has_formpage18';


			Test.setCurrentPage(HASAttachments);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationAttachmentsExtension attachmentsExtension = new bg_NominationAttachmentsExtension(caseController);

            // Set current page property string
            attachmentsExtension.CurrentPageName = 'has_formpage19';
            attachmentsExtension.uploadPage = Label.HAS_Form_Upload_Letters_Page_Name; // We test with the Evidence page

            // Set previous page name - this would normally be passed from an attribute
            attachmentsExtension.previousPageName = testPreviousPage;

            // Set up the case
            attachmentsExtension.Nomination = testCase;
            testCase = attachmentsExtension.Nomination;

            // Assert that we have two records present in our list before delete
            System.assertEquals(2,attachmentsExtension.LetterAttachments.size());

            /*
                populate the nominationAttachmentId property, as we would by clicking the link
                in the VF page
            */

            attachmentsExtension.nominationAttachmentId = 'a024E000002KraCQAS';

            /*
                Then we action the deleteRecord() method which should remove rec1
            */

            PageReference actualPageRef = attachmentsExtension.deleteAttachment();

            /*
                Check that the correct page reference is returned with all
                parameters required for returning to the correct page

            */

            // set the expected test pageRef value and assign it to a property.

            PageReference successPageRef = new PageReference('/' + bg_formUtils.FORM_PAGE19_NAME);
            successPageRef.getParameters().put('Id', testCase.Id);
            successPageRef.getParameters().put('retURL', testPreviousPage);

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

            List<Nomination_Attachment__c> testNominationAttList = bg_FormUtils.getNominationAttachments(testCase.Id, bg_FormUtils.NOMINATION_ATTACHMENT_LETTER);

            System.assertEquals(2,testNominationAttList.size());

        }
    }

    /*
        Test to ensure that a page Reference is being returned if the previousPage() method is called
    */

    public static testMethod void returnPreviousPageRef_Test()
    {
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

                // Set current page property and previous page property
    			Pagereference HASAttachments = Page.HAS_FormPage19;
                String testPreviousPage = 'has_formpage18';

                // Set up parameters for the current page reference
    			Test.setCurrentPageReference(HASAttachments);
                System.currentPageReference().getParameters().put('Id', testCase.Id);
                System.currentPageReference().getParameters().put('retURL', testPreviousPage);

                // Get a new instance of the NominationPostExtension controller
                ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
                bg_NominationAttachmentsExtension attachmentsExtension = new bg_NominationAttachmentsExtension(caseController);

                // Set current page property string
                attachmentsExtension.CurrentPageName = 'has_formpage19';
                attachmentsExtension.uploadPage = Label.HAS_Form_Upload_Letters_Page_Name; // We test with the Evidence page

                // Set previous page name - this would normally be passed from an attribute
                attachmentsExtension.previousPageName = testPreviousPage;

                // Set up the case
                attachmentsExtension.Nomination = testCase;
                testCase = attachmentsExtension.Nomination;

                // set the expected test pageRef value and assign it to a property.

                PageReference successPageRef = new PageReference(bg_formUtils.FORM_PAGE18_NAME);
                successPageRef.getParameters().put('Id', testCase.Id);

                PageReference actualPageRef = attachmentsExtension.previousPage();

                System.assertNotEquals(null, actualPageRef.getUrl());
                System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

            }
        }
    }

}