@IsTest
public class XAP_DAO_DML_ResultListWrapperAbsUnitTest {
    private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

    private static final Id TEST_ID = XFTY_IdMocker.generateId(Account.SObjectType);
    private static final String TEST_ERROR_MESSAGE = 'Expected Error';

    // getSuccessLevel tests ----------------------------------------------------------------------------------

    @IsTest
    public static void testGetSuccessLevelReturnsSuccessLevel() {
        // Arrange
        TestWrapper wrapperUnderTest = new TestWrapper();
        wrapperUnderTest.resultWrapperList = new List<XAP_DAO_DML_ResultWrapperIntf>{
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
        wrapperUnderTest.resultWrapperList = new List<XAP_DAO_DML_ResultWrapperIntf>();
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
        XAP_DAO_DML_SaveResultWrapper testResult = createResultWrapper(false, TEST_ID);

        XAP_DAO_DML_DatabaseErrorWrapper testErrorWrapper = new XAP_DAO_DML_DatabaseErrorWrapper();
        testErrorWrapper.message = TEST_ERROR_MESSAGE;
        List<XAP_DAO_DML_DatabaseErrorWrapper> errorList = new List<XAP_DAO_DML_DatabaseErrorWrapper>{
                testErrorWrapper
        };
        testResult.errorList = errorList;

        wrapperUnderTest.resultWrapperList = new List<XAP_DAO_DML_ResultWrapperIntf>{
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
        System.assert(result.contains(TEST_ID));
        System.assert(result.contains(TEST_ERROR_MESSAGE));
    }

    @IsTest public static void testGetCombinedErrorMessageShouldReturnEmptyStringIfNoErrors() {
        // Arrange
        TestWrapper wrapperUnderTest = new TestWrapper();
        wrapperUnderTest.resultWrapperList = new List<XAP_DAO_DML_ResultWrapperIntf>{
                createResultWrapper(true, TEST_ID)
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
        XAP_DAO_DML_SaveResultWrapper testResult = new XAP_DAO_DML_SaveResultWrapper();
        testResult.id = TEST_ID;

        XAP_DAO_DML_DatabaseErrorWrapper testErrorWrapper = new XAP_DAO_DML_DatabaseErrorWrapper();
        testErrorWrapper.message = TEST_ERROR_MESSAGE;
        List<XAP_DAO_DML_DatabaseErrorWrapper> errorList = new List<XAP_DAO_DML_DatabaseErrorWrapper>{
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
        System.assert(result.contains(TEST_ID));
        System.assert(result.contains(TEST_ERROR_MESSAGE));
    }

    // Test helper methods -----------------------------------------------------------------------------------------

    private static XAP_DAO_DML_SaveResultWrapper createResultWrapper(Boolean wasSuccess) {
        return createResultWrapper(wasSuccess, XFTY_IdMocker.generateId(Account.SObjectType));
    }

    private static XAP_DAO_DML_SaveResultWrapper createResultWrapper(Boolean wasSuccess, Id testId) {
        XAP_DAO_DML_SaveResultWrapper resultWrapper = new XAP_DAO_DML_SaveResultWrapper();
        resultWrapper.id = testId;
        resultWrapper.wasSuccess = wasSuccess;
        return resultWrapper;
    }


    // TestWrapper -----------------------------------------------------------------------------------------

    private class TestWrapper extends XAP_DAO_DML_ResultListWrapperAbs {
        List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList;
        public override List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList() {
            return this.resultWrapperList;
        }
    }
}
