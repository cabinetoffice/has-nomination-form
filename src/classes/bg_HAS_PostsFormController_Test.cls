/********************************************************************
 * bg_HAS_PostsFormController_Test
 *
 * Test class for bg_HAS_PostsFormController
 *
 *
 * Author: Nic Flook- BrightGen Ltd
 * Created: 23-09-2016
 * Changes:
 *
 ********************************************************************/
 @isTest
 public class bg_HAS_PostsFormController_Test
 {

	 /*
	 	This method tests whether a complete form's data can be
		successfully inserted into the database on saving when we are creating
		a new post record, which will be created with a Nomination_Id__c
		populated in the controller from a page parameter
	 */

	 public static testMethod void saveNewPost_test()
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
                // Create a new test case so that we can use the Id
                Case testCase = bg_UnitTestHelper.createCase();

                // Create a new test post
				Post__c post = new Post__c();

				// Create some page reference settings
				Pagereference HASPostsForm = Page.HAS_PostsForm;
                HASPostsForm.getParameters().put('submissionId',testCase.Id);
				HASPostsForm.getParameters().put('retURL','has_formpage11');

                Test.setCurrentPageReference(HASPostsForm);

				// Get a new instance of the HAS_PostsFormController
				bg_HAS_PostsFormController extController = new bg_HAS_PostsFormController(new ApexPages.StandardController(post));


				// Populate fields for the new post
				extController.post.Name = 'Writer';
				extController.post.Start_Date__c = '13/08/2001';
				extController.post.End_Date__c = '13/08/2002';
				extController.post.Position_Status__c = 'Unpaid';

				extController.savePost();

				List<Post__c> testSaveList = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id];

				System.assertEquals(1, testSaveList.size());
                System.assertNotEquals(null, extcontroller.savePost());

         }
     }

	 /*
	   This method tests whether a complete form's data can be
	   successfully upserted into the database on saving when we are editing an
	   existing record with one field changed
	 */

     public static testMethod void saveExisitingPost_test()
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
                // Create a new test case so that we can use the Id
                Case testCase = bg_UnitTestHelper.createCase();

                // Create a new test post
				Post__c post = bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','13/08/2016', testCase.Id);

				// Create some page reference settings
				Pagereference HASPostsForm = Page.HAS_PostsForm;
				HASPostsForm.getParameters().put('retURL','has_formpage11');

                Test.setCurrentPageReference(HASPostsForm);

				// Get a new instance of the HAS_PostsFormController
				bg_HAS_PostsFormController extController = new bg_HAS_PostsFormController(new ApexPages.StandardController(post));

                List<Post__c> testRecordRetrieved = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id AND Name =: 'Driving instructor'];
                System.assertEquals(1, testRecordRetrieved.size());

				// Change a field so we can check that the same record has been updated
                extController.post.End_Date__c = '13/08/2002';

				extController.savePost();

				List<Post__c> testRecordSaved = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id AND End_Date__c =: '13/08/2002'];

				System.assertEquals(1, testRecordSaved.size());
                System.assertNotEquals(null, extcontroller.savePost());

         }
     }

     /*
        Test to see if an existing post can be loaded for editing, make sure
        that the post form constructor returns the post identified by the url
        parameter.
     */

     public static testMethod void loadPostForEditing_test()
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
                // Create a new test case so that we can use the Id
                Case testCase = bg_UnitTestHelper.createCase();

                // Create a new test post
				Post__c post = bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','13/08/2016', testCase.Id);

				// Create some page reference settings
				Pagereference HASPostsForm = Page.HAS_PostsForm;
                HASPostsForm.getParameters().put('submissionId',testCase.Id);
        		HASPostsForm.getParameters().put('Id',post.Id);
                HASPostsForm.getParameters().put('retURL','has_formpage11');

                Test.setCurrentPageReference(HASPostsForm);

				// Get a new instance of the HAS_PostsFormController
				bg_HAS_PostsFormController extController = new bg_HAS_PostsFormController(new ApexPages.StandardController(post));

                List<Post__c> testRecordRetrieved = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id AND Name =: 'Driving instructor'];
                System.assertEquals(1, testRecordRetrieved.size());

                System.assertNotEquals(null, extController.post.Id);
                System.assertEquals('13/08/2016',extController.post.End_Date__c);

         }
     }

	 /*
	 	This method tests whether the Nominator will be sent to the appropriate
		page after a successful save operation. The test should return the
		page reference that matches the previous page in the url parameter
		whatever that may be.
	 */

     public static testMethod void saveNewPostReturnURl_test()
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
                // Create a new test case so that we can use the Id
                Case testCase = bg_UnitTestHelper.createCase();

                // Create a new test post
				Post__c post = new Post__c();

				// Create some page reference settings
				Pagereference HASPostsForm = Page.HAS_PostsForm;
                HASPostsForm.getParameters().put('submissionId',testCase.Id);
				HASPostsForm.getParameters().put('retURL','has_formpage11');

                Test.setCurrentPageReference(HASPostsForm);

				// Get a new instance of the HAS_PostsFormController
				bg_HAS_PostsFormController extController = new bg_HAS_PostsFormController(new ApexPages.StandardController(post));


				// Populate fields for the new post
				extController.post.Name = 'Writer';
				extController.post.Start_Date__c = '13/08/2001';
				extController.post.End_Date__c = '13/08/2002';
				extController.post.Position_Status__c = 'Unpaid';

                PageReference expectedPageRef = new pageReference('has_formpage11?Id=' + testCase.Id); // set the expected test pageRef value and assign it to a property.
                PageReference actualPageRef = extcontroller.savePost();

                System.assertEquals(expectedPageref.getUrl(), actualPageRef.getUrl());

         }
     }

	 /*
	 	This method tests whether the user will be sent to the appropriate page
		after cancelling post creation. The test should return the user the
		page reference that matches the previous page in the url parameter
		whatever that may be.
	 */

     public static testMethod void CancelPostReturnUrl_test()
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
                // Create a new test case so that we can use the Id
                Case testCase = bg_UnitTestHelper.createCase();

                // Create a new test post
				Post__c post = bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','13/08/2016', testCase.Id);

				// Create some page reference settings
				Pagereference HASPostsForm = Page.HAS_PostsForm;
                HASPostsForm.getParameters().put('submissionId',testCase.Id);
                HASPostsForm.getParameters().put('retURL','has_formpage11');

                Test.setCurrentPageReference(HASPostsForm);

				// Get a new instance of the HAS_PostsFormController
				bg_HAS_PostsFormController extController = new bg_HAS_PostsFormController(new ApexPages.StandardController(post));

                PageReference expectedPageRef = new pageReference('has_formpage11?Id=' + testCase.Id); // set the expected test pageRef value and assign it to a property.
                PageReference actualPageRef = extcontroller.cancelPost();

                System.assertEquals(expectedPageref.getUrl(), actualPageRef.getUrl());
         }
     }

     /*
        Make sure that the save method triggers appropriate errors if a post object is not available

     */

     public static testMethod void SaveRecordPostNull_test()
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
                // Create a new test case so that we can use the Id
                Case testCase = bg_UnitTestHelper.createCase();

                // Create a new test post
               Post__c post = new Post__c();

               // Create some page reference settings
               Pagereference HASPostsForm = Page.HAS_PostsForm;
               HASPostsForm.getParameters().put('submissionId',testCase.Id);
               HASPostsForm.getParameters().put('retURL','has_formpage11');

               Test.setCurrentPageReference(HASPostsForm);

               // Get a new instance of the HAS_PostsFormController
               bg_HAS_PostsFormController extController = new bg_HAS_PostsFormController(new ApexPages.StandardController(post));

               extController.post = null;

               testCase = extController.submission;
               extController.submission = testCase;

               PageReference actualPageRef = extcontroller.savePost();
               System.assertEquals(null, actualPageRef);

         }
     }

     /*
        This method tests whether an exception is thrown if the DML operation
        fails by using an incorrect record Id to trigger a fail.
    */

     public static testMethod void saveExisitingPostException_test()
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
                // Create a new test case so that we can use the Id
                Case testCase = bg_UnitTestHelper.createCase();

                // Create a new test post and another for a new Id
               Post__c post = bg_UnitTestHelper.createPost('Driving Instructor','13/08/2001','13/08/2016', testCase.Id);
               Post__c testpost = bg_UnitTestHelper.createPost('Karate Instructor','13/08/2005','13/08/2015', testCase.Id);

               // Create some page reference settings
               Pagereference HASPostsForm = Page.HAS_PostsForm;
               HASPostsForm.getParameters().put('retURL','has_formpage11');

                Test.setCurrentPageReference(HASPostsForm);

               // Get a new instance of the HAS_PostsFormController
               bg_HAS_PostsFormController extController = new bg_HAS_PostsFormController(new ApexPages.StandardController(post));

               List<Post__c> testRecordRetrieved = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id AND Name =: 'Driving instructor'];
               System.assertEquals(1, testRecordRetrieved.size());

               // Change a field so we can check that the same record has not been updated
               extController.post.End_Date__c = '13/08/2002';
               extController.post.Id = 'a044E0000029Idk';

               extController.savePost();

               List<Post__c> testRecordSaved = [SELECT Name, Start_Date__c, End_Date__c, Position_Status__c from Post__c WHERE Nomination_Id__c =: testCase.Id AND End_Date__c =: '13/08/2002'];

               System.assertEquals(0, testRecordSaved.size());
               System.assertNotEquals(null, extcontroller.savePost());

         }
     }


 }