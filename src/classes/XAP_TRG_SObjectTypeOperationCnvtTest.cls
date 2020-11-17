@IsTest
public with sharing class XAP_TRG_SObjectTypeOperationCnvtTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testConstructorShouldPopulatesInstanceProperties() {
		// Arrange
		XAP_TRG_SObjectTypeOperationConvertor helperUnderTest = new XAP_TRG_SObjectTypeOperationConvertor();

		SObjectType testSObjectType = Account.SObjectType;
		System.TriggerOperation testOperation = System.TriggerOperation.BEFORE_INSERT;
		XAP_TRG_TriggerContext testTriggerProperties = new XAP_TRG_TriggerContext();
		testTriggerProperties.sObjectType = testSObjectType;
		testTriggerProperties.operationType = testOperation;
		List<XAP_TRG_TriggerContext> testTriggerPropertiesList = new List<XAP_TRG_TriggerContext>{
				testTriggerProperties
		};

		// Act
		List<XAP_TRG_TriggerSObjectTypeOperation> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = helperUnderTest.convert(testTriggerPropertiesList);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(1, resultList.size());
		XAP_TRG_TriggerSObjectTypeOperation resultSObjectTypeOperation = resultList[0];
		System.assertEquals(testSObjectType, resultSObjectTypeOperation.sObjectType);
		System.assertEquals(testOperation, resultSObjectTypeOperation.operation);
	}
}