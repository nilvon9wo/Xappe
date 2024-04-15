@IsTest
public class XAP_UTIL_SetHelperTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_UTIL_SetHelper HELPER_UNDER_TEST = XAP_UTIL_SetHelper.getInstance();

	private static final List<Account> TEST_ACCOUNT_LIST
			= (List<Account>) new XFTY_DummySObjectSupplier(Account.SObjectType)
					.setInsertMode(XFTY_InsertModeEnum.MOCK)
					.supplyList();
	@IsTest
	public static void testIsTrueForReturnsTrueWhenTargetFieldHasValue() {
		// Arrange: Nothing to do here

		// Act
		Set<Id> resultSet;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultSet = HELPER_UNDER_TEST.extractIdsFrom(TEST_ACCOUNT_LIST, Account.Id);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_ACCOUNT_LIST.size(), resultSet.size());
		System.assertEquals(TEST_ACCOUNT_LIST[0].Id, new List<Id>(resultSet)[0]);
	}
}