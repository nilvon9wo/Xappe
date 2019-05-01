@IsTest
public with sharing class XAP_TRIG_TriggerPropertiesTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final List<Account> TEST_SOBJECT_LIST = (List<Account>) new XFTY_DummySObjectSupplier(Account.SObjectType)
			.supplyList();

	private static final SObjectType EXPECTED_SOBJECT_TYPE = TEST_SOBJECT_LIST[0].getSObjectType();

	// Test default constructor -----------------------------------------------------------------

	@IsTest public static void testConstructorProvidesNativeTriggerValuesByDefault() {
		// Arrange
		// Nothing to do here.
		
    	// Act    
		XAP_TRIG_TriggerProperties resultTriggerProperties;
        Test.startTest(); 
        System.runAs(TEST_USER){
	    	resultTriggerProperties = new XAP_TRIG_TriggerProperties();
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(null, resultTriggerProperties.isBefore);
    	System.assertEquals(null, resultTriggerProperties.isAfter);
    	System.assertEquals(null, resultTriggerProperties.isInsert);
    	System.assertEquals(null, resultTriggerProperties.isUpdate);
    	System.assertEquals(null, resultTriggerProperties.isDelete);
    	System.assertEquals(null, resultTriggerProperties.isUndelete);
    	System.assertEquals(false, resultTriggerProperties.isExecuting);
    	System.assertEquals(null, resultTriggerProperties.oldSObjectList);
    	System.assertEquals(null, resultTriggerProperties.newSObjectList);
    	System.assertEquals(null, resultTriggerProperties.oldSObjectByIdMap);
    	System.assertEquals(null, resultTriggerProperties.newSObjectByIdMap);
	}

	// Test selectSObjectType -----------------------------------------------------------------

	@IsTest public static void testSelectSObjectTypeShouldGetSObjectTypeFromNewListWhenAvailable() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.newSObjectList = TEST_SOBJECT_LIST;
		
    	// Act    
		SObjectType resultSObjectType;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultSObjectType = wrapperUnderTest.selectSObjectType();
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(EXPECTED_SOBJECT_TYPE, resultSObjectType);
	}

	@IsTest public static void testSelectSObjectTypeShouldGetSObjectTypeFromOldListWhenNewNotAvailable() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.oldSObjectList = TEST_SOBJECT_LIST;
		
    	// Act    
		SObjectType resultSObjectType;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultSObjectType = wrapperUnderTest.selectSObjectType();
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(EXPECTED_SOBJECT_TYPE, resultSObjectType);
	}

	@IsTest public static void testSelectSObjectTypeShouldSetSObjectTypeAsNullWhenNoListAvailable() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		
    	// Act    
		SObjectType resultSObjectType;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultSObjectType = wrapperUnderTest.selectSObjectType();
        }
        Test.stopTest();
 
    	// Assert
    	SObjectType expectedSObjectType = null;
    	System.assertEquals(expectedSObjectType, resultSObjectType);
	}	

	// Test selectOperation -----------------------------------------------------------------

	@IsTest public static void testSelectOperationTypeShouldReturnNullWhenTriggerNotExecuting() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.TriggerOperation expectedOperation = null;
    	System.assertEquals(expectedOperation, resultOperation);
	}	

	// This shouldn't represent a valid use case and is only for coverage.
	@IsTest public static void testSelectOperationTypeShouldReturnNullWhenTriggerExecutingButNeitherBeforeNorAfter() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = false;
		wrapperUnderTest.isAfter = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.TriggerOperation expectedOperation = null;
    	System.assertEquals(expectedOperation, resultOperation);
	}	

	@IsTest public static void testSelectOperationTypeShouldReturnBeforeInsertWhenAppropriate() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = true;
		wrapperUnderTest.isInsert = true;
		wrapperUnderTest.isUpdate = false;
		wrapperUnderTest.isDelete = false;
		wrapperUnderTest.isUndelete = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.BEFORE_INSERT, resultOperation);
	}
	
	@IsTest public static void testSelectOperationTypeShouldReturnBeforeUpdateWhenAppropriate()  {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = true;
		wrapperUnderTest.isInsert = false;
		wrapperUnderTest.isUpdate = true;
		wrapperUnderTest.isDelete = false;
		wrapperUnderTest.isUndelete = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.BEFORE_UPDATE, resultOperation);
	}
	
	@IsTest public static void testSelectOperationTypeShouldReturnBeforeDeleteWhenAppropriate()  {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = true;
		wrapperUnderTest.isInsert = false;
		wrapperUnderTest.isUpdate = false;
		wrapperUnderTest.isDelete = true;
		wrapperUnderTest.isUndelete = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.BEFORE_DELETE, resultOperation);
	}
	
	@IsTest public static void testSelectOperationTypeShouldReturnAfterInsertWhenAppropriate() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = false;
		wrapperUnderTest.isAfter = true;
		wrapperUnderTest.isInsert = true;
		wrapperUnderTest.isUpdate = false;
		wrapperUnderTest.isDelete = false;
		wrapperUnderTest.isUndelete = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.AFTER_INSERT, resultOperation);
	}
	
	@IsTest public static void testSelectOperationTypeShouldReturnAfterUpdateWhenAppropriate()  {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = false;
		wrapperUnderTest.isAfter = true;
		wrapperUnderTest.isInsert = false;
		wrapperUnderTest.isUpdate = true;
		wrapperUnderTest.isDelete = false;
		wrapperUnderTest.isUndelete = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.AFTER_UPDATE, resultOperation);
	}
	
	@IsTest public static void testSelectOperationTypeShouldReturnAfterDeleteWhenAppropriate()  {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = false;
		wrapperUnderTest.isAfter = true;
		wrapperUnderTest.isInsert = false;
		wrapperUnderTest.isUpdate = false;
		wrapperUnderTest.isDelete = true;
		wrapperUnderTest.isUndelete = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.AFTER_DELETE, resultOperation);
	}
	
	@IsTest public static void testSelectOperationTypeShouldReturnAfterUndeleteWhenAppropriate()  {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = false;
		wrapperUnderTest.isAfter = true;
		wrapperUnderTest.isInsert = false;
		wrapperUnderTest.isUpdate = false;
		wrapperUnderTest.isDelete = false;
		wrapperUnderTest.isUndelete = true;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.AFTER_UNDELETE, resultOperation);
	}

	// Test getters -----------------------------------------------------------------

	@IsTest public static void testGetSObjectTypeShouldReturnAppropriateType()  {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.newSObjectList = TEST_SOBJECT_LIST;
		
    	// Act    
		SObjectType resultSObjectType;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultSObjectType = wrapperUnderTest.sObjectType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(EXPECTED_SOBJECT_TYPE, resultSObjectType);
	}

	@IsTest public static void testGetOperationTypeShouldReturnAppropriateOperation() {
		// Arrange
		XAP_TRIG_TriggerProperties wrapperUnderTest = new XAP_TRIG_TriggerProperties();
		wrapperUnderTest.isExecuting = true;
		wrapperUnderTest.isBefore = true;
		wrapperUnderTest.isInsert = true;
		wrapperUnderTest.isUpdate = false;
		wrapperUnderTest.isDelete = false;
		wrapperUnderTest.isUndelete = false;
		
    	// Act    
		System.TriggerOperation resultOperation;
        Test.startTest();
        System.runAs(TEST_USER){
	    	resultOperation = wrapperUnderTest.operationType;
        }
        Test.stopTest();
 
    	// Assert
    	System.assertEquals(System.TriggerOperation.BEFORE_INSERT, resultOperation);
	}

}