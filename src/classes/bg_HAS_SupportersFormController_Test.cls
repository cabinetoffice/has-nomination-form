/********************************************************************
 * bg_HAS_SupportersFormController_Test
 *
 * Test class for bg_HAS_SupportersFormController
 *
 *
 * Author: Nic Flook- BrightGen Ltd
 * Created: 23-09-2016
 * Changes:
 *
 ********************************************************************/
 @isTest
 public class bg_HAS_SupportersFormController_Test
 {

	 /*
	 	This method tests whether a complete form's data can be
		successfully inserted into the database on saving when we are creating
		a new supporter record, which will be created with a Nomination_Id__c
		populated in the controller from a page parameter
	 */

	 public static testMethod void saveNewSupporter_test()
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

                // Create a new test supporter
				Supporter__c supporter = new Supporter__c();

				// Create some page reference settings
				Pagereference HASsupportersForm = Page.HAS_SupportersForm;
                HASsupportersForm.getParameters().put('submissionId',testCase.Id);
				HASsupportersForm.getParameters().put('retURL','has_formpage11');

                Test.setCurrentPageReference(HASsupportersForm);

				// Get a new instance of the HAS_SupportersFormController
				bg_HAS_SupportersFormController extController = new bg_HAS_SupportersFormController(new ApexPages.StandardController(supporter));


				// Populate fields for the new supporter
				extController.supporter.Name = 'Chris Morris';
				extController.supporter.Knew_From__c = '13/08/2001';
				extController.supporter.Knew_Until__c = '13/08/2002';
				extController.supporter.Relationship__c = 'Friend';

				extController.saveSupporter();

				List<Supporter__c> testSaveList = [SELECT Name, Knew_From__c, Knew_Until__c, Relationship__c from Supporter__c WHERE Nomination_Id__c =: testCase.Id];

				System.assertEquals(1, testSaveList.size());
                System.assertNotEquals(null, extcontroller.saveSupporter());

         }
     }

	 /*
	   This method tests whether a complete form's data can be
	   successfully upserted into the database on saving when we are editing an
	   existing record with one field changed
	 */

     public static testMethod void saveExisitingSupporter_test()
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

                // Create a new test supporter
                List<Supporter__c> testSupporters = new List<Supporter__c>();
				testSupporters.add(bg_UnitTestHelper.createSupporter('Driving Instructor','13/08/2001','13/08/2016', testCase.Id));
                testSupporters.add(bg_UnitTestHelper.createSupporter('Detective','13/08/2001','13/08/2016', testCase.Id));
                insert testSupporters;

                Supporter__c supporter = testSupporters.get(0);

				// Create some page reference settings
				Pagereference HASSupportersForm = Page.HAS_SupportersForm;
				HASSupportersForm.getParameters().put('retURL','has_formpage17');

                Test.setCurrentPageReference(HASSupportersForm);

				// Get a new instance of the HAS_SupportersFormController
				bg_HAS_SupportersFormController extController = new bg_HAS_SupportersFormController(new ApexPages.StandardController(supporter));

                List<Supporter__c> testRecordRetrieved = [SELECT Name, Knew_From__c, Knew_Until__c, Relationship__c from Supporter__c WHERE Nomination_Id__c =: testCase.Id AND Name =: 'Driving instructor'];
                System.assertEquals(1, testRecordRetrieved.size());

				// Change a field so we can check that the same record has been updated
                extController.supporter.Knew_Until__c = '13/08/2002';

				extController.saveSupporter();

				List<Supporter__c> testRecordSaved = [SELECT Name, Knew_From__c, Knew_Until__c, Relationship__c from Supporter__c WHERE Nomination_Id__c =: testCase.Id AND Knew_Until__c =: '13/08/2002'];

				System.assertEquals(1, testRecordSaved.size());
                System.assertNotEquals(null, extcontroller.saveSupporter());

         }
     }

	 /*
	 	This method tests whether the Nominator will be sent to the appropriate
		page after a successful save operation. The test should return the
		page reference that matches the previous page in the url parameter
		whatever that may be.
	 */

     public static testMethod void saveNewSupporterReturnURl_test()
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

                // Create a new test supporter
				Supporter__c supporter = new Supporter__c();

				// Create some page reference settings
				Pagereference HASSupportersForm = Page.HAS_SupportersForm;
                HASSupportersForm.getParameters().put('submissionId',testCase.Id);
				HASSupportersForm.getParameters().put('retURL','has_formpage17');

                Test.setCurrentPageReference(HASSupportersForm);

				// Get a new instance of the HAS_SupportersFormController
				bg_HAS_SupportersFormController extController = new bg_HAS_SupportersFormController(new ApexPages.StandardController(supporter));


				// Populate fields for the new supporter
				extController.supporter.Name = 'Chris Morris';
				extController.supporter.Knew_From__c = '13/08/2001';
				extController.supporter.Knew_Until__c = '13/08/2002';
				extController.supporter.Relationship__c = 'Friend';

                PageReference expectedPageRef = new pageReference('has_formpage17?Id=' + testCase.Id); // set the expected test pageRef value and assign it to a property.
                PageReference actualPageRef = extcontroller.saveSupporter();

                System.assertEquals(expectedPageref.getUrl(), actualPageRef.getUrl());

         }
     }

	 /*
	 	This method tests whether the user will be sent to the appropriate page
		after cancelling supporter creation. The test should return the user the
		page reference that matches the previous page in the url parameter
		whatever that may be.
	 */

     public static testMethod void CancelSupporterReturnUrl_test()
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

                // Create a new test supporter
				List<Supporter__c> testSupporters = new List<Supporter__c>();
                testSupporters.add(bg_UnitTestHelper.createSupporter('Driving Instructor','13/08/2001','13/08/2016', testCase.Id));
                testSupporters.add(bg_UnitTestHelper.createSupporter('Detective','13/08/2001','13/08/2016', testCase.Id));
                insert testSupporters;
                
                Supporter__c supporter = testSupporters.get(0);

				// Create some page reference settings
				Pagereference HASSupportersForm = Page.HAS_SupportersForm;
                HASSupportersForm.getParameters().put('submissionId',testCase.Id);
                HASSupportersForm.getParameters().put('retURL','has_formpage17');

                Test.setCurrentPageReference(HASSupportersForm);

				// Get a new instance of the HAS_SupportersFormController
				bg_HAS_SupportersFormController extController = new bg_HAS_SupportersFormController(new ApexPages.StandardController(supporter));

                PageReference expectedPageRef = new pageReference('has_formpage17?Id=' + testCase.Id); // set the expected test pageRef value and assign it to a property.
                PageReference actualPageRef = extcontroller.cancelSupporter();

                System.assertEquals(expectedPageref.getUrl(), actualPageRef.getUrl());
         }
     }

     /*
        Make sure that the save method triggers appropriate errors if a supporter object is not available

     */

     public static testMethod void SaveRecordSupporterNull_test()
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

                // Create a new test supporter
               Supporter__c supporter = new Supporter__c();

               // Create some page reference settings
               Pagereference HASsupportersForm = Page.HAS_SupportersForm;
               HASSupportersForm.getParameters().put('submissionId',testCase.Id);
               HASSupportersForm.getParameters().put('retURL','has_formpage17');

               Test.setCurrentPageReference(HASSupportersForm);

               // Get a new instance of the HAS_SupportersFormController
               bg_HAS_SupportersFormController extController = new bg_HAS_SupportersFormController(new ApexPages.StandardController(supporter));

               extController.supporter = null;

               testCase = extController.submission;
               extController.submission = testCase;

               PageReference actualPageRef = extcontroller.saveSupporter();
               System.assertEquals(null, actualPageRef);

         }
     }

     /*
        This method tests whether an exception is thrown if the DML operation
        fails by using an incorrect record Id to trigger a fail.
	 */

     public static testMethod void saveExisitingSupporterException_test()
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

                // Create a new supporter
				List<Supporter__c> testSupporters = new List<Supporter__c>();
                testSupporters.add(bg_UnitTestHelper.createSupporter('Driving Instructor','13/08/2001','13/08/2016', testCase.Id));
                testSupporters.add(bg_UnitTestHelper.createSupporter('Detective','13/08/2001','13/08/2016', testCase.Id));
                insert testSupporters;
                
                Supporter__c supporter = testSupporters.get(0);

				// Create some page reference settings
				Pagereference HASSupportersForm = Page.HAS_SupportersForm;
				HASSupportersForm.getParameters().put('retURL','has_formpage17');

                Test.setCurrentPageReference(HASSupportersForm);

				// Get a new instance of the HAS_SupportersFormController
				bg_HAS_SupportersFormController extController = new bg_HAS_SupportersFormController(new ApexPages.StandardController(supporter));

                List<Supporter__c> testRecordRetrieved = [SELECT Name, Knew_From__c, Knew_Until__c, Relationship__c from Supporter__c WHERE Nomination_Id__c =: testCase.Id AND Name =: 'Driving Instructor'];
                System.assertEquals(1, testRecordRetrieved.size());

				// Change a field so we can check that the same record has been updated
                extController.supporter.Knew_Until__c = '13/08/2002';
                extController.supporter.Id = 'a004E00000D8hEF';

				PageReference result = extController.saveSupporter();

				List<Supporter__c> testRecordSaved = [SELECT Name, Knew_From__c, Knew_Until__c, Relationship__c from Supporter__c WHERE Nomination_Id__c =: testCase.Id AND Knew_Until__c =: '13/08/2002'];

				System.assertEquals(0, testRecordSaved.size());
                //System.assertEquals(result.getUrl(), extcontroller.saveSupporter().getUrl());

         }
     }
 }