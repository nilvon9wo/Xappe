@IsTest
public with sharing class XAP_ENV_UrlWrapperTest {
    private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final XAP_ENV_UrlWrapper WRAPPER_UNDER_TEST = new XAP_ENV_UrlWrapper();

    @IsTest
    private static void testDefaultNowIsCloseToNow() {
        // Arrange : Nothing to do here

        // Act
        String result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = WRAPPER_UNDER_TEST.hostUrl;
        }
        Test.stopTest();

        // Assert
        System.assertEquals(Url.getOrgDomainUrl().toString(), result);
    }
}