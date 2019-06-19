@IsTest
public with sharing class XAP_TRIG_TriggerSObjectTypeOperationTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	private static final SObjectType TEST_SOBJECT_TYPE = Account.SObjectType;
	private static final System.TriggerOperation TEST_OPERATION = System.TriggerOperation.BEFORE_INSERT;
	private static final XAP_TRIG_TriggerSObjectTypeOperation OPERATION_UNDER_TEST
			= new XAP_TRIG_TriggerSObjectTypeOperation(TEST_SOBJECT_TYPE, TEST_OPERATION);

	// Test constructors -----------------------------------------------------------------------------------------

	@IsTest public static void testConstructorShouldPopulatesInstanceProperties() {
		// Arrange
		// Nothing to do here

		// Act
		XAP_TRIG_TriggerSObjectTypeOperation result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = new XAP_TRIG_TriggerSObjectTypeOperation(TEST_SOBJECT_TYPE, TEST_OPERATION);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_SOBJECT_TYPE, result.sObjectType);
		System.assertEquals(TEST_OPERATION, result.operation);
	}

	@IsTest public static void testConstructorShouldPopulatesInstancePropertiesFromTriggerProperties() {
		// Arrange
		XAP_TRIG_TriggerProperties testTriggerProperties = new XAP_TRIG_TriggerProperties();
		testTriggerProperties.sObjectType = TEST_SOBJECT_TYPE;
		testTriggerProperties.operationType = TEST_OPERATION;

		// Act
		XAP_TRIG_TriggerSObjectTypeOperation result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = new XAP_TRIG_TriggerSObjectTypeOperation(testTriggerProperties);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(TEST_SOBJECT_TYPE, result.sObjectType);
		System.assertEquals(TEST_OPERATION, result.operation);
	}

	// Test equals -----------------------------------------------------------------------------------------

	@IsTest public static void testEqualsShouldReturnTrueIfSObjecTypeAndOperationAreSame() {
		// Arrange
		XAP_TRIG_TriggerSObjectTypeOperation otherSObjectOperation
				= new XAP_TRIG_TriggerSObjectTypeOperation(TEST_SOBJECT_TYPE, TEST_OPERATION);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = OPERATION_UNDER_TEST.equals(otherSObjectOperation);
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testEqualsShouldReturnFalseIfSObjecTypeIsDiffered() {
		// Arrange
		SObjectType otherSObjectType = Contact.SObjectType;
		XAP_TRIG_TriggerSObjectTypeOperation otherSObjectOperation
				= new XAP_TRIG_TriggerSObjectTypeOperation(otherSObjectType, TEST_OPERATION);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = OPERATION_UNDER_TEST.equals(otherSObjectOperation);
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testEqualsShouldReturnFalseIfOperationIsDiffered() {
		// Arrange
		System.TriggerOperation otherOperation = System.TriggerOperation.AFTER_INSERT;
		XAP_TRIG_TriggerSObjectTypeOperation otherSObjectOperation
				= new XAP_TRIG_TriggerSObjectTypeOperation(TEST_SOBJECT_TYPE, otherOperation);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = OPERATION_UNDER_TEST.equals(otherSObjectOperation);
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}