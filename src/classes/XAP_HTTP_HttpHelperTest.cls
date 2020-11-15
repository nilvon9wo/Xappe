@IsTest
public with sharing class XAP_HTTP_HttpHelperTest {
    private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final XAP_HTTP_HttpHelper HELPER_UNDER_TEST = XAP_HTTP_HttpHelper.getInstance();

    // Test createFormPayload -------------------------------------------------------------------------------------------

    @IsTest
    public static void testCreateFormPayloadShouldCreateEncodedStringFromMap() {
        // Arrange
        String testKey1 = 'test key 1';
        String testValue1 = 'test value 1';
        String testKey2 = 'test key 2';
        String testValue2 = 'test value 2';

        Map<String, String> testValueByKeyMap = new Map<String, String>{
                testKey1 => testValue1,
                testKey2 => testValue2
        };

        // Act
        String resultValue;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultValue = HELPER_UNDER_TEST.createFormPayload(testValueByKeyMap);
        }
        Test.stopTest();

        // Assert
        String expectedValue1 = combine(testKey1, testValue1);
        String expectedValue2 = combine(testKey2, testValue2);
        System.assertEquals(expectedValue1 + '&' + expectedValue2, resultValue);
    }

    @IsTest
    public static void testEncodeForPayloadShouldCreateEncodedStringFromPair() {
        // Arrange
        String testKey = 'test key';
        String testValue = 'test value';

        // Act
        String resultValue;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultValue = HELPER_UNDER_TEST.encodeForPayload(testKey, testValue);
        }
        Test.stopTest();

        // Assert
        String expectedValue = combine(testKey, testValue);
        System.assertEquals(expectedValue, resultValue);
    }

    private static String combine(String testKey, String testValue) {
        return testKey + '=' + EncodingUtil.urlEncode(testValue,'UTF-8');
    }

    // Test isSuccess -------------------------------------------------------------------------------------------

    @IsTest
    public static void testIsSuccessShouldBeFalseForValuesBelow200() {
        Integer testStatusCode = 199;
        Boolean expectedValue = false;
        testIsSuccess(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsSuccessShouldBeTrueForValuesOf200() {
        Integer testStatusCode = 200;
        Boolean expectedValue = true;
        testIsSuccess(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsSuccessShouldBeTrueForValuesBetween200And299() {
        Integer testStatusCode = 250;
        Boolean expectedValue = true;
        testIsSuccess(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsSuccessShouldBeTrueForValuesOf299() {
        Integer testStatusCode = 299;
        Boolean expectedValue = true;
        testIsSuccess(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsSuccessShouldBeFalseForValuesAbove299() {
        Integer testStatusCode = 300;
        Boolean expectedValue = false;
        testIsSuccess(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsSuccessShouldBeFalseForNull() {
        Integer testStatusCode = null;
        Boolean expectedValue = false;
        testIsSuccess(testStatusCode, expectedValue);
    }

    private static void testIsSuccess(Integer testStatusCode, Boolean expectedValue) {
        // Arrange
        HttpResponse testResponse;

        if (testStatusCode != null) {
            testResponse = new HttpResponse();
            testResponse.setStatusCode(testStatusCode);
        }

        // Act
        Boolean resultValue;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultValue = HELPER_UNDER_TEST.isSuccess(testResponse);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(expectedValue, resultValue);
    }

    // Test isFailure -------------------------------------------------------------------------------------------

    @IsTest
    public static void testIsFailureShouldBeTrueForValuesBelow200() {
        Integer testStatusCode = 199;
        Boolean expectedValue = true;
        testIsFailure(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsFailureShouldBeFalseForValuesOf200() {
        Integer testStatusCode = 200;
        Boolean expectedValue = false;
        testIsFailure(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsFailureShouldBeFalseForValuesBetween200And299() {
        Integer testStatusCode = 250;
        Boolean expectedValue = false;
        testIsFailure(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsFailureShouldBeFalseForValuesOf299() {
        Integer testStatusCode = 299;
        Boolean expectedValue = false;
        testIsFailure(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsFailureShouldBeTrueForValuesAbove299() {
        Integer testStatusCode = 300;
        Boolean expectedValue = true;
        testIsFailure(testStatusCode, expectedValue);
    }

    @IsTest
    public static void testIsFailureShouldBeTrueForNull() {
        Integer testStatusCode = null;
        Boolean expectedValue = true;
        testIsFailure(testStatusCode, expectedValue);
    }

    private static void testIsFailure(Integer testStatusCode, Boolean expectedValue) {
        // Arrange
        HttpResponse testResponse;

        if (testStatusCode != null) {
            testResponse = new HttpResponse();
            testResponse.setStatusCode(testStatusCode);
        }

        // Act
        Boolean resultValue;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultValue = HELPER_UNDER_TEST.isFailure(testResponse);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(expectedValue, resultValue);
    }
}