/********************************************************************
 * bg_HAS_FormAttachmentsController
 *
 * Component controller for bg_HAS_FormAttachmentsController Visualforce Component
 *
 * Test Class: bg_HAS_FormAttachmentsController_TEST
 *
 * Author: Simon Lewis - BrightGen Ltd
 * Created: 08-04-2016
 * Changes: 08-08-2016 NF - Adapted the controller to use a new custom object to categorise attachments
 *          16-08-2016 NF - Rewrote uploadAttachment to prevent duplicate attachment records being created
 *                          and added validation for accepted file types
 *          19-08-2016 NF - UploadAttachment() now returns a page Reference with a returnURL parameter as well as a case Id.
 *
 ********************************************************************/
 public class bg_HAS_FormAttachmentsController {

    public Nomination_Attachment__c nominationAttachment {get; set;}
    public String attachmentCategory {get; set;}
    public String contentType {get; set;}
    public Id NominationId {get; set;}
    public Id nominationAttachmentId {get; set;}
    public Boolean goodFile;
    public String previousPageName {get; set;}


    public transient Attachment NewAttachment;

    public Attachment getNewAttachment()
    {
        if (NewAttachment == null)
        {
            NewAttachment = new Attachment();
        }

        return NewAttachment;
    }

    public Attachment setNewAttachment(Attachment value)
    {
        NewAttachment = value;
        return NewAttachment;
    }

    // create a new nomination attachment record to parent our attachment file.
    public Nomination_Attachment__c CreateNominationAttachmentRecord()
    {
        Nomination_Attachment__c output = null;

            if(nominationAttachment == null && NominationId != null && attachmentCategory != null &&  attachmentCategory != '')
            {
                    output = new Nomination_Attachment__c(Nomination__c = NominationId, Attachment_Type__c = attachmentCategory);
            }

        return output;
    }

    /*
        This method is invoked by pressing the upload button on the attachment VF page and will execute createNominationAttachment() which provides a parent record.
        If this record is created successfully, then this will be the parent of the uploaded attachment file.
    */

    public PageReference UploadAttachment()
    {
        PageReference pageRef;

        /*
            Set savePoint so we can roll back the transaction so that
            an empty nomination attachment record will not be created
        */
        System.Savepoint savePoint = Database.setSavepoint();
        Boolean saveSuccess = true;

        /*
            Check that the uploaded attachment is an accepted file format
            by comparing the contentType against a comma separated string
            of mime-types in a custom label
        */

        if(contentType != null && contentType != '')
        {
            goodFile = false;

            // populate the acceptedFileFormats property using the custom label
            String acceptedFileFormats = System.Label.HAS_Accepted_File_Formats;

            // test if the content type is contained in our custom label
            goodFile = acceptedFileFormats.contains(contentType);


            // Throw a specific error that refers to file types if conditions are met.
            if(goodFile != null && !goodFile)
            {
                System.debug('### goodFile' + goodFile);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.HAS_Attachment_Invalid_FileFormat_Error));
                return pageRef;
            }
            else
            {
                if(NewAttachment.Name != null && NewAttachment.Name != '' && goodFile)
                {
                    try
                    {
                        /*
                            Execute method to create a new attachment record with
                            predefined fields for type and nomination from URL parameters
                        */

                        Nomination_Attachment__c AttachmentRecord = CreateNominationAttachmentRecord();

                        /*
                            Insert that record so that it can be used as our parent, the insert
                            is here so as it can be rolled back to the Savepoint if an attachment
                            cannot be added
                        */

                        insert AttachmentRecord;

                        nominationAttachmentId = AttachmentRecord.Id;

                        /*
                            If we have created a parent record then we can try to parent the attachment file
                        */

                        // Set the parent Id to the new Nomination Attachment record
                        NewAttachment = new Attachment(Body = NewAttachment.Body,Name = newAttachment.Name, ParentId = attachmentRecord.Id);

                        insert NewAttachment;

                        // Get the vital variables that we need for updating the Nomination Attachment record from the new uploaded file
                        Id fileId = NewAttachment.Id;
                        String fileName = NewAttachment.Name;

                        // Update the Name and Attachment_Id__c field on the Nomination Attachment record
                        Nomination_Attachment__c UpsertAttachmentRecord = new Nomination_Attachment__c(Name = fileName, Attachment_Id__c = fileId, Id = attachmentRecord.Id);

                        upsert UpsertAttachmentRecord;


                    }
                    catch(DmlException ex)
                    {
                        saveSuccess = false;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.HAS_Attachment_Upload_Error));
                        Database.rollback(savePoint);
                    }
                }
                else
                {
                    saveSuccess = false;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.HAS_Attachment_Upload_Error));
                    return pageRef;
                }
            }

            /*
               After successful Save, refresh the attachment page with parameters intact
            */
            if(saveSuccess && attachmentCategory == bg_formUtils.NOMINATION_ATTACHMENT_EVIDENCE)
            {
                pageRef = Page.HAS_FormPage16;

            }
            else if(saveSuccess && attachmentCategory == bg_formUtils.NOMINATION_ATTACHMENT_LETTER)
            {
                pageRef = Page.HAS_FormPage19;
            }


            pageRef.getParameters().put('Id',NominationId);
            pageRef.getParameters().put('retURL',previousPageName);

            pageRef.setRedirect(true);
            return pageRef;
        }

        /*
            If there has been problem return the standard attachment error
        */

        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, Label.HAS_Attachment_Upload_Error));
        return pageRef;

    }

}