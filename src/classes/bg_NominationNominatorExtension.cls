/*****************************************************************
 *  Class: bg_NominationNominatorExtension
 *
 *  An extension of the Base virtual class to support the pages where Nominator Details change
 *
 *	Test Class: bg_NominationNominatorExtension_Test
 *
 *  Author:  Nic Flook - BrightGen Ltd
 *  Created: 02/09/2016
 *  Changes:
 *
 ****************************************************************/
public class bg_NominationNominatorExtension extends bg_NominationBaseExtension
{

	//Constructor
	public bg_NominationNominatorExtension(ApexPages.StandardController stdController)
	{
		super(stdController);
	}

	/*
		Overwrite of default populate properties method
	*/
	protected override void populateProperties()
	{
		SaveNominee = false;
		SaveNominator = true;
	}
}