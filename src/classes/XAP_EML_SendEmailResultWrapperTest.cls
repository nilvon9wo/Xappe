@IsTest
public with sharing class XAP_EML_SendEmailResultWrapperTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_EML_SendEmailResultWrapper WRAPPER_UNDER_TEST = new XAP_EML_SendEmailResultWrapper();

	@IsTest public static void testIsSuccessShouldReturnAppropriateStatus() {
		// Arrange
		WRAPPER_UNDER_TEST.wasSuccess = true;

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = WRAPPER_UNDER_TEST.isSuccess();
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testGetErrorListShouldReturnAppropriateResult() {
		// Arrange
		WRAPPER_UNDER_TEST.errorList = new List<XAP_EML_SendEmailErrorWrapper>();

		// Act
		List<XAP_EML_SendEmailErrorWrapper> resultWrapperList;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultWrapperList = WRAPPER_UNDER_TEST.getErrorList();
		}
		Test.stopTest();

		// Assert
		System.assert(resultWrapperList.isEmpty());
	}

	@IsTest public static void testWrapperConstructionShouldBePossibleWithoutASeedError() {
		// Arrange
		// Nothing to do here

		// Act
		XAP_EML_SendEmailResultWrapper resultWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultWrapper = new XAP_EML_SendEmailResultWrapper();
		}
		Test.stopTest();

		// Assert
		System.assertNotEquals(null, resultWrapper);
	}
}