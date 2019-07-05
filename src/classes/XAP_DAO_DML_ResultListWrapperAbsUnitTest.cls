@IsTest
public class XAP_DAO_DML_ResultListWrapperAbsUnitTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	private static final Id TEST_ID = XFTY_IdMocker.generateId(Account.SObjectType);
	private static final String TEST_ERROR_MESSAGE = 'Expected Error';

	@IsTest public static void testGetCombinedErrorMessageShouldReturnCommaSeparatedErrors() {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		XAP_DAO_DML_SaveResultWrapper testResult = new XAP_DAO_DML_SaveResultWrapper();
		testResult.id = TEST_ID;
		testResult.wasSuccess = false;

		XAP_DAO_DML_DatabaseErrorWrapper testErrorWrapper = new XAP_DAO_DML_DatabaseErrorWrapper();
		testErrorWrapper.message = TEST_ERROR_MESSAGE;
		List<XAP_DAO_DML_DatabaseErrorWrapper> errorList = new List<XAP_DAO_DML_DatabaseErrorWrapper>{
				testErrorWrapper
		};
		testResult.errorList = errorList;

		wrapperUnderTest.resultWrapperList = new List<XAP_DAO_DML_ResultWrapperIntf>{testResult};

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

	@IsTest public static void testGetCombinedErrorMessageShouldReturnEmptyStringIfNoErrors()  {
		// Arrange
		TestWrapper wrapperUnderTest = new TestWrapper();
		XAP_DAO_DML_SaveResultWrapper testResult = new XAP_DAO_DML_SaveResultWrapper();
		testResult.id = TEST_ID;
		testResult.wasSuccess = true;

		wrapperUnderTest.resultWrapperList = new List<XAP_DAO_DML_ResultWrapperIntf>{testResult};

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

	private class TestWrapper extends XAP_DAO_DML_ResultListWrapperAbs {
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList;
		public override List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList() {
			return this.resultWrapperList;
		}
	}
}