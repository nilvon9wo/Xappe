@IsTest
public with sharing class XAP_DTM_DateTimeWrapperTest {
    private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final XAP_DTM_DateTimeWrapper WRAPPER_UNDER_TEST = new XAP_DTM_DateTimeWrapper();

    private static final Datetime NOW = Datetime.now();
    private static final Integer TOLERANCE_IN_SECONDS = 1;

    @IsTest
    private static void testDefaultNowIsCloseToNow() {
        // Arrange : Nothing to do here

        // Act
        Datetime wrapperNow;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            wrapperNow = WRAPPER_UNDER_TEST.now;
        }
        Test.stopTest();

        // Assert
        System.assert(wrapperNow > NOW.addSeconds(-TOLERANCE_IN_SECONDS));
        System.assert(NOW.addSeconds(TOLERANCE_IN_SECONDS) > wrapperNow);
    }

    @IsTest
    private static void testDefaultDateGmtReflectsNow() {
        // Arrange : Nothing to do here

        // Act
        Datetime result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = WRAPPER_UNDER_TEST.dateGmt;
        }
        Test.stopTest();

        // Assert
        // There is a tiny chance this test could fail if executed very close to midnight.
        System.assertEquals(NOW.dateGmt(), result);
    }

    @IsTest
    private static void testNowMustNotSurviveSerialization() {
        // Arrange
        Datetime originalNow = WRAPPER_UNDER_TEST.now;
        String serializedWrapper = JSON.serialize(WRAPPER_UNDER_TEST);
        Integer delayInSeconds = 1;
        // FIXME? XAP_TEST_TimeHelper.sleep();

        // Act
        XAP_DTM_DateTimeWrapper resultWrapper;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultWrapper = (XAP_DTM_DateTimeWrapper) JSON.deserialize(serializedWrapper, XAP_DTM_DateTimeWrapper.class);
        }
        Test.stopTest();

        // Assert
        System.assert(resultWrapper.now > originalNow);
    }
}