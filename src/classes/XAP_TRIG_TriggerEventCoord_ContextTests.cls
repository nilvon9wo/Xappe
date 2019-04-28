@IsTest
public with sharing class XAP_TRIG_TriggerEventCoord_ContextTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_TRIG_TriggerEventCoordinator COORDINATOR_UNDER_TEST = new XAP_TRIG_TriggerEventCoordinator();
	private static final SObjectType TEST_SOBJECT_TYPE = Account.SObjectType;
	private static final System.TriggerOperation TEST_OPERATION = System.TriggerOperation.BEFORE_INSERT;
	private static final XAP_TRIG_TriggerSObjectTypeOperation TEST_SOBJECT_OPERATION
		= new XAP_TRIG_TriggerSObjectTypeOperation(TEST_SOBJECT_TYPE, TEST_OPERATION);
	
	// isExecuting tests ---------------------------------------------------------------------------------- 
	
	@IsTest public static void testIsExecutingShouldReturnTrueWhenSObjectTypeOperationInProgress() {
 		// Arrange
 		Set<System.TriggerOperation> testOperationSet = new Set<System.TriggerOperation> {TEST_OPERATION};
    	XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(TEST_SOBJECT_TYPE, testOperationSet);
    	
    	// Act    
		Boolean result;		
        Test.startTest();
        System.runAs(TEST_USER){
	    	result = COORDINATOR_UNDER_TEST.isExecuting(TEST_SOBJECT_OPERATION);
        }
        Test.stopTest();
  
    	// Assert  
    	System.assert(result);
	}
	 
	@IsTest public static void testIsExecutingShouldReturnFalseWhenSObjectHasNoOperationsInProgress() {
 		// Arrange
 		Set<System.TriggerOperation> testOperationSet = new Set<System.TriggerOperation>();
    	XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(TEST_SOBJECT_TYPE, testOperationSet);
    	
    	// Act    
		Boolean result;		
        Test.startTest();
        System.runAs(TEST_USER){
	    	result = COORDINATOR_UNDER_TEST.isExecuting(TEST_SOBJECT_OPERATION);
        }
        Test.stopTest();
  
    	// Assert  
    	System.assert(!result);
	}
	
	@IsTest public static void testIsExecutingShouldReturnFalseWhenOperationsIsInProgressOnlyForOtherSObject()  {
 		// Arrange
 		Set<System.TriggerOperation> testOperationSet = new Set<System.TriggerOperation> {TEST_OPERATION};
 		SObjectType otherSObjectType = Contact.SObjectType; 
    	XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(otherSObjectType, testOperationSet);
    	
    	// Act    
		Boolean result;		
        Test.startTest();
        System.runAs(TEST_USER){
	    	result = COORDINATOR_UNDER_TEST.isExecuting(TEST_SOBJECT_OPERATION);
        }
        Test.stopTest();
  
    	// Assert  
    	System.assert(!result);
	}

	// isExecutingExclusively tests ---------------------------------------------------------------------------------- 
	
	@IsTest public static void testIsExecutingExclusivelyShouldReturnTrueWhenSObjectTypeOperationIsOnlyOperationInProgress()  {
 		// Arrange
 		Set<System.TriggerOperation> testOperationSet = new Set<System.TriggerOperation> {TEST_OPERATION};
    	XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(TEST_SOBJECT_TYPE, testOperationSet);
    	
    	// Act    
		Boolean result;		
        Test.startTest();
        System.runAs(TEST_USER){
	    	result = COORDINATOR_UNDER_TEST.isExecutingExclusively(TEST_SOBJECT_OPERATION);
        }
        Test.stopTest();
  
    	// Assert  
    	System.assert(result);
	}

	@IsTest public static void testIsExecutingExclusivelyShouldReturnFalseWhenSObjectsHasOtherOperationsInProgress()  {
 		// Arrange
    	System.TriggerOperation otherOperation = System.TriggerOperation.AFTER_DELETE;
 		Set<System.TriggerOperation> testOperationSet = new Set<System.TriggerOperation> {TEST_OPERATION, otherOperation};
    	XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(TEST_SOBJECT_TYPE, testOperationSet);
    	
    	// Act    
		Boolean result;		
        Test.startTest();
        System.runAs(TEST_USER){
	    	result = COORDINATOR_UNDER_TEST.isExecutingExclusively(TEST_SOBJECT_OPERATION);
        }
        Test.stopTest();
  
    	// Assert  
    	System.assert(!result);
	}
    
	
	@IsTest public static void testIsExecutingExclusivelyShouldReturnFalseWhenOtherSObjectsHaveOperationsInProgress() {
 		// Arrange
 		Set<System.TriggerOperation> testOperationSet = new Set<System.TriggerOperation> {TEST_OPERATION};
    	XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(TEST_SOBJECT_TYPE, testOperationSet);
    	
    	SObjectType otherSObjectType = Contact.SObjectType;
    	System.TriggerOperation otherOperation = System.TriggerOperation.AFTER_DELETE;
 		Set<System.TriggerOperation> otherOperationSet = new Set<System.TriggerOperation> {otherOperation};
    	XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(otherSObjectType, otherOperationSet);
    	
    	// Act    
		Boolean result;		
        Test.startTest();
        System.runAs(TEST_USER){
	    	result = COORDINATOR_UNDER_TEST.isExecutingExclusively(TEST_SOBJECT_OPERATION);
        }
        Test.stopTest();
  
    	// Assert  
    	System.assert(!result);
	}
}