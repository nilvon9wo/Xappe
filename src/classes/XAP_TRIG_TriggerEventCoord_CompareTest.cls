@IsTest
public with sharing class XAP_TRIG_TriggerEventCoord_CompareTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testCompareShouldReturnListComparison() {
		// Arrange
		XAP_TRIG_TriggerSettingSelector mockAutomationSettingSelector = XAP_TRIG_TriggerSettingSelector.getInstance();
		XAP_TRIG_SObjectTypeOperationCnvtMock mockSObjectTypeOperationHelper
				= new XAP_TRIG_SObjectTypeOperationCnvtMock();
		XAP_TRIG_TriggerEventCoordinator coordinatorUnderTest
				= new XAP_TRIG_TriggerEventCoordinator(mockSObjectTypeOperationHelper, mockAutomationSettingSelector);

		List<XAP_TRIG_TriggerSObjectTypeOperation> testSObjectTypeOperationList = new List<XAP_TRIG_TriggerSObjectTypeOperation>();
		List<XAP_TRIG_TriggerSObjectTypeOperation> returnedSObjectTypeOperationList = testSObjectTypeOperationList.clone();
		mockSObjectTypeOperationHelper.returnedSObjectTypeOperationList = returnedSObjectTypeOperationList;

		// Act
		XAP_COLL_ListComparison resultComparison;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultComparison = coordinatorUnderTest.compare(testSObjectTypeOperationList);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(
				XAP_TRIG_TriggerEventCoordinator.TRIGGER_IN_PROGRESS_LIST,
				mockSObjectTypeOperationHelper.receivedTriggerPropertiesList
		);
		System.assert(resultComparison.isExactMatch);
	}
}
