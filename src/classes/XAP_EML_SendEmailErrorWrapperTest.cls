@IsTest
public class XAP_EML_SendEmailErrorWrapperTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_EML_SendEmailErrorWrapper WRAPPER_UNDER_TEST = new XAP_EML_SendEmailErrorWrapper();

	/*
	 *	We can't test seeding XAP_EML_SendEmailErrorWrapper with Messaging.SendEmailResult
	 *  Because we can't construct an instance of Messaging.SendEmailResult
	 *  Nor can we reliably generate one, as this will fail in sandboxes without email enabled.
	 */

	@IsTest public static void testFieldList() {
		// Arrange
		List<String> testList = new List<String>();
		WRAPPER_UNDER_TEST.fieldList = testList;

		// Act
		List<String> resultList;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultList = WRAPPER_UNDER_TEST.fieldList;
		}
		Test.stopTest();

		// Assert
		System.assertEquals(testList, resultList);
	}

	@IsTest public static void testMessage() {
		// Arrange
		String testMessage = 'Test Message';
		WRAPPER_UNDER_TEST.message = testMessage;

		// Act
		String result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = WRAPPER_UNDER_TEST.message;
		}
		Test.stopTest();

		// Assert
		System.assertEquals(testMessage, result);
	}

	@IsTest public static void testStatusCode() {
		// Arrange
		StatusCode testCode = StatusCode.ALL_OR_NONE_OPERATION_ROLLED_BACK;
		WRAPPER_UNDER_TEST.statusCode = testCode;

		// Act
		StatusCode result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = WRAPPER_UNDER_TEST.statusCode;
		}
		Test.stopTest();

		// Assert
		System.assertEquals(testCode, result);
	}
}