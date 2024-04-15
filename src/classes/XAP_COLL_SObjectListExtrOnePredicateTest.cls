// SObject List Extractor - Single Predicate Extractor Test
@IsTest
public class XAP_COLL_SObjectListExtrOnePredicateTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_COLL_SObjectListExtractor EXTRACTOR_UNDER_TEST
			= XAP_COLL_SObjectListExtractor.getInstance();

	private static final List<Account> TEST_ACCOUNT_LIST
			= (List<Account>) new XFTY_DummySObjectSupplier(Account.SObjectType)
					.setInsertMode(XFTY_InsertModeEnum.MOCK)
					.supplyList();

	private static final Account TEST_ACCOUNT = TEST_ACCOUNT_LIST[0];

	@IsTest
	public static void testExtractWhereTrueForReturnsValueWhenPredicateIsTrue() {
		// Arrange
		XAP_PRED_SObjectPredicateIntf testPredicate = new TestPredicateAlwaysReturning(true);

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTRACTOR_UNDER_TEST.extractWhereTrue(TEST_ACCOUNT_LIST, testPredicate);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(1, resultList.size());
		System.assertEquals(TEST_ACCOUNT, resultList[0]);
	}

	@IsTest
	public static void testExtractWhereTrueForDoesNotReturnValueWhenPredicateIsFalse() {
		// Arrange
		XAP_PRED_SObjectPredicateIntf testPredicate = new TestPredicateAlwaysReturning(false);

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTRACTOR_UNDER_TEST.extractWhereTrue(TEST_ACCOUNT_LIST, testPredicate);
		}
		Test.stopTest();

		// Assert
		System.assert(resultList.isEmpty());
	}

	private class TestPredicateAlwaysReturning implements XAP_PRED_SObjectPredicateIntf {
		Boolean returnTrue;

		public TestPredicateAlwaysReturning(Boolean returnTrue) {
			this.returnTrue = returnTrue;
		}

		public Boolean isTrueFor(SObject sObj) {
			return this.returnTrue;
		}
	}

	@IsTest
	public static void testExtractWhereNotNullForReturnsValueWhenSpecifiedValueExists() {
		// Arrange
		TEST_ACCOUNT.Description = 'Wuhan';
		SObjectField testField = Account.Description;

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTRACTOR_UNDER_TEST.extractWhereNotNull(TEST_ACCOUNT_LIST, testField);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(1, resultList.size());
		System.assertEquals(TEST_ACCOUNT, resultList[0]);
	}

	@IsTest
	public static void testExtractWhereNotNullForReturnsNoValueWhenSpecifiedValueDoesNotExist() {
		// Arrange
		TEST_ACCOUNT.Description = null;
		SObjectField testField = Account.Description;

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTRACTOR_UNDER_TEST.extractWhereNotNull(TEST_ACCOUNT_LIST, testField);
		}
		Test.stopTest();

		// Assert
		System.assert(resultList.isEmpty());
	}
}