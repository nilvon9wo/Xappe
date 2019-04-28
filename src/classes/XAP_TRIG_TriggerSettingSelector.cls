public with sharing virtual class XAP_TRIG_TriggerSettingSelector {
	private XAP_TRIG_TriggerSettingSelector() {
	}

	private static XAP_TRIG_TriggerSettingSelector INSTANCE;

	public static XAP_TRIG_TriggerSettingSelector getInstance() {
		if (INSTANCE == null) {
			INSTANCE = new XAP_TRIG_TriggerSettingSelector();
		}
		return INSTANCE;
	}

	public virtual  XAP_TRIG_TriggerSetting__c get() {
		return XAP_TRIG_TriggerSetting__c.getInstance();
	}   
}