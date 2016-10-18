/*****************************************************************
 *  Class: bg_customSettingsUtils_Test
 *
 *  Test Class for bg_customSettingsUtils
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 *
 ****************************************************************/
@IsTest
private class bg_customSettingsUtils_Test
{

	/*
		Method to test GetPageReferenceSettingsByProgressStatus() to see whether
		page settings wrappers are created from page reference custom settings data
		successfully and contain one of page status'.
	*/

	public static testMethod void PageReferenceSettingsByProgressStatusFromCs_test()
	{
			// Create a custom setting record for 5 pages
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Name', 1, 'HAS_FormPage1');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Address', 2, 'HAS_FormPage2');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Contact Details', 3, 'HAS_FormPage3');
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Name', 4, 'HAS_FormPage4');
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Address', 5, 'HAS_FormPage5');

			bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus();

			System.assert(bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus().containsKey('Nominator Contact Details'));


	}

	/*
		Method to test GetPageReferenceSettingsByProgressStatus() to test that
		the returned map is empty and not null when custom settings are not present.
	*/

	public static testMethod void PageReferenceSettingsByProgressStatusEmptyMap_test()
	{
			bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus();

			System.assert(bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus().isEmpty());
	}

	/*
		Method to test GetPageReferenceSettingsByProgressStatus() to test that
		the map is only returned once per transaction
	*/
	public static testMethod void PageReferenceSettingsByProgressStatusTransaction_test()
	{
			// Create a custom setting record for 4 pages
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Name', 1, 'HAS_FormPage1');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Address', 2, 'HAS_FormPage2');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Contact Details', 3, 'HAS_FormPage3');
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Name', 4, 'HAS_FormPage4');

			// Check that we have the record number of records
			System.assertEquals(bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus().size(), 3);

			// Add another custom setting record
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Address', 5, 'HAS_FormPage5');

			// Check that we have the same number of records as the previous assert
			System.assertEquals(bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus().size(), 3);
	}

	/*
		Method to test GetPageReferenceSettingsByPageName() to see whether
		page settings wrappers are created from page reference custom settings data
		and contain one of page status'.
	*/

	public static testMethod void PageReferenceSettingsByPageNameFromCs_test()
	{
			// Create a custom setting record for 5 pages
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Name', 1, 'HAS_FormPage1');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Address', 2, 'HAS_FormPage2');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Contact Details', 3, 'HAS_FormPage3');
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Name', 4, 'HAS_FormPage4');
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Address', 5, 'HAS_FormPage5');

			System.assert(!bg_customSettingsUtils.GetPageReferenceSettingsByPageName().containsKey('HAS_FormPage3'));
			System.assert(bg_customSettingsUtils.GetPageReferenceSettingsByPageName().containsKey('has_formpage3'));
	}

	/*
		Method to test GetPageReferenceSettingsByPageName() to test that
		the returned map is empty and not null when custom settings are not present.
	*/

	public static testMethod void PageReferenceSettingsByPageNameEmptyMap_test()
	{
			bg_customSettingsUtils.GetPageReferenceSettingsByProgressStatus();

			System.assert(bg_customSettingsUtils.GetPageReferenceSettingsByPageName().isEmpty());
	}

	/*
		Method to test GetPageReferenceSettingsByProgressStatus() to test that
		the map is only returned once per transaction
	*/
	public static testMethod void PageReferenceSettingsByPageNameTransaction_test()
	{
			// Create a custom setting record for 4 pages
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Name', 1, 'HAS_FormPage1');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Address', 2, 'HAS_FormPage2');
			bg_UnitTestHelper.createHASPageRefSettings('Nominator Contact Details', 3, 'HAS_FormPage3');
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Name', 4, 'HAS_FormPage4');

			// Check that we have the record number of records
			System.assertEquals(bg_customSettingsUtils.GetPageReferenceSettingsByPageName().size(), 3);

			// Add another custom setting record
			bg_UnitTestHelper.createHASPageRefSettings('Nominee Address', 5, 'HAS_FormPage5');

			// Check that we have the same number of records as the previous assert
			System.assertEquals(bg_customSettingsUtils.GetPageReferenceSettingsByPageName().size(), 3);
	}

	/*
		Method to test that a form custom setting is being returned using getFormSettings()
	*/
	public static testMethod void getFormSettings_test()
	{
			// Create a form custom setting record
			bg_UnitTestHelper.createHASFormSettings('Default', 1);

			// Check that we have the record number of records
			System.assertNotEquals(bg_customSettingsUtils.getFormSettings(), null);
			
	}


}