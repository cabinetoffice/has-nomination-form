<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Nationality_to_British</fullName>
        <description>Updates the Nationality to British if British is selected in the Is_British__c field.</description>
        <field>Nationality__c</field>
        <formula>&quot;British&quot;</formula>
        <name>Update Nationality to British</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Nationality</fullName>
        <actions>
            <name>Update_Nationality_to_British</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.is_British__c</field>
            <operation>equals</operation>
            <value>&quot;British (including English, Scottish, Welsh and Northern Irish)&quot;</value>
        </criteriaItems>
        <description>Updates the nationality field to British, if is_British is selected as British.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
