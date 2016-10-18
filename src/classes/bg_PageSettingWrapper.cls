/********************************************************************
 * bg_PageSettingWrapper
 *
 * Controller class for bg_PageSettingWrapper
 *
 * Test Class: Various
 *
 * Author: Nic FLook - BrightGen Ltd
 * Created: 24-08-2014
 * Changes:
 *
 ********************************************************************/
public class bg_PageSettingWrapper
{
	public String CurrentStatus { get; set; }
	public Integer PageOrder { get; set; }
	public String PageName { get; set; }
	public String NextPageName { get; set; }
	public String NextPageStatus { get; set; }
	public String PreviousPageName { get; set; }
	public String PreviousPageStatus { get; set; }
	public Boolean HasPrevious { get; set; }
}