@IsTest
public class TEST_DummyXapTriggerSettingFactoryOutlet implements XFTY_DummyQueueSobjectFactoryOutletIntf {
	public static final Boolean DEFAULT_TRIGGER_ENABLED = true;
	public static final Boolean DEFAULT_ACCOUNT_TRIGGER_ENABLED = true;

	private static final SObjectField PRIMARY_TARGET_FIELD = XAP_TRIG_TriggerSetting__c.Id;
	private static final XFTY_DummySObjectMasterTemplate MASTER_TEMPLATE = new XFTY_DummySObjectMasterTemplate(PRIMARY_TARGET_FIELD)
			.put(XAP_TRIG_TriggerSetting__c.AccountTriggerEnabled__c, new XFTY_DummyDefaultValueExact(DEFAULT_ACCOUNT_TRIGGER_ENABLED))
			.put(XAP_TRIG_TriggerSetting__c.TriggersEnabled__c, new XFTY_DummyDefaultValueExact(DEFAULT_TRIGGER_ENABLED));

	public SObjectField getPrimaryTargetField() {
		return PRIMARY_TARGET_FIELD;
	}

	public XFTY_DummySObjectMasterTemplate getMasterTemplate() {
		return MASTER_TEMPLATE;
	}

	public XFTY_DummySObjectBundle createBundle(
			List<SObject> templateSObjectList,
			XFTY_InsertModeEnum insertMode,
			XFTY_InsertInclusivityEnum inclusivity
	) {
		return XFTY_DummySObjectFactory.createBundle(MASTER_TEMPLATE, templateSObjectList, insertMode, inclusivity);
	}
}