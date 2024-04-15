@IsTest
public class XAP_PRED_SObjectFieldHasValueUnitTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	private static final Account TEST_ACCOUNT
			= (Account) new XFTY_DummySObjectSupplier(Account.SObjectType)
					.setOverrideTemplate(new Account(
							Name = 'GoodCity'
					))
			.setInsertMode(XFTY_InsertModeEnum.MOCK)
			.supply();

	@IsTest
	public static void testIsTrueForShouldReturnTrueForCorrectData() {
		// Arrange
		XAP_PRED_SObjectFieldHasValue testObjectFieldHasValue = new XAP_PRED_SObjectFieldHasValue(
				Account.Name,
				'GoodCity'
		);

		// Act
		Test.startTest();
		Boolean result;
		System.runAs(TEST_USER) {
			result = testObjectFieldHasValue.isTrueFor(TEST_ACCOUNT);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForShouldReturnFalseForWrongCity() {
		// Arrange
		XAP_PRED_SObjectFieldHasValue testObjectFieldHasValue = new XAP_PRED_SObjectFieldHasValue(
				Account.Name,
				'BadCity'
		);

		// Act
		Test.startTest();
		Boolean result;
		System.runAs(TEST_USER) {
			result = testObjectFieldHasValue.isTrueFor(TEST_ACCOUNT);
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}