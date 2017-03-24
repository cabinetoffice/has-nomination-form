/********************************************************************
 * bg_HASFormPage5Controller 
 *
 * controller actions for HASFormPage5 VF component
 * 
 * 
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 06-04-2016
 * Changes: 
 *
 ********************************************************************/
public class bg_HASFormPage5Controller 
{
	public List<Supporter__c> supporterList {get; set;}

	public void AddMoreSupporters()
    {
        supporterList.add(new Supporter__c());
    }
}