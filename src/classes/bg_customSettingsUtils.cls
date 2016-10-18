/********************************************************************
 * bg_customSettingsUtils
 *
 * Utilities class for custom settings
 *
 * Test Class: bg_customSettingsUtils_Test
 *
 * Author: Nic Flook - BrightGen Ltd
 * Created: 24-08-2016
 * Changes:
 * 06-09-2016	CPE	Altered GetPageReferenceSettingByPageOrder to use class member
 *					variable so only ever retrieves and processes settings once
 *					and added new method GetPageReferenceSettingsByPageName
 ********************************************************************/
public class bg_customSettingsUtils
{

    /*
        This method controls the retrieval and conversion of all HAS_Page_Reference__c
        custom settings into PageSettingWrappers for use by VF Redirection Page
        bg_PageSettingWrappers are returned keyed by the Progress Status value from the
        custom setting.
        Private class member variable used to ensure settings are only ever
        retrieved once in any transaction
    */
    private static Map<String, bg_PageSettingWrapper> pageSettingWrapper = new Map<String, bg_PageSettingWrapper>();
    public static Map<String, bg_PageSettingWrapper> GetPageReferenceSettingsByProgressStatus()
    {
        Map<Integer, HAS_Page_Reference__c> settingsByPageOrder;
        if ((pageSettingWrapper == null) ||
              pageSettingWrapper.isEmpty())
        {
			// First obtain all custom settings records and order by the Page Number
			settingsByPageOrder = GetPageReferenceSettingByPageOrder();

			//Now convert the settings into Wrappers
			Integer lastOrderNumber = -1;
			HAS_Page_Reference__c lastStatus = null;
			HAS_Page_Reference__c previousStatus = null;
			for (Integer orderNumber : settingsByPageOrder.keyset())
			{
				HAS_Page_Reference__c currentStatus = settingsByPageOrder.get(orderNumber);
				if ((lastOrderNumber > 0) &&
					(lastStatus != null))
				{
					bg_PageSettingWrapper thisWrapper = convertPageReferenceSettingsToPageSettingWrapper(lastStatus, currentStatus, previousStatus);
					pageSettingWrapper.put(thisWrapper.CurrentStatus, thisWrapper);
				}
				lastOrderNumber = orderNumber;
				previousStatus = lastStatus;
				lastStatus = currentStatus;
			}
        }

        return pageSettingWrapper;
    }

    /*
        This method controls the retrieval and conversion of all HAS_Page_Reference__c
        custom settings into PageSettingWrappers for use by VF Pages to control
        moving through the various steps of the form.
        bg_PageSettingWrappers are returned keyed by the Progress Status value from the
        custom setting.
        Private class member variable used to ensure settings are only ever
        retrieved once in any transaction
    */
    private static Map<String, bg_PageSettingWrapper> pageNameSettingWrapper = new Map<String, bg_PageSettingWrapper>();
    public static Map<String, bg_PageSettingWrapper> GetPageReferenceSettingsByPageName()
    {
        Map<Integer, HAS_Page_Reference__c> settingsByPageOrder;
        if ((pageNameSettingWrapper == null) ||
              pageNameSettingWrapper.isEmpty())
        {
			// First obtain all custom settings records and order by the Page Number
			settingsByPageOrder = GetPageReferenceSettingByPageOrder();

			//Now convert the settings into Wrappers
			Integer lastOrderNumber = -1;
			HAS_Page_Reference__c lastStatus = null;
			HAS_Page_Reference__c previousStatus = null;
			for (Integer orderNumber : settingsByPageOrder.keyset())
			{
				HAS_Page_Reference__c currentStatus = settingsByPageOrder.get(orderNumber);
				if ((lastOrderNumber > 0) &&
					(lastStatus != null))
				{
					bg_PageSettingWrapper thisWrapper = convertPageReferenceSettingsToPageSettingWrapper(lastStatus, currentStatus, previousStatus);
					pageNameSettingWrapper.put(thisWrapper.PageName.toLowerCase(), thisWrapper);
				}
				lastOrderNumber = orderNumber;
				previousStatus = lastStatus;
				lastStatus = currentStatus;
			}
        }

        return pageNameSettingWrapper;
    }

    /*
        This method converts HAS_Page_Reference__c custom settings into the
        pageSettingWrapper
        Two HAS_Page_Reference__c records are passed into the method to create
        the wrapper - these represent the current and next page values
    */
    private static bg_PageSettingWrapper convertPageReferenceSettingsToPageSettingWrapper(HAS_Page_Reference__c currentSetting, HAS_Page_Reference__c nextSetting, HAS_Page_Reference__c previousSetting)
    {
        bg_PageSettingWrapper result = new bg_PageSettingWrapper();
        result.CurrentStatus = currentSetting.Name;
        result.PageName = currentSetting.Page_Name__c;
        result.PageOrder = currentSetting.Order_in_Form__c.intValue();
        if (nextSetting != null)
        {
            result.NextPageName = nextSetting.Page_Name__c;
            result.NextPageStatus = nextSetting.Name;
        }
        if (previousSetting != null)
        {
            result.PreviousPageName = previousSetting.Page_Name__c;
            result.PreviousPageStatus = previousSetting.Name;
            result.HasPrevious = true;
        }
    return result;
    }

    /*
        This method will obtain all HAS_Page_Reference__c and return them keyed by
        the Page Order
        Private class member variable used to ensure settings are only ever
        retrieved once in any transaction
    */
    private static Map<Integer, HAS_Page_Reference__c> settingsByPageOrder = new Map<Integer, HAS_Page_Reference__c>();
    public static Map<Integer, HAS_Page_Reference__c> GetPageReferenceSettingByPageOrder()
    {
    	if ((settingsByPageOrder == null) ||
    		(settingsByPageOrder.isEmpty()))
    	{
	        Map<Integer, HAS_Page_Reference__c> pageReferenceMap = new Map<Integer, HAS_Page_Reference__c>();
	        for (HAS_Page_Reference__c hasSetting : HAS_Page_Reference__c.getAll().values())
	        {
	            pageReferenceMap.put(hasSetting.Order_in_Form__c.intValue(), hasSetting);
	        }

	        // need to provide in sorted order so last and current page references work correctly, Order in Form must be unique
	        List<Integer> orderNumberList = new List<Integer>(pageReferenceMap.keySet());
	        orderNumberList.sort();

	        for (Integer orderNumber : orderNumberList)
	        {
	            settingsByPageOrder.put(orderNumber, pageReferenceMap.get(orderNumber));
	        }
    	}
        return settingsByPageOrder;
    }

    // method to return the instance of HASFormSettings__c being used for the Form using the string HAS_FORM_CUSTOM_SETTING
    public static HASFormSettings__c getFormSettings()
    {
    	return HASFormSettings__c.getInstance(bg_formUtils.HAS_FORM_CUSTOM_SETTING);
    }
}