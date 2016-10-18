/*****************************************************************
 *  Class: bg_NominationPostsExtension_Test
 *
 *  Test Class for bg_NominationPostsExtension
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_NominationPostsExtension_Test
{

    /*
        Populate the list of posts on the posts page when a nomination with posts exists
    */
    public static testMethod void populatePostListwithExistingPosts_Test()
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage1');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'HAS_FormPage2');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage3');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Other Awards/Recognition', 14, 'HAS_FormPage4');

            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Add posts for the testCase nomination
            bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','15/09/2016', testCase.Id);
            bg_UnitTestHelper.createPost('Haberdasher','13/08/2004','13/08/2016', testCase.Id);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;

            // Check to see if the post records are present on the page
            List<Post__c> postRecordCheck1 = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id AND End_Date__c =: '15/09/2016'];
            List<Post__c> postRecordCheck2 = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id AND End_Date__c =: '13/08/2016'];


            System.assertEquals(2, postsExtension.Posts.size());
            System.assertNotEquals(null,postRecordCheck1);
            System.assertNotEquals(null,postRecordCheck2);
        }
    }

    /*
        Test that an empty list of posts is returned on posts page when a nomination without posts exists, and that we do not return a null.
    */
    public static testMethod void populatePostListwithoutExistingPosts_Test()
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage1');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'HAS_FormPage2');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage3');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Other Awards/Recognition', 14, 'HAS_FormPage4');

            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;

            System.assert(postsExtension.Posts.isempty());
            System.assertEquals(0, postsExtension.Posts.size());

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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage11');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'has_formpage12');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');


            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Add posts for the testCase nomination
            bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','15/09/2016', testCase.Id);
            bg_UnitTestHelper.createPost('Haberdasher','13/08/2004','13/08/2016', testCase.Id);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;

            // Check we are returning a valid number of posts
            System.assertEquals(2, postsExtension.Posts.size());

            // Check the ValidData property returns true
            System.assertNotEquals(false,postsExtension.ValidData);

            /*
                Check that the correct sequential page reference is returned,
                a sign that a successful save has taken place and we can progress
            */
            PageReference successPageRef = new pageReference('/has_formpage12?Id=' + testCase.Id); // set the expected test pageRef value and assign it to a property.
            PageReference actualPageRef = postsExtension.saveRecords();

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }

    /*
        Check that the ValidData property is not being set if there are
        not enough Posts present and that the nomination record is saved
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage11');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'has_formpage12');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');


            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;

            // Check we are returning a valid number of posts
            System.assertEquals(0, postsExtension.Posts.size());

            // Check the ValidData property returns true
            System.assertEquals(false,postsExtension.ValidData);

            /*
                Check that the saveRecords() method returns an error with a
                useful page message and doesn't progress to the next step
            */

            PageReference PageRef = postsExtension.saveRecords();

            List<Apexpages.Message> msgs = ApexPages.getMessages();
            boolean b = false;
            for(Apexpages.Message msg:msgs){
                if (msg.getDetail().contains(Label.HAS_Minimum_Posts_Error)) b = true;
            }
            System.assert(b);

        }
    }

    // Test that the Add Supporter method will return a valid page reference with the correct parameters

    public static testMethod void addPostMethod_Test()
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
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage11');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'has_formpage12');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');


            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;


            /*
                Check that the correct sequential page reference is returned,
                a sign that a successful save has taken place and we can progress
            */
            PageReference successPageRef = Page.HAS_PostsForm;
            successPageRef.getParameters().put('submissionId', testCase.Id);
    		successPageRef.getParameters().put('retURL', postsExtension.CurrentPageName);

    		 // set the expected test pageRef value and assign it to a property.
            PageReference actualPageRef = postsExtension.openPostForm();

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }

    /*
        Test that the editRecord() method will return a valid page reference with the correct parameters
    */

    public static testMethod void editPostMethod_Test()
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

            // Add post for the testCase nomination
            Post__c testPost = bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','15/09/2016', testCase.Id);

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage11');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'has_formpage12');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');


            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;

            /*
                populate the postId property, as we would by clicking the link
                in the VF page
            */

            postsExtension.postId = testPost.Id;

            /*
                Check that the correct page reference is returned with all
                parameters required for editing a post record and returning to
                the correct page

            */
            PageReference successPageRef = Page.HAS_PostsForm;
            successPageRef.getParameters().put('submissionId', testCase.Id);
    		successPageRef.getParameters().put('retURL', postsExtension.CurrentPageName);
            successPageRef.getParameters().put('Id', postsExtension.postId);

    		 // set the expected test pageRef value and assign it to a property.
            PageReference actualPageRef = postsExtension.editRecord();

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

        }
    }

    /*
        Test that a post record can be deleted when the delete button is clicked
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

            // Add posts for the testCase nomination
            Post__c rec1 = bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','15/09/2016', testCase.Id);
            Post__c rec2 = bg_UnitTestHelper.createPost('Haberdasher','13/08/2004','13/08/2016', testCase.Id);

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage11');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'has_formpage12');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');

            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;

            // Assert that we have two records present in our list before delete
            System.assertEquals(2,postsExtension.Posts.size());

            /*
                populate the postId property, as we would by clicking the link
                in the VF page
            */

            postsExtension.postId = rec1.Id;

            /*
                Then we action the deleteRecord() method which should remove rec1
            */

            PageReference actualPageRef = postsExtension.deleteRecord();

            /*
                Check that the correct page reference is returned with all
                parameters required for editing a post record and returning to
                the correct page

            */

            // set the expected test pageRef value and assign it to a property.

            PageReference successPageRef = HASPosts;
            successPageRef.getParameters().put('Id', testCase.Id);

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());

            List<Post__c> testPostList = bg_FormUtils.getPosts(testCase.Id);

            System.assertEquals(1,testPostList.size());

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


            // Add posts for the testCase nomination
            Post__c rec1 = bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','15/09/2016', testCase.Id);
            Post__c rec2 = bg_UnitTestHelper.createPost('Haberdasher','13/08/2004','13/08/2016', testCase.Id);

            // Set test custom settings for page references
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Posts', 11, 'HAS_FormPage11');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Impact Statement', 12, 'has_formpage12');
            bg_UnitTestHelper.createHASPageRefSettings('Nominee Similar Service', 13, 'HAS_FormPage13');

            // Set current page property
			Pagereference HASPosts = Page.HAS_FormPage11;

			Test.setCurrentPage(HASPosts);

            // Get a new instance of the NominationPostExtension controller
            ApexPages.StandardController caseController = new ApexPages.StandardController(testCase);
            bg_NominationPostsExtension postsExtension = new bg_NominationPostsExtension(caseController);

            // Set current page property
            postsExtension.CurrentPageName = 'has_formpage11';

            // Set up the case
            postsExtension.Nomination = testCase;
            testCase = postsExtension.Nomination;

            // Assert that we have two records present in our list before delete
            System.assertEquals(2,postsExtension.Posts.size());

            /*
                populate the postId property, as we would by clicking the link
                in the VF page
            */

            postsExtension.postId = 'a024E000002KraCQAS';

            /*
                Then we action the deleteRecord() method which should remove rec1
            */

            PageReference actualPageRef = postsExtension.deleteRecord();

            /*
                Check that the correct page reference is returned with all
                parameters required for editing a post record and returning to
                the correct page

            */

            // set the expected test pageRef value and assign it to a property.

            PageReference successPageRef = HASPosts;
            successPageRef.getParameters().put('Id', testCase.Id);

            System.assertEquals(successPageRef.getUrl(), actualPageRef.getUrl());
            System.assertEquals(2,postsExtension.Posts.size());

        }
    }


}