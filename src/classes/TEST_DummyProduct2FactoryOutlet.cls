@IsTest
public class TEST_DummyProduct2FactoryOutlet implements XFTY_DummyQueueSobjectFactoryOutletIntf {
	public static final String DEFAULT_NAME_PREFIX = 'Test Product Name';
	private static final SObjectField PRIMARY_TARGET_FIELD = Product2.Id;

	private static final XFTY_DummySObjectMasterTemplate MASTER_TEMPLATE
			= new XFTY_DummySObjectMasterTemplate(PRIMARY_TARGET_FIELD)
					.put(Product2.IsActive, new XFTY_DummyDefaultValueExact(true))
					.put(Product2.Name, new XFTY_DummyDefaultValueIncrementingString(DEFAULT_NAME_PREFIX));

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