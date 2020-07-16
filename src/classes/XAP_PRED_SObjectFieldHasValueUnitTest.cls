@IsTest
public class XAP_PRED_SObjectFieldHasValueUnitTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	private static final PBSI__PBSI_Sales_Order__c TEST_SALES_ORDER
			= (PBSI__PBSI_Sales_Order__c) new XFTY_DummySObjectSupplier(PBSI__PBSI_Sales_Order__c.SObjectType)
					.setOverrideTemplate(new PBSI__PBSI_Sales_Order__c(
							PBSI__Delivery_City__c = 'GoodCity'
					))
			.setInsertMode(XFTY_InsertModeEnum.MOCK)
			.supply();

	@IsTest
	public static void testIsTrueForShouldReturnTrueForCorrectData() {
		// Arrange
		XAP_PRED_SObjectFieldHasValue testObjectFieldHasValue = new XAP_PRED_SObjectFieldHasValue(
				PBSI__PBSI_Sales_Order__c.PBSI__Delivery_City__c,
				'GoodCity'
		);

		// Act
		Test.startTest();
		Boolean result;
		System.runAs(TEST_USER) {
			result = testObjectFieldHasValue.isTrueFor(TEST_SALES_ORDER);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForShouldReturnFalseForWrongCity() {
		// Arrange
		XAP_PRED_SObjectFieldHasValue testObjectFieldHasValue = new XAP_PRED_SObjectFieldHasValue(
				PBSI__PBSI_Sales_Order__c.PBSI__Delivery_City__c,
				'BadCity'
		);

		// Act
		Test.startTest();
		Boolean result;
		System.runAs(TEST_USER) {
			result = testObjectFieldHasValue.isTrueFor(TEST_SALES_ORDER);
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}