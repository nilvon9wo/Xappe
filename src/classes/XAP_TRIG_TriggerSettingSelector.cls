public with sharing virtual class XAP_TRIG_TriggerSettingSelector {
	public virtual  XAP_TRIG_TriggerSetting__c get() {
		return XAP_TRIG_TriggerSetting__c.getInstance();
	}   
}