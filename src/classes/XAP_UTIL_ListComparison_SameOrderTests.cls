@IsTest
public with sharing class XAP_UTIL_ListComparison_SameOrderTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testHasSameOrderShouldReturnTrueIfNeedleListIsNull() {
		// Arrange
		List<Integer> testHaystackList;
		List<Integer> testNeedleList;
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameOrder;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameOrderShouldReturnTrueIfNeedleListIsEmpty() {
		// Arrange
		List<Integer> testHaystackList = new List<Integer>();
		List<Integer> testNeedleList = new List<Integer>();
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameOrder;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameOrderShouldReturnTrueIfNeedleListHasOnlyOneMemberAlsoInHaystack() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				testValue
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameOrder;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameOrderShouldReturnTrueIfNeedleListHasMultipleMembersAlsoWithSameOrderInHaystackWithoutInterruption() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, testValue2
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, testValue2
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameOrder;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameOrderShouldReturnTrueIfNeedleListHasMultipleMembersAlsoWithSameOrderInHaystackWithInterruption() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, 11, testValue2
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, testValue2
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameOrder;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameOrderShouldReturnFalseIfNeedleListHasAnyMemberNotAlsoInHaystack() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				testValue
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, 10
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameOrder;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testHasSameOrderShouldReturnFalseIfNeedleListHasMultipleMembersWithDifferentOrderInHaystack() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, testValue2
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue2, testValue
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameOrder;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}