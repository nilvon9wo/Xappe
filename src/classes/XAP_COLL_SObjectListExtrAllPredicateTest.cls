// SObject List Extractor - All Predicate List Extractor Test
@IsTest
public class XAP_COLL_SObjectListExtrAllPredicateTest {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_COLL_SObjectListExtractor EXTRACTOR_UNDER_TEST = XAP_COLL_SObjectListExtractor.getInstance();

	private static final List<Account> TEST_ACCOUNT_LIST
			= (List<Account>) new XFTY_DummySObjectSupplier(Account.SObjectType)
					.setInsertMode(XFTY_InsertModeEnum.MOCK)
					.supplyList();

	private static final Account TEST_ACCOUNT = TEST_ACCOUNT_LIST[0];

	@IsTest public static void testShouldReturnValueWhenBothPredicatesTrue() {
		// Arrange
		List<XAP_PRED_SObjectPredicateIntf> testPredicateList = new List<XAP_PRED_SObjectPredicateIntf>{
				new TestPredicateAlwaysReturning(true),
				new TestPredicateAlwaysReturning(true)
		};

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTRACTOR_UNDER_TEST.extractWhereAllPredicatesTrue(TEST_ACCOUNT_LIST, testPredicateList);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(1, resultList.size());
		System.assertEquals(TEST_ACCOUNT, resultList[0]);
	}

	@IsTest public static void testShouldReturnEmptyWhenFirstPredicateFalse() {
		// Arrange
		List<XAP_PRED_SObjectPredicateIntf> testPredicateList = new List<XAP_PRED_SObjectPredicateIntf>{
				new TestPredicateAlwaysReturning(false),
				new TestPredicateAlwaysReturning(true)
		};

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTRACTOR_UNDER_TEST.extractWhereAllPredicatesTrue(TEST_ACCOUNT_LIST, testPredicateList);
		}
		Test.stopTest();

		// Assert
		System.assert(resultList.isEmpty());
	}

	@IsTest public static void testShouldReturnEmptyWhenSecondPredicateFalse() {
		// Arrange
		List<XAP_PRED_SObjectPredicateIntf> testPredicateList = new List<XAP_PRED_SObjectPredicateIntf>{
				new TestPredicateAlwaysReturning(true),
				new TestPredicateAlwaysReturning(false)
		};

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = EXTRACTOR_UNDER_TEST.extractWhereAllPredicatesTrue(TEST_ACCOUNT_LIST, testPredicateList);
		}
		Test.stopTest();

		// Assert
		System.assert(resultList.isEmpty());
	}

	private class TestPredicateAlwaysReturning implements XAP_PRED_SObjectPredicateIntf{
		Boolean returnTrue;

		public TestPredicateAlwaysReturning(Boolean returnTrue) {
			this.returnTrue = returnTrue;
		}

		public Boolean isTrueFor(SObject sObj) {
			return this.returnTrue;
		}
	}
}