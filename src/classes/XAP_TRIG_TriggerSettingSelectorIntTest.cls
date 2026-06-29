@IsTest
public with sharing class XAP_TRIG_TriggerSettingSelectorIntTest {
    private static final XFTY_DummySObjectProviderLookupIntf PROVIDER_LOOKUP = new TEST_DummySObjectFactoryOutletLookup();
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testGetReturnsAutomationSettingForUser() {
		// Arrange
		new XFTY_DummySObjectProvider(XAP_TRIG_TriggerSetting__c.SObjectType, PROVIDER_LOOKUP)
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supplyBundle();
		XAP_TRIG_TriggerSettingSelector selectorUnderTest = XAP_TRIG_TriggerSettingSelector.getInstance();

		// Act
		XAP_TRIG_TriggerSetting__c resultSetting;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultSetting = selectorUnderTest.get();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(
				TEST_DummyXapTriggerSettingFactoryOutlet.DEFAULT_TRIGGER_ENABLED,
				resultSetting.TriggersEnabled__c
		);
	}
}