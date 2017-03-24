/*****************************************************************
 *  Class: bg_NominationBaseExtension
 *
 *  Base virtual class to support the Nomination VF Pages - A generic extension to this class supports
 *  the majority of the Nomination Pages and various other extension classes support the pages
 *  where specific functionality is required - such has Attachment Options Pages
 *
 *  Test Class: bg_NominationBaseExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *  02/09/2016  NF  Initally created as part of the HAS changes as a replacement to bg_NominationFormController
 *                  to allow for custom settings to be used to drive the flow through the pages
 *	06/09/2016	CPE	Introduces CurrentPageName parameter to support controlling the pages based on pagename
 *					not case status
 *  07/09/2016  NF  Added a call to a new util method for populating case defaults
 *  16/09/2016  NF  Added ValidData boolean which can be overidden in extensions for supporters and posts to ensure the required number have been added.
 *                  Invalid entries will display and appropriate error for the page.
 *  26/01/2017  LG  CN27342 - 
 ****************************************************************/
public without sharing virtual class bg_NominationBaseExtension
{
    public Case Nomination { get; set; } // The Nomination Case Record
    public Contact Nominee { get; set; } // The Nominee Conact Record
    public static final String OTHER_SELECTION = 'Other';
    public Contact Nominator { get; set; } // The Nominator Contact Record
    public Boolean ConfigurationError { get; set; } // Indicates there is a Configuration Error - this should display an error to the user
    public String ConfigurationErrorMessage { get; set; } // The error to display if ConfigurationError is set to true
    public String CurrentPageName //Current Name of page being displayed - added via the template
    {
    	get
    	{
    		return CurrentPageName;
    	}
    	set
    	{
    		CurrentPageName = value.toLowerCase();
    		populatePageSettings();
    	}
	}
    // List Wrapper for displaying nationality options
    public List<NationalityWrapper> nationalities 
    {
        get
        {
            return nationalities;
        }
        set;
    }
    public Integer countryName {get; set;}
    public Boolean readOnlyMode { get; set; } // NF We may dispense with this after reviewing the review and edit page
    public Boolean SaveNominee = false;
    public Boolean SaveNominator = false;
    public Boolean ValidData = true;
    public boolean isBritishSelected {get; set;}
    public boolean isOtherSelected {get; set;}
    public bg_PageSettingWrapper CurrentPageWrapper { get; set; }
    private static Map<String, bg_PageSettingWrapper> PageWrappers; //GetPageReferenceSettingsByProgressStatus()

    /* ***** HANDLE TO CURRENT INSTANCE OF CONTROLLER (to be passed to rendered VF components, avoids re-instantiation of controller) ***** */
    public bg_NominationBaseExtension ExtCon { get { return this; } }

    /*
        Constructor method for the Controllers
    */
    public bg_NominationBaseExtension(Apexpages.StandardController stdController)
    {
        //Set default property values
        ConfigurationError = false;
        ConfigurationErrorMessage = '';
        countryName = 0;
        // Add default fields required that may not be referenced on the VF Page
        if (!test.isRunningTest())
        {
            stdController.addFields(bg_formUtils.CASE_FORM_FIELDS);
        }
        nationalities = new List<NationalityWrapper>();
        Nomination = (Case)stdController.getRecord();
        if (Nomination.id == null)
        {
            // calls a utility to create a default Case record with required fields set.
            Nomination = bg_CaseUtils.CreateNewCase();

        }
        populateNominee();
        populateNominator();
        populateProperties();
    }


    /*
        Method to populate the nominee property.  This will either be a new Contact record, if this is a new nomination or be the associated Contact for existing nominations
    */
    private void populateNominee()
    {
        if ((nomination.Id == null) ||
            (Nomination.Nominee__c == null))
        {
            Nominee = new Contact();
            //nationalities = new List<String>();
            isBritishSelected = false;
            isOtherSelected = false;
        }
        else
        {
            Nominee = bg_FormUtils.getNominee(Nomination.Nominee__c);
            isBritishSelected = Nominee.Is_British__c != OTHER_SELECTION;
            
            // display any pre-selected nationalities
            if(Nominee.Nationalities__c != null)
            {
                Integer startIndex = nationalities.Size();
                for (String s : Nominee.Nationalities__c.split(','))
                {
                    nationalities.add(new NationalityWrapper(startindex, s));
                    startIndex++;
                }
            }
            else
            {
                nationalities = new List<NationalityWrapper>();
            }
            isOtherSelected = nationalities.Size() > 0;
            System.debug(System.LoggingLevel.error,'### enter populateNominee() = ' + Nominee);
        }
    }

    /*
        Method to populate the nominator property - This is the Contact record associated with the logged in Portal user
    */
    private void populateNominator()
    {
        // call to utility method to obtain the contact record from the current logged in user
        User currentUser = bg_UserUtils.getUserById(UserInfo.getUserId());
        if (currentUser.ContactId != null)
        {
        	Nominator = bg_FormUtils.getNominator(currentUser.ContactId);
        }

        if ((Nominator == null) ||
        	(Nominator.Id == null))
        {
            Nominator = new Contact();
        }
    }

    /*
        Method to populate the bg_PageSettingWrapper properties.  The currentPageWrapper property is determined from the Case.Progress__c value
        unless previousStatus parameter is present in the URL - when this is the case this value overrides the
        current case status.  The Previous action adds this parameter to the URL and is removed by bg_formUtils.GetRedirectionPage()
    */
    protected virtual void populatePageSettings()
    {
        PageWrappers = bg_customSettingsUtils.GetPageReferenceSettingsByPageName();
        if (PageWrappers.containsKey(CurrentPageName))
        {
            CurrentPageWrapper = PageWrappers.get(CurrentPageName);
        }
        else
        {
            //This indicates there is a mismatch in the custom settings and therefore we need to display an error
            ConfigurationError = true;
            ConfigurationErrorMessage = Label.HAS_Page_Reference_Setting_Error;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ConfigurationErrorMessage + ' - ' + 'CurrentPage: ' + CurrentPageName));
        }
    }


    /*
        Overrideable method to populate additional properties within the extension controllers
    */
    protected virtual void populateProperties()
    {
        SaveNominee = false;
        SaveNominator = false;
        ValidData = true;
        readOnlyMode = Nomination.Progress__c == Label.HAS_Nomination_Completed_Status;
    }

    /*
        Overrideable method to save the nomination and nominee records.
        This method returns the PageReference associated with the next page defined within the
        HAS Page Reference Custom Setting Wrapper
    */
    public virtual PageReference saveRecords()
    {
        PageReference returnPage;
        Boolean saveSuccess = true;  //Assume success

        // Implement upsert Save code here
        Database.UpsertResult nomineeResult;
        Database.UpsertResult nominatorResult;

        //Set a setpoint so we can rollback if anything fails
        System.Savepoint sp = Database.setSavepoint();

        if (SaveNominee)
        {
            String updatednationalities = '';
            // LG Added to update Nominee's nationalities 

            for (NationalityWrapper nw : nationalities)
            {
                updatednationalities += nw.NationalityLabel + ',';
            }
            Nominee.Nationalities__c = updatednationalities.removeEnd(',');
            system.debug(LoggingLevel.ERROR,'*** LG *** updatednationalities: ' + updatednationalities);
            if (isOtherSelected && updatednationalities.length() < 2)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.Has_Other_Nationality_Error));
                return null;
            }
            else 
            {
                System.debug(System.LoggingLevel.error,'### Save Nominee'+Nominee);
                nomineeResult = Database.upsert(Nominee, false);
                saveSuccess = bg_formUtils.EvaluateUpsertResult(nomineeResult);
                if ((saveSuccess) &&
                    (Nomination.Nominee__c == null))
                {
                    Nomination.Nominee__c = Nominee.Id;
                }
            }           
        }

        if ((saveSuccess) &&
            (SaveNominator))
        {
            System.debug(System.LoggingLevel.error,'### Save Nominator');
            // upsert Nominator
            nominatorResult = Database.upsert(Nominator, false);
            saveSuccess = bg_formUtils.EvaluateUpsertResult(nominatorResult);
            if ((saveSuccess) &&
            	(Nomination.Contact == null))
            {
            	Nomination.ContactId = Nominator.Id;
            }
        }

        if ((saveSuccess) &&
            (ValidData))
        {
            // Save nomination
            saveSuccess = upsertNomination(CurrentPageWrapper.NextPageStatus);
        }

        if ((saveSuccess) &&
            (ValidData))
        {
             // Return the new page reference
             returnPage = bg_formUtils.GetRedirectionPage(CurrentPageWrapper, Nomination.Id);
        }
        else
        {
            /*
                Display a suitable error depending on which page doesn't meet validation or return a generic error
            */

            if(CurrentPageWrapper.CurrentStatus == bg_formUtils.HAS_POSTS_PAGE_STATUS)
            {
                // Display an invalid posts error
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.HAS_Minimum_Posts_Error));
            }
            else if(CurrentPageWrapper.CurrentStatus == bg_formUtils.HAS_SUPPORTERS_PAGE_STATUS)
            {
                // Display an invalid supporters error
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.HAS_Minimum_Supporter_Error));
            }
            else
            {
                // Display a generic error for any other page
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.HAS_Standard_Page_Error));
            }

        	Database.rollback(sp);
        }
        return returnPage;
    }

    /*
        Overrideable method to redirect user to the previous page based on the current
        Page Wrapper
    */
    public virtual PageReference previousPage()
    {
        PageReference result = bg_FormUtils.GetPreviousPage(CurrentPageWrapper, Nomination.Id);
        return result;
    }

	/*
		Method to perform the upsert on nomination and set the Progress accordingly
	*/
	protected Boolean upsertNomination(String status)
	{
        Boolean result = true; //assume success
		Database.UpsertResult nominationResult;

		Nomination.Progress__c = status;
        nominationResult = Database.upsert(Nomination, false);
        result = bg_formUtils.EvaluateUpsertResult(nominationResult);
        return result;
	}

    /*
        Method to Add an empty string to List in order for User to input new additional value
    */
    public virtual void addNationality()
    {
        String newCountry = '';
        nationalities.add(new NationalityWrapper(nationalities.Size(), newCountry));
    }

    /*
        Method to iterate a list of Country Names and remove the matching parameter from the list
    */
    public virtual void updateNationalities()
    {
        nationalities.remove(countryName);
    } 

    public class NationalityWrapper 
    {
        public Integer Index {get;set;}
        public String NationalityLabel {get; set;}

        public NationalityWrapper(Integer i, String label)
        {
            this.Index = i;
            this.NationalityLabel = label;
        }
    }
}