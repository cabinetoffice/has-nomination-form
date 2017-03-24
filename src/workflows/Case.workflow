<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>HAS_Nomination_Submitted</fullName>
        <description>Notify the Nominator that their form has been submitted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>honours@cabinetoffice.gov.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HAS_Email_Templates/HAS_Nomination_Submission_Nominator</template>
    </alerts>
    <alerts>
        <fullName>Notify_the_HAS_office_that_a_form_has_been_completed</fullName>
        <ccEmails>honours@cabinetoffice.gov.uk</ccEmails>
        <ccEmails>shikha.gupta@salesforce.com</ccEmails>
        <description>Notify the HAS office that a form has been completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>wendy.eaton@cabinetoffice.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>honours@cabinetoffice.gov.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>HAS_Email_Templates/HAS_Nomination_Submission_Office_VF</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Awaiting_LOS</fullName>
        <description>Sets progress to Awaiting letters of support</description>
        <field>Progress__c</field>
        <literalValue>Awaiting Letters of Support</literalValue>
        <name>Set Awaiting Letters of Support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Check nomination submission progress</fullName>
        <actions>
            <name>Set_Awaiting_LOS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Progress__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Letters_of_Support_Required__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Check to see if a submitted form has outstanding attachments and set progress status accordingly.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Form_ready_for_processing</fullName>
        <actions>
            <name>Notify_the_HAS_office_that_a_form_has_been_completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email is sent to the HAS office that a form is ready for processing.</description>
        <formula>ISPICKVAL(Progress__c, &apos;Submitted&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send nomination submission notification</fullName>
        <actions>
            <name>HAS_Nomination_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>A submission notification is sent to the nominator based on progress status</description>
        <formula>OR(Progress_Status__c = $Label.HAS_Nomination_Table_Status_Letters, Progress_Status__c = $Label.HAS_Nomination_Table_Status_Complete)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
