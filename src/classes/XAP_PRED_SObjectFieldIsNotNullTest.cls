@IsTest
public class XAP_PRED_SObjectFieldIsNotNullTest {
    private static final XFTY_DummySObjectProviderLookupIntf PROVIDER_LOOKUP = new TEST_DummySObjectFactoryOutletLookup();
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_PRED_SObjectFieldIsNotNull PREDICATE_UNDER_TEST
			= new XAP_PRED_SObjectFieldIsNotNull(Account.Description);

	private static final Account TEST_ACCOUNT
			= (Account) new XFTY_DummySObjectProvider(Account.SObjectType, PROVIDER_LOOKUP)
					.setInsertMode(XFTY_InsertModeEnum.NEVER)
					.supply();

	@IsTest
	public static void testIsTrueForReturnsTrueWhenTargetFieldHasValue() {
		// Arrange
		TEST_ACCOUNT.Description = 'Wuhan';

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = PREDICATE_UNDER_TEST.isTrueFor(TEST_ACCOUNT);
		}

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForReturnsFalseWhenTargetFieldHasNoValue() {
		// Arrange
		TEST_ACCOUNT.Description = null;

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = PREDICATE_UNDER_TEST.isTrueFor(TEST_ACCOUNT);
		}

		// Assert
		System.assert(!result);
	}
}