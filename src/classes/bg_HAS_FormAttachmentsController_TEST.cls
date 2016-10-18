/********************************************************************
 * bg_HAS_FormAttachmentsController_TEST
 *
 *Test code for bg_HAS_FormAttachmentsController
 *
 *
 * Author: Nic Flook - BrightGen Ltd
 * Created: 09-09-2016
 * Changes:
 *
 ********************************************************************/
 @isTest
 public class bg_HAS_FormAttachmentsController_TEST
 {

     /*
        Test whether a Nomination Attachment record can be created successfully to parent an uploaed attachment file.
        A record should be created with an appropriate case/nomination Id and category.
     */
     public static testMethod void CreateNominationAttachmentRecord_test()
  	{
        // New instance of Attachment
  		Attachment testAttachment = new Attachment();

        // Set up an Account and User
  		Account testAccount = bg_UnitTestHelper.getAccount('testAccount', UserInfo.getUserId());

        // Create and insert a new Case
  		Case testCase = new Case(AccountId = testAccount.Id);
  		insert testCase;

        // Get a new instance of the attachment controller
  		bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

        // Set up the case Id
  		attachmentController.NominationId = testCase.Id;
  		testCase.Id = attachmentController.NominationId;

  		testAttachment = attachmentController.getNewAttachment();
  		attachmentController.NewAttachment.Name = 'Attachment1';
  		attachmentController.NewAttachment.Body = Blob.valueOf('abc123');
        attachmentController.attachmentCategory = bg_formUtils.NOMINATION_ATTACHMENT_EVIDENCE;

        Nomination_Attachment__c testNominationAttachmentRecord = attachmentController.CreateNominationAttachmentRecord();

        System.assertNotEquals(testNominationAttachmentRecord, null);
        System.assertEquals(testNominationAttachmentRecord.Nomination__c, testCase.Id);
        System.assertEquals(testNominationAttachmentRecord.Attachment_Type__c, attachmentController.attachmentCategory);

  	}

    public static testMethod void UploadAttachmentInvalidContentType_test()
   {
       // New instance of Attachment
       Attachment testAttachment = new Attachment();

       // Set up an Account and User
       Account testAccount = bg_UnitTestHelper.getAccount('testAccount', UserInfo.getUserId());

       // Create and insert a new Case
       Case testCase = new Case(AccountId = testAccount.Id);
       insert testCase;

       // Get a new instance of the attachment controller
       bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

       // Set up the case Id
       attachmentController.NominationId = testCase.Id;
       testCase.Id = attachmentController.NominationId;

       testAttachment = attachmentController.getNewAttachment();
       attachmentController.NewAttachment.Name = 'Attachment1';
       attachmentController.NewAttachment.Body = Blob.valueOf('abc123');
       attachmentController.contentType = 'invalid/app';
       attachmentController.attachmentCategory = bg_formUtils.NOMINATION_ATTACHMENT_EVIDENCE;

       PageReference uploadAttachment = attachmentController.uploadAttachment();

       System.assertNotEquals(attachmentController.goodFile, true);
       System.assertEquals(uploadAttachment, null);


   }

   public static testMethod void UploadAttachmentValidContentType_test()
  {
      // New instance of Attachment
      Attachment testAttachment = new Attachment();

      // Set up an Account and User
      Account testAccount = bg_UnitTestHelper.getAccount('testAccount', UserInfo.getUserId());

      // Create and insert a new Case
      Case testCase = new Case(AccountId = testAccount.Id);
      insert testCase;

      // Get a new instance of the attachment controller
      bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

      // Set up the case Id
      attachmentController.NominationId = testCase.Id;
      testCase.Id = attachmentController.NominationId;

      testAttachment = attachmentController.getNewAttachment();
      attachmentController.NewAttachment.Name = 'Attachment1';
      attachmentController.NewAttachment.Body = Blob.valueOf('abc123');
      attachmentController.contentType = 'application/pdf';
      attachmentController.attachmentCategory = bg_formUtils.NOMINATION_ATTACHMENT_EVIDENCE;

      PageReference uploadAttachment = attachmentController.uploadAttachment();

      System.assertEquals(attachmentController.goodFile, true);
      System.assertNotEquals(uploadAttachment, null);

  }

  // Test if an attachment record will be created if an attachmnet file has no name
  public static testMethod void UploadAttachmentEmptyName_test()
 {
     // New instance of Attachment
     Attachment testAttachment = new Attachment();

     // Set up an Account and User
     Account testAccount = bg_UnitTestHelper.getAccount('testAccount', UserInfo.getUserId());

     // Create and insert a new Case
     Case testCase = new Case(AccountId = testAccount.Id);
     insert testCase;

     // Get a new instance of the attachment controller
     bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

     // Set up the case Id
     attachmentController.NominationId = testCase.Id;
     testCase.Id = attachmentController.NominationId;

     testAttachment = attachmentController.getNewAttachment();
     attachmentController.NewAttachment.Name = '';
     attachmentController.NewAttachment.Body = Blob.valueOf('abc123');
     attachmentController.contentType = 'application/pdf';
     attachmentController.attachmentCategory = bg_formUtils.NOMINATION_ATTACHMENT_EVIDENCE;

     PageReference uploadAttachment = attachmentController.uploadAttachment();

     List<Nomination_Attachment__c> testAttachmentList = [SELECT Id from Nomination_Attachment__c WHERE Nomination__c =: testCase.Id];

     System.assertEquals(testAttachmentList.size(), 0);
     System.assertEquals(uploadAttachment, null);
 }

 // Test if an attachment record will be created if an attachmnet file has no name
 public static testMethod void UploadAttachmentCategoryLetter_test()
{
    // New instance of Attachment
    Attachment testAttachment = new Attachment();

    // Set up an Account and User
    Account testAccount = bg_UnitTestHelper.getAccount('testAccount', UserInfo.getUserId());

    // Create and insert a new Case
    Case testCase = new Case(AccountId = testAccount.Id);
    insert testCase;

    // Get a new instance of the attachment controller
    bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

    // Set up the case Id
    attachmentController.NominationId = testCase.Id;
    testCase.Id = attachmentController.NominationId;

    testAttachment = attachmentController.getNewAttachment();
    attachmentController.NewAttachment.Name = 'Name1';
    attachmentController.NewAttachment.Body = Blob.valueOf('abc123');
    attachmentController.contentType = 'application/pdf';
    attachmentController.attachmentCategory = bg_formUtils.NOMINATION_ATTACHMENT_LETTER;

    PageReference uploadAttachment = attachmentController.uploadAttachment();

    List<Nomination_Attachment__c> testAttachmentList = [SELECT Id, Attachment_Type__c from Nomination_Attachment__c WHERE Nomination__c =: testCase.Id AND Attachment_Type__c =: bg_formUtils.NOMINATION_ATTACHMENT_LETTER];

    System.assertEquals(testAttachmentList.size(), 1);
    System.assertNotEquals(attachmentController.nominationAttachmentId, null);
}





    /* public static testMethod void testUploadAttachmentWithGetters()
 	{
 		Attachment testAttachment = new Attachment();
 		List<String> stringList = new List<String>();

 		Account testAccount = bg_UnitTestHelper.getAccount('testAccount', UserInfo.getUserId());

 		Case testCase = new Case(AccountId = testAccount.Id);
 		insert testCase;

 		bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

 		attachmentController.submission = testCase;
 		testCase = attachmentController.submission;

 		testAttachment = attachmentController.getNewAttachment();
 		attachmentController.NewAttachment.Name = 'Attachment1';
 		attachmentController.NewAttachment.Body = Blob.valueOf('abc123');


 		stringList = attachmentController.savedAttachmentStringList;

 		attachmentController.uploadAttachment();

 		List<Attachment> foundAttachments = [SELECT Id FROM Attachment WHERE ParentId = : testCase.Id];

 		System.assertNotEquals(attachmentController.NewAttachment, null);
 		System.assertEquals(foundAttachments.size(), 1);
 		System.assertEquals(foundAttachments[0].Id, testAttachment.Id);

 	}

 	public static testMethod void testUploadAttachmentWithSetters()
 	{
 		Attachment testAttachment = new Attachment();
 		List<String> stringList = new List<String>();

 		Account testAccount = bg_UnitTestHelper.getAccount('testAccount', UserInfo.getUserId());

 		Case testCase = new Case(AccountId = testAccount.Id);
 		insert testCase;

 		bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

 		attachmentController.submission = testCase;
 		testCase = attachmentController.submission;

 		testAttachment.Name = 'Attachment1';
 		testAttachment.Body = Blob.valueOf('abc123');
 		testAttachment.ParentId = testCase.Id;

 		attachmentController.NewAttachment = attachmentController.setNewAttachment(testAttachment);

 		stringList = new List<String>{'String1', 'String2', 'String3'};

 		attachmentController.savedAttachmentStringList = null;
 		System.assertNotEquals(attachmentController.savedAttachmentStringList, null);
 		attachmentController.savedAttachmentStringList = stringList;

 		attachmentController.uploadAttachment();

 		List<Attachment> foundAttachments = [SELECT Id FROM Attachment WHERE ParentId = : testCase.Id];

 		System.assertNotEquals(attachmentController.NewAttachment, null);
 		System.assertEquals(foundAttachments.size(), 1);
 		System.assertEquals(foundAttachments[0].Id, testAttachment.Id);

 	}

 	public static testMethod void testFailedDMLUploadAttachment()
 	{
 		Attachment testAttachment = new Attachment();
 		List<String> stringList = new List<String>();

 		bg_HAS_FormAttachmentsController attachmentController = new bg_HAS_FormAttachmentsController();

 		testAttachment.Name = 'Attachment1';
 		testAttachment.Body = Blob.valueOf('abc123');
 		testAttachment.ParentId = '001000000000000';

 		attachmentController.NewAttachment = attachmentController.setNewAttachment(testAttachment);

 		attachmentController.uploadAttachment();

 		System.assertNotEquals(attachmentController.NewAttachment, null);
 		System.assertEquals(attachmentController.NewAttachment.Id, null);
 		System.assert(ApexPages.hasMessages());

 	} */
 }