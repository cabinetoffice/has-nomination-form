/********************************************************************
 * bg_HAS_Nomination_List_Controller
 *
 * Component controller for HAS_Nomination_List Visualforce Component
 *
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 08-04-2016
 * Changes: 
 *
 ********************************************************************/
 public class bg_HAS_Nomination_List_Controller
 {
 	public Id nominationId {get; set;}


 	/*
		Method to direct the user to the submission form that has been clicked on
		from the nomination list on the account profile page
 	*/
    public Pagereference redirectToNomination()
    {
    	PageReference nominationForm = Page.HAS_PageDispatcher;
    	nominationForm.getParameters().put('Id', ApexPages.currentPage().getParameters().get('nominationId'));

    	return nominationForm;

    }

    /*
        Because we want to use the Review page as a way to view a completed
        submission we can't rely on the status and dispatcher to serve us this.
        So we use a custom label to set a value for our page redirect.
     */

    public Pagereference redirectToCompletedNomination()
    {
        PageReference completedForm = null;
        String pageURL = System.Label.HAS_Review_Page_URL;

        completedForm = new PageReference(pageURL);

    	completedForm.getParameters().put('Id', ApexPages.currentPage().getParameters().get('nominationId'));

    	return completedForm;
    }
 }