@IsTest
public with sharing class XAP_REST_RestRequest_Tests {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

    @IsTest
    static void testConstructorPositive() {
        // Arrange : Nothing to do here

        // Act
        XAP_REST_RestRequest restRequestUnderTest;
        Test.startTest();
        System.runAs(TEST_USER) {
            restRequestUnderTest = new XAP_REST_RestRequest().setNamedCredential('dummyNamedCredential');
        }
        Test.stopTest();

        // Assert
        System.assertEquals(
                'dummyNamedCredential',
                restRequestUnderTest.namedCredential,
                'Expected the name credential to match'
        );
    }
}