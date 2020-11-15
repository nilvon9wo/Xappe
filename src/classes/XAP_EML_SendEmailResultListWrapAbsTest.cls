@IsTest
public class XAP_EML_SendEmailResultListWrapAbsTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final String TEST_ERROR_MESSAGE = 'Expected Error';

	// getSuccessLevel tests ----------------------------------------------------------------------------------

	@IsTest
	public static void testGetSuccessLevelReturnsSuccessLevel() {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		wrapperUnderTest.resultWrapperList = new List<XAP_EML_SendEmailResultWrapperIntf>{
				createResultWrapper(true)
		};

		// Act
		XAP_DAO_DML_SuccessLevelEnum result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = wrapperUnderTest.calculateSuccessLevel();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.PERFECT, result);
	}

	// calculateSuccessLevel tests ----------------------------------------------------------------------------------

	@IsTest public static void testCalculateSuccessLevelShouldReturnPerfectIfAllTrue() {
		List<Boolean> wasSuccessList = new List<Boolean>{true, true};
		XAP_DAO_DML_SuccessLevelEnum expectedResult = XAP_DAO_DML_SuccessLevelEnum.PERFECT;
		testCalculateSuccessLevel(wasSuccessList,  expectedResult);
	}

	@IsTest public static void testCalculateSuccessLevelShouldReturnPartialIfAtLeastOneTrueAndAtLeastOneFalse() {
		List<Boolean> wasSuccessList = new List<Boolean>{true, false};
		XAP_DAO_DML_SuccessLevelEnum expectedResult = XAP_DAO_DML_SuccessLevelEnum.PARTIAL;
		testCalculateSuccessLevel(wasSuccessList,  expectedResult);
	}

	@IsTest public static void testCalculateSuccessLevelShouldReturnNoneIfAllFalse() {
		List<Boolean> wasSuccessList = new List<Boolean>{false, false};
		XAP_DAO_DML_SuccessLevelEnum expectedResult = XAP_DAO_DML_SuccessLevelEnum.NONE;
		testCalculateSuccessLevel(wasSuccessList,  expectedResult);
	}

	public static void testCalculateSuccessLevel(List<Boolean> wasSuccessList, XAP_DAO_DML_SuccessLevelEnum expectedResult) {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		wrapperUnderTest.resultWrapperList = new List<XAP_EML_SendEmailResultWrapperIntf>();
		for (Boolean wasSuccess : wasSuccessList) {
			wrapperUnderTest.resultWrapperList.add(createResultWrapper(wasSuccess));
		}

		// Act
		XAP_DAO_DML_SuccessLevelEnum result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = wrapperUnderTest.calculateSuccessLevel();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(expectedResult, result);
	}

	// isCompleteSuccess tests ----------------------------------------------------------------------------------

	@IsTest
	public static void testIsCompleteSuccessShouldReturnTrueWhenSuccessLevelIsPerfect() {
		XAP_DAO_DML_SuccessLevelEnum successLevel = XAP_DAO_DML_SuccessLevelEnum.PERFECT;
		Boolean expectedResult = true;
		testIsComplete(successLevel, expectedResult);
	}

	@IsTest
	public static void testIsCompleteSuccessShouldReturnFalseWhenSuccessLevelIsPartial() {
		XAP_DAO_DML_SuccessLevelEnum successLevel = XAP_DAO_DML_SuccessLevelEnum.PARTIAL;
		Boolean expectedResult = false;
		testIsComplete(successLevel, expectedResult);
	}

	@IsTest
	public static void testIsCompleteSuccessShouldReturnFalseWhenSuccessLevelIsNone() {
		XAP_DAO_DML_SuccessLevelEnum successLevel = XAP_DAO_DML_SuccessLevelEnum.NONE;
		Boolean expectedResult = false;
		testIsComplete(successLevel, expectedResult);
	}

	public static void testIsComplete(XAP_DAO_DML_SuccessLevelEnum successLevel, Boolean expectedResult) {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		wrapperUnderTest.successLevel = successLevel;

		// Act
		Boolean actualResult;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			actualResult = wrapperUnderTest.isCompleteSuccess();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(expectedResult, actualResult);
	}

	// getCombinedErrorMessage tests ----------------------------------------------------------------------------------

	@IsTest public static void testGetCombinedErrorMessageShouldReturnCommaSeparatedErrors() {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		XAP_EML_SendEmailResultWrapper testResult = createResultWrapper(false);

		XAP_EML_SendEmailErrorWrapper testErrorWrapper = new XAP_EML_SendEmailErrorWrapper();
		testErrorWrapper.message = TEST_ERROR_MESSAGE;
		List<XAP_EML_SendEmailErrorWrapper> errorList = new List<XAP_EML_SendEmailErrorWrapper>{
				testErrorWrapper
		};
		testResult.errorList = errorList;

		wrapperUnderTest.resultWrapperList = new List<XAP_EML_SendEmailResultWrapperIntf>{
				testResult
		};

		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = wrapperUnderTest.getCombinedErrorMessage();
		}
		Test.stopTest();

		// Assert
		System.assert(result.contains(TEST_ERROR_MESSAGE));
	}

	@IsTest public static void testGetCombinedErrorMessageShouldReturnEmptyStringIfNoErrors() {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		wrapperUnderTest.resultWrapperList = new List<XAP_EML_SendEmailResultWrapperIntf>{
				createResultWrapper(true)
		};

		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = wrapperUnderTest.getCombinedErrorMessage();
		}
		Test.stopTest();

		// Assert
		System.assertEquals('', result);
	}

	// getErrorMessage tests --------------------------------------------------------------------------------------

	@IsTest public static void testGetErrorMessageShouldReturnIdWithErrors() {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		XAP_EML_SendEmailResultWrapper testResult = new XAP_EML_SendEmailResultWrapper();

		XAP_EML_SendEmailErrorWrapper testErrorWrapper = new XAP_EML_SendEmailErrorWrapper();
		testErrorWrapper.message = TEST_ERROR_MESSAGE;
		List<XAP_EML_SendEmailErrorWrapper> errorList = new List<XAP_EML_SendEmailErrorWrapper>{
				testErrorWrapper
		};
		testResult.errorList = errorList;

		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = wrapperUnderTest.getErrorMessage(testResult);
		}
		Test.stopTest();

		// Assert
		System.assert(result.contains(TEST_ERROR_MESSAGE));
	}

	// Test helper methods -----------------------------------------------------------------------------------------

	private static XAP_EML_SendEmailResultWrapper createResultWrapper(Boolean wasSuccess) {
		XAP_EML_SendEmailResultWrapper resultWrapper = new XAP_EML_SendEmailResultWrapper();
		resultWrapper.wasSuccess = wasSuccess;
		return resultWrapper;
	}


	// TestWrapper -----------------------------------------------------------------------------------------

	private class TestWrapper extends XAP_EML_SendEmailResultListWrapperAbs {
		List<XAP_EML_SendEmailResultWrapperIntf> resultWrapperList;
		public override List<XAP_EML_SendEmailResultWrapperIntf> getResultWrapperList() {
			return this.resultWrapperList;
		}
	}
}