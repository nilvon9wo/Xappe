@IsTest
public with sharing class XAP_TRIG_TriggerSettingSelectorMock extends XAP_TRIG_TriggerSettingSelector {
	
	public XAP_TRIG_TriggerSetting__c returnedTriggerSetting;
	public override XAP_TRIG_TriggerSetting__c get() {
		return this.returnedTriggerSetting;
	}   
}