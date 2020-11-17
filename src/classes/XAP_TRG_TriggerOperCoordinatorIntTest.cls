@IsTest
public with sharing class XAP_TRG_TriggerOperCoordinatorIntTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_TRG_TriggerOperationCoordinator COORDINATOR_UNDER_TEST = new XAP_TRG_TriggerOperationCoordinator();

	@IsTest public static void isExecutableReturnsTrueIfEnabledForProfileAndEnabledForSObjectAndNotInProgress() {
		// Arrange
		new XFTY_DummySObjectSupplier(XAP_TRG_Trigger_Settings__c.SObjectType)
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supplyBundle();

		XAP_TRG_TriggerContext testTriggerProperties = new XAP_TRG_TriggerContext();
		testTriggerProperties.sObjectType = Account.SObjectType;
		testTriggerProperties.operationType = System.TriggerOperation.BEFORE_INSERT;

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = COORDINATOR_UNDER_TEST.isExecutable(testTriggerProperties);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}
}