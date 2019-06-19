@IsTest
public with sharing class XAP_UTIL_ListComparison_ExactMatchTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testIsExactMatchShouldReturnTrueIfBothListsAreNull() {
		// Arrange
		List<Integer> testHaystackList;
		List<Integer> testNeedleList;
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testIsExactMatchShouldReturnTrueIfBothListsAreNEmpty() {
		// Arrange
		List<Integer> testHaystackList = new List<Integer>();
		List<Integer> testNeedleList = new List<Integer>();
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testIsExactMatchShouldReturnTrueIfBothListsHaveSameMembersInSameOrder() {
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
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testIsExactMatchShouldReturnFalseIfBothListsHaveSameMembersInDifferentOrder() {
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
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsExactMatchShouldReturnFalseIfNeedleListHasExtraMemberAtBeginningOfList() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, testValue2
		};
		List<Integer> testNeedleList = new List<Integer>{
				11, testValue, testValue2
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsExactMatchShouldReturnFalseIfNeedleListHasExtraMemberAtMiddleOfList() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, testValue2
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, 11, testValue2
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsExactMatchShouldReturnFalseIfNeedleListHasExtraMemberAtEndOfList() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, testValue2
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, testValue2, 11
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsExactMatchShouldReturnFalseIfHaystackHasExtraMemberAtBeginningOfList() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				11, testValue, testValue2
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, testValue2
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsExactMatchShouldReturnFalseIfHaystackHasExtraMemberAtMiddleOfList() {
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
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsExactMatchShouldReturnFalseIfHaystackHasExtraMemberAtEndOfList() {
		// Arrange
		Integer testValue = 1;
		Integer testValue2 = 2;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, testValue2, 11
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, testValue2
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isExactMatch;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}