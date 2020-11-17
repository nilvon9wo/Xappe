@IsTest
public with sharing class XAP_TRG_TriggerSettingSelectorMock extends XAP_TRG_TriggerSettingSelector {

	public XAP_TRG_Trigger_Settings__c returnedTriggerSetting;
	public override XAP_TRG_Trigger_Settings__c get() {
		return this.returnedTriggerSetting;
	}
}