@IsTest
public class XAP_PRED_SObjectFieldIsNotNullTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_PRED_SObjectFieldIsNotNull PREDICATE_UNDER_TEST
			= new XAP_PRED_SObjectFieldIsNotNull(PBSI__PBSI_Sales_Order__c.PBSI__Delivery_City__c);

	private static final PBSI__PBSI_Sales_Order__c TEST_SALES_ORDER
			= (PBSI__PBSI_Sales_Order__c) new XFTY_DummySObjectSupplier(PBSI__PBSI_Sales_Order__c.SObjectType)
					.setInsertMode(XFTY_InsertModeEnum.NEVER)
					.supply();

	@IsTest
	public static void testIsTrueForReturnsTrueWhenTargetFieldHasValue() {
		// Arrange
		TEST_SALES_ORDER.PBSI__Delivery_City__c = 'Wuhan';

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = PREDICATE_UNDER_TEST.isTrueFor(TEST_SALES_ORDER);
		}

		// Assert
		System.assert(result);
	}

	@IsTest
	public static void testIsTrueForReturnsFalseWhenTargetFieldHasNoValue() {
		// Arrange
		TEST_SALES_ORDER.PBSI__Delivery_City__c = null;

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = PREDICATE_UNDER_TEST.isTrueFor(TEST_SALES_ORDER);
		}

		// Assert
		System.assert(!result);
	}
}