@IsTest
public with sharing class XAP_TRIG_SObjectTypeOperationCnvtTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
 
 	@IsTest public static void testConstructorShouldPopulatesInstanceProperties() {
		// Arrange
		XAP_TRIG_SObjectTypeOperationConvertor helperUnderTest = new XAP_TRIG_SObjectTypeOperationConvertor();
		
		SObjectType testSObjectType = Account.SObjectType;   
		System.TriggerOperation testOperation = System.TriggerOperation.BEFORE_INSERT;
		XAP_TRIG_TriggerProperties testTriggerProperties = new XAP_TRIG_TriggerProperties();
		testTriggerProperties.sObjectType = testSObjectType;
		testTriggerProperties.operationType = testOperation;
		List<XAP_TRIG_TriggerProperties> testTriggerPropertiesList = new List<XAP_TRIG_TriggerProperties>{testTriggerProperties};
		
		// Act
		List<XAP_TRIG_TriggerSObjectTypeOperation>  resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = helperUnderTest.convert(testTriggerPropertiesList);
		}
		Test.stopTest();
		
		// Assert
		System.assertEquals(1, resultList.size());
		XAP_TRIG_TriggerSObjectTypeOperation resultSObjectTypeOperation = resultList[0];
		System.assertEquals(testSObjectType, resultSObjectTypeOperation.sObjectType);
		System.assertEquals(testOperation, resultSObjectTypeOperation.operation);
	}    
}
