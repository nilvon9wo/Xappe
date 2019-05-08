public with sharing virtual class XAP_TRIG_TriggerSettingSelector {
    @TestVisible
    protected XAP_TRIG_TriggerSettingSelector() {
    }

    private static XAP_TRIG_TriggerSettingSelector instance;

    public static XAP_TRIG_TriggerSettingSelector getInstance() {
        if (instance == null) {
            instance = new XAP_TRIG_TriggerSettingSelector();
        }
        return instance;
    }

    public virtual XAP_TRIG_TriggerSetting__c get() {
        return XAP_TRIG_TriggerSetting__c.getInstance();
    }
}