/********************************************************************
 * bg_UnitTestHelper
 *
 * Unit test helper class
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 13-04-2016
 * Changes:
 *
 ********************************************************************/
 @isTest
 public class bg_UnitTestHelper
 {
 	public static final String COMMUNITY_USER_PROFILE = 'Registered Nominator';
 	public static final String DEFAULT_USER_TIMEZONE = 'America/Los_Angeles';
 	public static final String DEFAULT_USER_LANGUAGE = 'en_US';
 	public static final String USER_ROLE = 'HAS Office';
    public static final String COMMUNITY_USER_ROLE = 'Manager';
    public static final String EMAIL_ENCODING_KEY = 'UTF-8';

	public static User GetUser(String title, String firstName, String lastName, String email, Id profileId)
    {
        User newUser = createUser(title, firstName, lastName, email, profileId);

        insert newUser;
        return newUser;
    }

    public static User createUser(String title, String firstName, String lastName, String email, Id profileId)
    {
        User newUser = new User();
        newUser.Title = title;
        newUser.FirstName = firstName;
        newUser.LastName = lastName;
        newUser.Username = System.now().millisecond() + email;
        newUser.Email = email;
        newUser.CommunityNickname = email;
        newUser.Alias = (firstName + lastName).left(8);
        newUser.ProfileId = profileId;
        newUser.LocaleSidKey = UserInfo.getLocale();
        newUser.TimeZoneSidKey = DEFAULT_USER_TIMEZONE;
        newUser.LanguageLocaleKey = DEFAULT_USER_LANGUAGE;
        newUser.EmailEncodingKey = EMAIL_ENCODING_KEY;
        newUser.UserRoleId = getUserRoleByName(USER_ROLE).Id;

        return newUser;
    }

    public static User GetCommunityUser(String title, String firstName, String lastName, String email, Id profileId, Id userContactId)
    {
        User newUser = createCommunityUser(title, firstName, lastName, email, profileId, userContactId);

        insert newUser;
        return newUser;
    }

    public static User createCommunityUser(String title, String firstName, String lastName, String email, Id profileId, Id userContactId)
    {
        User newUser = new User();

        newUser.Title = title;
        newUser.FirstName = firstName;
        newUser.LastName = lastName;
        newUser.Username = System.now().millisecond() + email;
        newUser.Email = email;
        newUser.CommunityNickname = email;
        newUser.Alias = (firstName + lastName).left(8);
        newUser.ProfileId = profileId;
        newUser.LocaleSidKey = UserInfo.getLocale();
        newUser.TimeZoneSidKey = DEFAULT_USER_TIMEZONE;
        newUser.LanguageLocaleKey = DEFAULT_USER_LANGUAGE;
        newUser.ContactId = userContactId;
        newUser.PortalRole = COMMUNITY_USER_ROLE;
        newUser.EmailEncodingKey = EMAIL_ENCODING_KEY;

        return newUser;
    }

    public static Id GetProfileIdByName(String profileName)
    {
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = :profileName Limit 1];

   		return testProfile.Id;
    }

    public static Contact getContact(Id accountId, String firstName, String lastName, String eMail, Id ownerId)
    {
        Contact testContact = createContact(accountId, firstName, lastName, eMail, ownerId);

        insert testContact;
        return testContact;
    }

    public static Contact createContact(Id accountId, String firstName, String lastName, String eMail, Id ownerId)
    {
        Contact testContact = new Contact();

        testContact.AccountId = accountId;
        testContact.FirstName = firstName;
        testContact.LastName = lastName;
        testContact.Email = eMail;
        testContact.OwnerId = ownerId;

        return testContact;
    }

    public static Account getAccount(String accountName, Id ownerId)
    {
        Account testAccount = createAccount(accountName, ownerId);

        insert testAccount;
        return testAccount;
    }

    public static Account createAccount(String accountName, Id ownerId)
    {
        Account testAccount = new Account();

        testAccount.Name = accountName;
        testAccount.OwnerId = ownerId;

        return testAccount;
    }

    public static UserRole getUserRoleByName(String roleName)
    {
        UserRole testRole = [SELECT Id from UserRole WHERE Name =: roleName];

        return testRole;
    }

    public static HASFormSettings__c createHASFormSettings(String settingName, Integer numberOfSupporters)
    {
        HASFormSettings__c newHASFormSetting = new HASFormSettings__c();
        newHASFormSetting.InitialNumberofSupporters__c = numberOfSupporters;
        newHASFormSetting.Name = settingName;

        insert newHASFormSetting;
        return newHASFormSetting;
    }


    /*
        Method to create custom settings records for form page names(aka status),
        the name of the vf page they correspond to and the order that they appear
        order in the form
    */
    public static HAS_Page_Reference__c createHASPageRefSettings(String settingName, Integer orderNumber, String vfPageName)
    {
        HAS_Page_Reference__c newHASPageRefSetting = new HAS_Page_Reference__c();
        newHASPageRefSetting.Name = settingName;
        newHASPageRefSetting.Order_in_Form__c = orderNumber;
        newHASPageRefSetting.Page_Name__c = vfPageName;

        insert newHASPageRefSetting;
        return newHASPageRefSetting;
    }

    public static Supporter__c getSupporter(String supporterName, Id caseId)
    {
        Supporter__c testSupporter = createSupporter(supporterName, caseId);
        insert testSupporter;
        return testSupporter;
    }

    public static Supporter__c createSupporter(String supporterName, Id caseId)
    {
        Supporter__c testSupporter = new Supporter__c();

        testSupporter.Nomination_Id__c = caseId;
        testSupporter.Name = supporterName;

        return testSupporter;
    }

    /*
        Method used for creating test attachment file records
    */

    public static Attachment getAttachment(Id attachToId, String attachmentName)
    {
        Attachment newAttachment = createAttachment(attachToId, attachmentName);

        insert newAttachment;
        return newAttachment;
    }
    public static Attachment createAttachment(Id attachToId, String attachmentName)
    {
        Attachment newAttachment = new Attachment();

        newAttachment.Name = attachmentName;
        newAttachment.ParentId = attachToId;
        newAttachment.Body = Blob.valueOf('abc123');

        return newAttachment;
    }

    /*
        Create a test case record
    */

    public static Case createCase()
    {
        Case testCase = new Case();
        testCase.Origin = 'Web'; // Require field on Case

        insert testCase;
        return testCase;
    }

    /*
        Create a test post record
    */
    public static Post__c createPost(String name, String startDate, String endDate, Id nominationId)
    {
        Post__c testPost = new Post__c();

        testPost.Name = name;
        testPost.Start_Date__c = startDate;
        testPost.End_Date__c = endDate;
        testPost.Position_Status__c = 'Unpaid';
        testPost.Nomination_Id__c = nominationId;

        insert testPost;
        return testPost;
    }

    /*
        Create a test supporter record
    */
    public static Supporter__c createSupporter(String supporterName, String knewFrom, String knewUntil, Id nominationId)
    {
        Supporter__c testSupporter = new Supporter__c();

        testSupporter.Name = supporterName;
        testSupporter.Knew_From__c = knewFrom;
        testSupporter.Knew_Until__c = knewUntil;
        testSupporter.Relationship__c = 'Friend';
        testSupporter.Nomination_Id__c = nominationId;

        insert testSupporter;
        return testSupporter;
    }

    /*
        Create a test nomination attachment record
    */
    public static Nomination_Attachment__c createNominationAttachment(String name, String attachmentType, Id nominationId)
    {
        Nomination_Attachment__c testNominationAtt = new Nomination_Attachment__c();

        testNominationAtt.Name = name;
        testNominationAtt.Attachment_Id__c = 'ABC1234567890XE';
        testNominationAtt.Attachment_Type__c = attachmentType;
        testNominationAtt.Nomination__c = nominationId;

        insert testNominationAtt;
        return testNominationAtt;
    }
}
