/**
 * For technical reasons including both complexity and performance, XFTY can not currently support
 * Inserting both Company and Person Accounts concurrently.
 *
 * A significant aspect of this is that "normal" accounts require a "Name", whereas Person Accounts must
 * not only have a LastName instead of Name, but also must NOT even have a name.
 * SObject does not include any method for removing the name key property once it is set;
 * not even setting this value to null.
 *
 * Thus, person accounts must use a different master template.
 */
@IsTest
public class TEST_DummyAccountFactoryOutlet implements XFTY_DummySobjectFactoryOutletIntf {
	public static final String DEFAULT_NAME_PREFIX = 'Test Account Name';
	private static final SObjectField PRIMARY_TARGET_FIELD = Account.Id;

	private static final Map<String, RecordTypeInfo> RECORD_TYPE_INFO_BY_DEVELOPER_NAME_MAP = Account.SObjectType.getDescribe()
			.getRecordTypeInfosByDeveloperName();
	public static final Id PERSON_ACCOUNT_RECORD_TYPE_ID = RECORD_TYPE_INFO_BY_DEVELOPER_NAME_MAP.get('PersonAccount')
			.getRecordTypeId();

	private static final XFTY_DummySObjectMasterTemplate MASTER_TEMPLATE = new XFTY_DummySObjectMasterTemplate(PRIMARY_TARGET_FIELD)
			.put(Account.Name, new XFTY_DummyDefaultValueIncrementingString(DEFAULT_NAME_PREFIX));

	// WARNING: Because Contact requires account, do NOT put PersonContactId here or the result will be circular logic!!!
	private static final XFTY_DummySObjectMasterTemplate PERSON_TEMPLATE = new XFTY_DummySObjectMasterTemplate(PRIMARY_TARGET_FIELD)
			.put(Account.LastName, new XFTY_DummyDefaultValueIncrementingString(DEFAULT_NAME_PREFIX))
			.put(Account.RecordTypeId, new XFTY_DummyDefaultValueExact(PERSON_ACCOUNT_RECORD_TYPE_ID));

	public SObjectField getPrimaryTargetField() {
		return PRIMARY_TARGET_FIELD;
	}

	public XFTY_DummySObjectMasterTemplate getMasterTemplate() {
		return MASTER_TEMPLATE;
	}

	// Only first record will be checked; mixed bundles NOT currently supported.
	public XFTY_DummySObjectBundle createBundle(
			List<SObject> templateSObjectList,
			XFTY_InsertModeEnum insertMode,
			XFTY_InsertInclusivityEnum inclusivity
	) {
		Account firstAccount = ((List<Account>) templateSObjectList)[0];
		XFTY_DummySObjectMasterTemplate template = firstAccount.RecordTypeId == PERSON_ACCOUNT_RECORD_TYPE_ID
				? PERSON_TEMPLATE
				: MASTER_TEMPLATE;

		return XFTY_DummySObjectFactory.createBundle(template, templateSObjectList, insertMode, inclusivity);
	}
}
