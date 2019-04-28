@IsTest
public with sharing class XAP_TRIG_TriggerEventCoordinatorIntTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_TRIG_TriggerEventCoordinator COORDINATOR_UNDER_TEST = new XAP_TRIG_TriggerEventCoordinator();

    @IsTest public static void isExecutableReturnsTrueIfEnabledForProfileAndEnabledForSObjectAndNotInProgress() {
    	// Arrange
		new XFTY_DummySObjectSupplier(XAP_TRIG_TriggerSetting__c.SObjectType)
			.setInsertMode(XFTY_InsertModeEnum.NOW)
			.supplyBundle();
    	
    	XAP_TRIG_TriggerWrapper testTriggerWrapper = new XAP_TRIG_TriggerWrapper();
    	testTriggerWrapper.sObjectType = Account.SObjectType;
    	testTriggerWrapper.operationType = System.TriggerOperation.BEFORE_INSERT;
 
    	// Act    
		Boolean result;		
        Test.startTest();
        System.runAs(TEST_USER){
	    	result = COORDINATOR_UNDER_TEST.isExecutable(testTriggerWrapper);
        }
        Test.stopTest();
  
    	// Assert  
    	System.assert(result);
	}
}