@IsTest
public with sharing class XAP_TRIG_TriggerSettingSelectorIntTest {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testGetReturnsAutomationSettingForUser()  {
    	// Arrange
    	ACN_AutomationSettingTestDummyFactory.createForStandardIntegrationTest();
    	XAP_TRIG_TriggerSettingSelector selectorUnderTest = new XAP_TRIG_TriggerSettingSelector();
  
    	// Act    
		XAP_TRIG_TriggerSetting__c resultSetting;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultSetting = selectorUnderTest.get();
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(
    		ACN_AutomationSettingTestDummyFactory.DEFAULT_TRIGGER_ENABLED, 
    		resultSetting.TriggersEnabled__c
    	);
	}  
}