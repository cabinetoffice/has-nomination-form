<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Account_Name_Individual</fullName>
        <description>Sets the Account Name for Organisation Types of Individual</description>
        <field>Name</field>
        <formula>TEXT ( Individual_Salutation__c ) &amp; &apos; &apos; &amp;
TRIM ( Individual_FirstName__c ) &amp; &apos; &apos; &amp;
TRIM ( Individual_LastName__c )</formula>
        <name>Set Account Name (Individual)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Account Name</fullName>
        <actions>
            <name>Set_Account_Name_Individual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the account name for Organisation Types of Individual</description>
        <formula>AND( OR( ISNEW(), ISCHANGED(Individual_Salutation__c), ISCHANGED(Individual_FirstName__c ), ISCHANGED(Individual_LastName__c ) ), OR( NOT(ISPICKVAL(Individual_Salutation__c, &apos;&apos;)), NOT(ISBLANK(Individual_FirstName__c )), NOT(ISBLANK(Individual_LastName__c )) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
