/********************************************************************
 * bg_SObjectUtils_Test 
 *
 * Unit test class for the bg_SObjectUtils utility class
 * 
 * Author: Jim Llewellyn - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 * 13-02-2014 CPE	New CheckMandatoryFields test method
 *
 ********************************************************************/
@isTest
private class bg_SObjectUtils_Test {

    static testMethod void testgetSelectOptionTypes() {
		List<SelectOption> sOptions =  bg_SObjectUtils.getSelectOptionTypes(Account.getSObjectType(), 'Type');
		system.assertEquals(false,sOptions.isEmpty());
		system.assertEquals(true,sOptions[0].getLabel() != '');
    }
	
	static testMethod void testCheckMandatoryFields()
	{
		Account testRecord = new Account();
		List<String> fieldsToEvaluate = new List<String>{'Name', 'Individual_FirstName__c'};

		testRecord.Name = 'TEST DATA';
        testRecord.Individual_FirstName__c  = '';
		
		Map<String, Boolean> results = bg_SObjectUtils.CheckMandatoryFields(testRecord, fieldsToEvaluate);
		system.assertEquals(true, results.get('Name'));
        system.assertEquals(false, results.get('Individual_FirstName__c'));
	}
}