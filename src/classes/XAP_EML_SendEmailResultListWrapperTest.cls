@IsTest
public class XAP_EML_SendEmailResultListWrapperTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testGetResultWrapperListShouldReturnListWithExpectedProperties() {
		// Arrange
		List<Messaging.SendEmailResult> testSendEmailResultList = new List<Messaging.SendEmailResult>();
		XAP_EML_SendEmailResultListWrapper wrapperUnderTest = new XAP_EML_SendEmailResultListWrapper(testSendEmailResultList);

		// Act
		List<XAP_EML_SendEmailResultWrapperIntf> resultWrapperList;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultWrapperList = wrapperUnderTest.getResultWrapperList();
		}
		Test.stopTest();

		// Assert
		System.assert(resultWrapperList.isEmpty());
	}
}