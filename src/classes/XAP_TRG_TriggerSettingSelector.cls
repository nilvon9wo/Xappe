public with sharing virtual class XAP_TRG_TriggerSettingSelector {
	@TestVisible
	protected XAP_TRG_TriggerSettingSelector() {
	}

	private static XAP_TRG_TriggerSettingSelector instance;

	public static XAP_TRG_TriggerSettingSelector getInstance() {
		if (instance == null) {
			instance = new XAP_TRG_TriggerSettingSelector();
		}
		return instance;
	}

	public virtual XAP_TRG_Trigger_Settings__c get() {
		return XAP_TRG_Trigger_Settings__c.getInstance();
	}
}