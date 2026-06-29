@IsTest
public with sharing class XAP_TRIG_TriggerEventCoordinatorIntTest {
    private static final XFTY_DummySObjectProviderLookupIntf PROVIDER_LOOKUP = new TEST_DummySObjectFactoryOutletLookup();
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_TRIG_TriggerEventCoordinator COORDINATOR_UNDER_TEST = new XAP_TRIG_TriggerEventCoordinator();

	@IsTest public static void isExecutableReturnsTrueIfEnabledForProfileAndEnabledForSObjectAndNotInProgress() {
		// Arrange
		new XFTY_DummySObjectProvider(XAP_TRIG_TriggerSetting__c.SObjectType, PROVIDER_LOOKUP)
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supplyBundle();

		XAP_TRIG_TriggerContext testTriggerProperties = new XAP_TRIG_TriggerContext();
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