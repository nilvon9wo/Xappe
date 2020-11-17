@IsTest
public with sharing class XAP_TRG_TriggerSettingSelectorIntTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testGetReturnsAutomationSettingForUser() {
		// Arrange
		new XFTY_DummySObjectSupplier(XAP_TRG_Trigger_Settings__c.SObjectType)
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supplyBundle();
		XAP_TRG_TriggerSettingSelector selectorUnderTest = XAP_TRG_TriggerSettingSelector.getInstance();

		// Act
		XAP_TRG_Trigger_Settings__c resultSetting;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultSetting = selectorUnderTest.get();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(
				TEST_DummyXapTriggerSettingFactoryOutlet.DEFAULT_TRIGGER_ENABLED,
				resultSetting.All_Triggers_Enabled__c
		);
	}
}