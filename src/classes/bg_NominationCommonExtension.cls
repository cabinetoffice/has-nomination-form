/*****************************************************************
 *  Class: bg_NominationCommonExtension
 *
 *  The generic extension of the Base virtual class to support the majority of the Nomination VF Pages
 *
 *	Test Class: bg_NominationCommonExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 ****************************************************************/
public class bg_NominationCommonExtension extends bg_NominationBaseExtension
{

	/*
		public property to options for Others In Post field
	*/

	public List<SelectOption> othersInPost
	{
	get
	{
		if(othersInPost == null || othersInPost.isEmpty())
		{
			othersInPost = new List<selectOption>();
			othersInPost.addAll(bg_SObjectUtils.getSelectOptionTypes(Case.getSObjectType(), 'Others_In_Post__c'));
		}

		return othersInPost;
	}
	set;
	}

	//Constructor
	public bg_NominationCommonExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}


}