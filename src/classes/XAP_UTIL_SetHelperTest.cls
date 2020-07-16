@IsTest
public class XAP_UTIL_SetHelperTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_UTIL_SetHelper HELPER_UNDER_TEST = XAP_UTIL_SetHelper.getInstance();

	private static final List<PBSI__PBSI_Sales_Order__c> TEST_SALES_ORDER_LIST
			= (List<PBSI__PBSI_Sales_Order__c>) new XFTY_DummySObjectSupplier(PBSI__PBSI_Sales_Order__c.SObjectType)
					.setInsertMode(XFTY_InsertModeEnum.MOCK)
					.supplyList();
	@IsTest
	public static void testIsTrueForReturnsTrueWhenTargetFieldHasValue() {
		// Arrange: Nothing to do here

		// Act
		Set<Id> resultSet;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultSet = HELPER_UNDER_TEST.extractIdsFrom(TEST_SALES_ORDER_LIST, PBSI__PBSI_Sales_Order__c.Id);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_SALES_ORDER_LIST.size(), resultSet.size());
		System.assertEquals(TEST_SALES_ORDER_LIST[0].Id, new List<Id>(resultSet)[0]);
	}
}