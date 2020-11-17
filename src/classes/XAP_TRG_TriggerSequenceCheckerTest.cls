@IsTest
public with sharing class XAP_TRG_TriggerSequenceCheckerTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testCompareShouldReturnListComparison() {
		// Arrange
		XAP_TRG_SObjectTypeOperationCnvtMock mockSObjectTypeOperationHelper
				= new XAP_TRG_SObjectTypeOperationCnvtMock();
		XAP_TRG_TriggerSequenceChecker checkerUnderTest
				= new XAP_TRG_TriggerSequenceChecker(mockSObjectTypeOperationHelper);

		List<XAP_TRG_TriggerContext> triggerInProgressList;

		List<XAP_TRG_TriggerSObjectTypeOperation> testSObjectTypeOperationList = new List<XAP_TRG_TriggerSObjectTypeOperation>();
		List<XAP_TRG_TriggerSObjectTypeOperation> returnedSObjectTypeOperationList = testSObjectTypeOperationList.clone();
		mockSObjectTypeOperationHelper.returnedSObjectTypeOperationList = returnedSObjectTypeOperationList;

		// Act
		XAP_COLL_ListComparison resultComparison;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultComparison = checkerUnderTest.compare(triggerInProgressList, testSObjectTypeOperationList);
		}
		Test.stopTest();

		// Assert
		System.assert(resultComparison.isExactMatch);
	}
}
