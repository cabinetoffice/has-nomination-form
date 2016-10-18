/********************************************************************
 * bg_SObjectUtils 
 *
 * Utilities class for SObject related activities
 *
 * Test Class: bg_SObjectUtils_Test
 *
 * Author: Jim Llewellyn - BrightGen Ltd
 * Created: 30-01-2015
 * Changes: 
 * 13-02-2014 CPE	New CheckMandatoryFields method
 * 10-09-2015 BJ	Added getOptionsFromSobjectList
 * 15-10-2015 JB	Added GetSeparatedString and ConvertFieldSetToString
 ********************************************************************/
public class bg_SObjectUtils {

	/*
		Return an options list from the Supplied SObjectType and Field for use in VF
	*/
	public static List<SelectOption> getSelectOptionTypes(Schema.sObjectType sObjectType, String fieldAPIName)
	{
		Schema.sObjectType sobject_type = sObjectType;
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
		List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldAPIName).getDescribe().getPickListValues();
		List<selectOption> options = new List<selectOption>();
		for (Schema.PicklistEntry a : pick_list_values) 
		{
			options.add(new selectOption(a.getLabel(), a.getValue()));
		}
      	return options;
	}

	/*
		Evaluates supplied fields on supplied record to ensure field has been populated.  Adds an error to 
		the field if data is not supplied
	*/
	public static Map<String, Boolean> CheckMandatoryFields(SObject record, List<String> fieldsToEvaluate)
	{
		Map<String, Boolean> results = new Map<String, Boolean>();
		Schema.sObjectType sobject_type = record.getSObjectType();
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
		for (String fieldName : fieldsToEvaluate)
		{
			if (field_map.containsKey(fieldName)) 
			{
				Schema.Describefieldresult dfr = field_map.get(fieldName).getDescribe();
				if (dfr.getType() == Schema.Displaytype.Boolean)
				{
					if ((record.get(fieldName) == null) ||
						(record.get(fieldName) == false))
					{
						results.put(fieldName, false);
					}
					else
					{
						results.put(fieldName, true);
					}
				}
				else
				{
					if ((record.get(fieldName) == null) ||
						(record.get(fieldName) == ''))
					{
						results.put(fieldName, false);
					}
					else
					{
						results.put(fieldName, true);
					}
				}
			}
		}
		return results;
	}
}