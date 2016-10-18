/********************************************************************
 * bg_HAS_PageDispatcher_Test
 *
 * Test class for bg_HAS_PageDispatcher - used to direct users to the correct page
 * based on the page refeence custom settings
 *
 *
 *
 * Author: Nic Flook - BrightGen Ltd
 * Created: 06-09-2016
 * Changes:
 *
 ********************************************************************/

public class bg_HAS_PageDispatcher
{
    public Case Nomination { get; set; } // The Nomination Case Record
    public Boolean ConfigurationError { get; set; } // Indicates there is a Configuration Error - this should display an error to the user
    public String ConfigurationErrorMessage { get; set; } // The error to display if ConfigurationError is set to true

    /*
        Constructor method for the Controllers
    */
    public bg_HAS_PageDispatcher(Apexpages.StandardController stdController)
    {
        //Set default property values
        ConfigurationError = false;
        ConfigurationErrorMessage = '';

        // Add default fields required that may not be referenced on the VF Page
        if (!test.isRunningTest())
        {
            List<String> fieldList = new List<String>{ 'Progress__c'};
            stdController.addFields(fieldList);
        }

        Nomination = (Case)stdController.getRecord();
    }


	public PageReference Redirect()
	{
		PageReference result;
		bg_PageSettingWrapper currentPageWrapper;
   		Map<String, bg_PageSettingWrapper> pageWrappers = bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus();
		String progressToUse;
		if (Nomination.Id == null)
		{
			progressToUse = bg_formUtils.HAS_DEFAULT_NOMINATION_STATUS;
		}
		else
		{
			progressToUse = Nomination.Progress__c;
		}
		if (PageWrappers.containsKey(progressToUse))
		{
			currentPageWrapper = PageWrappers.get(progressToUse);
		}
		else
		{
			//This indicates there is a mismatch in the custom settings and therefore we need to display an error
			ConfigurationError = true;
			ConfigurationErrorMessage = Label.HAS_Page_Reference_Setting_Error;
		}
		if (!ConfigurationError)
		{
			result = bg_formUtils.GetCurrentPage(currentPageWrapper, Nomination.Id);
		}
		return result;
    	}
}