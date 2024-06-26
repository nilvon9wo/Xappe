@IsTest
public class XAP_PRED_SObjectFieldHasChangedUnitTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	private static final List<Account> TEST_OLD_Account_LIST
			= (List<Account>) new XFTY_DummySObjectSupplier(Account.SObjectType)
					.setInsertMode(XFTY_InsertModeEnum.MOCK)
					.setQuantityPerTemplate(2)
					.supplyList();
	private static final Account TEST_OLD_Account = TEST_OLD_Account_LIST[0];
	private static final Id TEST_OLD_Account_ID = TEST_OLD_Account.Id;

	private static final Account TEST_NEW_Account
			= TEST_OLD_Account.clone(true, true, true, true);

	private static final SObjectField TEST_TARGET_FIELD = Account.Name;
	private static final String TEST_TARGET_VALUE = 'Needle';

	private static final Map<Id, SObject> TEST_OLD_Account_BY_ID_MAP = new Map<Id, SObject>(TEST_OLD_Account_LIST);
	private static final Map<Id, SObject> TEST_EMPTY_OLD_Account_BY_ID_MAP = new Map<Id, SObject>();
	private static final Map<Id, SObject> IRRELEVANT_MAP = null;

	@IsTest
	public static void testIsTrueForShouldReturnTrueIfNoOldMap() {
		// Arrange
		Map<Id, SObject> testOldSalesOrderByIdMap = null;
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(testOldSalesOrderByIdMap);
		TEST_NEW_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.isTrueFor(TEST_NEW_Account);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForShouldReturnTrueIfEmptyOldMap() {
		// Arrange
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(TEST_EMPTY_OLD_Account_BY_ID_MAP);
		TEST_NEW_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.isTrueFor(TEST_NEW_Account);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForShouldReturnTrueIfOldMapMissingTarger() {
		// Arrange
		TEST_OLD_Account_BY_ID_MAP.remove(TEST_OLD_Account_ID);
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(TEST_OLD_Account_BY_ID_MAP);
		TEST_NEW_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.isTrueFor(TEST_NEW_Account);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForShouldReturnTrueIfTargetValueChanged() {
		// Arrange
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(TEST_OLD_Account_BY_ID_MAP);
		TEST_NEW_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);
		TEST_OLD_Account.put(TEST_TARGET_FIELD, 'Other');

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.isTrueFor(TEST_NEW_Account);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForShouldReturnFalseIfTargetValueSame() {
		// Arrange
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(TEST_OLD_Account_BY_ID_MAP);
		TEST_NEW_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);
		TEST_OLD_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.isTrueFor(TEST_NEW_Account);
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest
	public static void testGetOldValueShouldReturnTargetFieldValue() {
		// Arrange
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(TEST_OLD_Account_BY_ID_MAP);
		TEST_OLD_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);

		// Act
		Object result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.getOldValue(TEST_OLD_Account_ID);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_TARGET_VALUE, result);
	}

	@IsTest
	public static void testGetValueOrNullShouldReturnTargetFieldValue() {
		// Arrange
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(IRRELEVANT_MAP);
		TEST_OLD_Account.put(TEST_TARGET_FIELD, TEST_TARGET_VALUE);

		// Act
		Object result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.getValueOrNull(TEST_OLD_Account, TEST_TARGET_FIELD);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_TARGET_VALUE, result);
	}

	@IsTest
	public static void testGetValueOrNullShouldReturnNullIfNoSObject() {
		// Arrange
		XAP_PRED_SObjectFieldHasChanged predicateUnderTest = createNewPedicate(IRRELEVANT_MAP);

		// Act
		Object result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = predicateUnderTest.getValueOrNull(null, TEST_TARGET_FIELD);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(null, result);
	}

	private static XAP_PRED_SObjectFieldHasChanged createNewPedicate(Map<Id, SObject> oldSObjectByIdMap) {
		return new XAP_PRED_SObjectFieldHasChanged(TEST_TARGET_FIELD, oldSObjectByIdMap);
	}
}