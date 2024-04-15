// SObject List Extractor - Abstract Extractor Test
@IsTest
public class XAP_UTIL_SObjectListExtrAbstractTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	private static final List<Account> TEST_ACCOUNT_LIST
			= (List<Account>) new XFTY_DummySObjectSupplier(Account.SObjectType)
					.setInsertMode(XFTY_InsertModeEnum.MOCK)
					.supplyList();

	private static final Account TEST_ACCOUNT = TEST_ACCOUNT_LIST[0];

	@IsTest public static void testShouldReturnValueWhenPredicatesTrue() {
		// Arrange
		Boolean returnTrue = true;
		XAP_UTIL_SObjectListExtractor.ListExtractor extractorUnderTest = new TestExtractor(returnTrue);

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = extractorUnderTest.extractFrom(TEST_ACCOUNT_LIST);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(1, resultList.size());
		System.assertEquals(TEST_ACCOUNT, resultList[0]);
	}

	@IsTest public static void testShouldReturnEmptyWhenPredicateFalse() {
		// Arrange
		Boolean returnTrue = false;
		XAP_UTIL_SObjectListExtractor.ListExtractor extractorUnderTest = new TestExtractor(returnTrue);

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = extractorUnderTest.extractFrom(TEST_ACCOUNT_LIST);
		}
		Test.stopTest();

		// Assert
		System.assert(resultList.isEmpty());
	}

	private class TestExtractor extends XAP_UTIL_SObjectListExtractor.ListExtractor {
		Boolean returnTrue;

		public TestExtractor(Boolean returnTrue) {
			this.returnTrue = returnTrue;
		}

		private Boolean isTrueFor(SObject sObj) {
			return this.returnTrue;
		}
	}
}