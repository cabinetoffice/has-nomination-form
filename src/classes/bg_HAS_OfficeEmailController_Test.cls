/*****************************************
*
* bg_HAS_OfficeEmailController_Test
*
* Test class for bg_HAS_OfficeEmailController
*
* Author: Lee Goodlad 
* Created: 10-02-2017
* Changes:
*
******************************************/
@IsTest
private class bg_HAS_OfficeEmailController_Test {
	private static Id sysAdminProfileId; 
    private static Id communityProfileId; 
    private static User testCommunityAdminUser; 
    private static User testCommunityUser;
    private static Contact communityContact;
    private static Contact nomineeContact;
    private static Account communityAccount;
	
	///
	//  Method used to setup test Data for below methods
	///
	private static void setUpData()
	{
		sysAdminProfileId = bg_UnitTestHelper.GetProfileIdByName('System Administrator');
        communityProfileId = bg_UnitTestHelper.GetProfileIdByName('Registered Nominator');
        testCommunityAdminUser = bg_UnitTestHelper.GetUser('Mr', 'Community', 'Admin', 'testadmin@test.com', sysAdminProfileId);
        
        System.runAs(testCommunityAdminUser)
        {
        	communityAccount = bg_UnitTestHelper.getAccount('Community User Account', testCommunityAdminUser.Id);
            nomineeContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Wilma', 'Flintstone', 'wilma.flintstone@test.com', testCommunityAdminUser.Id);
            communityContact = bg_UnitTestHelper.getContact(communityAccount.Id, 'Fred', 'Flintstone', 'fred.flintstone@test.com', testCommunityAdminUser.Id);
            testCommunityUser = bg_UnitTestHelper.GetCommunityUser('Mr', 'Fred', 'Flintstone', 'test@test.com', communityProfileId, communityContact.Id);
        }
	}

	///
	//	Method to ensure we can retrieve Nomination
	///
	private static testMethod void GetNominationTest()
	{
		if (null == sysAdminProfileId)
		{
			setUpData();
		}
        System.runAs(testCommunityUser)
        {
        	System.debug(System.LoggingLevel.Error, '### testCommunityUser : ' + testCommunityUser);
        	
        	//Create and insert a new Case
        	Case testCase = new Case(Nominee__c = nomineeContact.Id, Progress__c = 'Reviewing Nomination', ContactId = communityContact.Id);
        	insert testCase;

        	bg_HAS_OfficeEmailController emailTest = new bg_HAS_OfficeEmailController();
        	emailTest.NominationId = testCase.Id;
        	System.assertEquals(emailTest.getNomination().Id, testCase.Id);
    	}
	}

	///
	//	Method to ensure we can retrieve Nominator
	///
	private static testMethod void GetNominatorTest()
	{
		if (null == sysAdminProfileId)
		{
			setUpData();
		}
        System.runAs(testCommunityUser)
        {
        	System.debug(System.LoggingLevel.Error, '### testCommunityUser : ' + testCommunityUser);
        	
        	//Create and insert a new Case
        	Case testCase = new Case(Nominee__c = nomineeContact.Id, Progress__c = 'Reviewing Nomination', ContactId = communityContact.Id);
        	insert testCase;

        	bg_HAS_OfficeEmailController emailTest = new bg_HAS_OfficeEmailController();
        	emailTest.NominationId = testCase.Id;
        	Contact testCon = emailTest.getNominator();
        	System.assertEquals(testCon.Id, testCase.ContactId);
        	system.assertNotEquals(null, emailTest.Nominator);
    	}
	}

	///
	//	Method to ensure we can retrieve Nominee
	///
	private static testMethod void GetNomineeTest()
	{
		if (null == sysAdminProfileId)
		{
			setUpData();
		}
        System.runAs(testCommunityUser)
        {        	
        	//Create and insert a new Case
        	Case testCase = new Case(Nominee__c = nomineeContact.Id, Progress__c = 'Reviewing Nomination', ContactId = communityContact.Id);
        	insert testCase;
        	bg_HAS_OfficeEmailController emailTest = new bg_HAS_OfficeEmailController();
        	emailTest.NominationId = testCase.Id;
        	Contact testCon = emailTest.getNominee();
        	System.assertEquals(testCon.Id, testCase.Nominee__c);
        	System.assertNotEquals(null, emailTest.Nominee);

    	}
	}

	///
	//	Method to ensure we can retrieve records related to Nomination
	///
	private static testMethod void PopulateListsTest()
	{
		if (null == sysAdminProfileId)
		{
			setUpData();
		}
        System.runAs(testCommunityUser)
        {        	
        	//Create and insert a new Case
        	Case testCase = new Case(Nominee__c = nomineeContact.Id, Progress__c = 'Reviewing Nomination', ContactId = communityContact.Id);
        	insert testCase;
			
        	bg_HAS_OfficeEmailController emailTest = new bg_HAS_OfficeEmailController();
        	emailTest.NominationId = testCase.Id;
        	Case tstCon = emailTest.getNomination();
        	system.assertEquals(0, emailTest.LetterAttachments.Size());
        	Nomination_Attachment__c testLetter = new Nomination_Attachment__c(Name = 'test 1' ,Nomination__c =testCase.Id);
			insert testLetter;
			Nomination_Attachment__c testEvidience = new Nomination_Attachment__c(Name = 'test 1' ,Nomination__c =testCase.Id, Attachment_Type__c = 'Evidence');
			insert testEvidience;
        	emailTest.PopulateLists();
        	System.assertEquals(1, emailTest.LetterAttachments.Size());
        	System.assertEquals(1, emailTest.EvidenceAttachments.Size());
    	}
	}
}