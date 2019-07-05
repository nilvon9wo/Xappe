@IsTest
public class XAP_DAO_TRANS_MultiDmlOpProcessUnitTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_DAO_TRANS_TransactionHelperMock MOCK_TRANSACTION_HELPER
			= new XAP_DAO_TRANS_TransactionHelperMock();
	private static final XAP_DAO_TRANS_MultiDmlOperationProcessor PROCESSOR_UNDER_TEST
			= new XAP_DAO_TRANS_MultiDmlOperationProcessor(MOCK_TRANSACTION_HELPER);

	@IsTest public static void testEnablePartialSuccessShouldSetRollbackOnPartialSuccessToFalse() {/* TODO */
		// Arrange : Nothing to do here

		// Act
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			PROCESSOR_UNDER_TEST.enablePartialSuccess();
		}
		Test.stopTest();

		// Assert
		System.assert(!PROCESSOR_UNDER_TEST.rollbackOnPartialSuccess);
	}

	@IsTest public static void testWasFailureShouldReturnTrueIfSuccessIsNone() {
		testWasFailure(XAP_DAO_DML_SuccessLevelEnum.NONE, true);
	}

	@IsTest public static void testWasFailureShouldReturnFalseIfSuccessIsPartial() {
		testWasFailure(XAP_DAO_DML_SuccessLevelEnum.PARTIAL, false);
	}

	@IsTest public static void testWasFailureShouldReturnFalseIfSuccessIsPerfect() {
		testWasFailure(XAP_DAO_DML_SuccessLevelEnum.PERFECT, false);
	}

	private static void testWasFailure(XAP_DAO_DML_SuccessLevelEnum level, Boolean expectedResult) {
		// Arrange
		XAP_DAO_TRANS_DmlResultMock dmlResult = new XAP_DAO_TRANS_DmlResultMock();
		dmlResult.returnedSuccessLevel = level;

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = PROCESSOR_UNDER_TEST.wasFailure(dmlResult);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(expectedResult, result);
	}

	@IsTest public static void testWasPartialSuccessShouldReturnFalseIfSuccessIsNone() {
		testWasPartialSuccess(XAP_DAO_DML_SuccessLevelEnum.NONE, false);
	}

	@IsTest public static void testWasPartialSuccessShouldReturnTrueIfSuccessIsPartial() {
		testWasPartialSuccess(XAP_DAO_DML_SuccessLevelEnum.PARTIAL, true);
	}

	@IsTest public static void testWasPartialSuccessShouldReturnFalseIfSuccessIsPerfect() {
		testWasPartialSuccess(XAP_DAO_DML_SuccessLevelEnum.PERFECT, false);
	}

	private static void testWasPartialSuccess(XAP_DAO_DML_SuccessLevelEnum level, Boolean expectedResult) {
		// Arrange
		XAP_DAO_TRANS_DmlResultMock dmlResult = new XAP_DAO_TRANS_DmlResultMock();
		dmlResult.returnedSuccessLevel = level;

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = PROCESSOR_UNDER_TEST.wasPartialSuccess(dmlResult);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(expectedResult, result);
	}

}