@IsTest
public with sharing class XAP_EML_SendEmailErrorRewrapperTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_EML_SendEmailErrorRewrapper HELPER_UNDER_TEST = new XAP_EML_SendEmailErrorRewrapper();

	/*
	 *	We can't test seeding convert with Messaging.SendEmailError
	 *  Because we can't construct an instance of Messaging.SendEmailError
	 *  Nor can we reliably generate one, as this will fail in sandboxes without email enabled.
	 */

	@IsTest public static void testConvertShouldReturnAnEmptyListWhenNullInput() {
		// Arrange
		List<Messaging.SendEmailError> testSendEmailErrorList = new List<Messaging.SendEmailError>();

		// Act
		List<XAP_EML_SendEmailErrorWrapper> resultWrapperList;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultWrapperList = HELPER_UNDER_TEST.convert(testSendEmailErrorList);
		}
		Test.stopTest();

		// Assert
		System.assert(resultWrapperList.isEmpty());
	}
}