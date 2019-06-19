@IsTest
public with sharing class XAP_UTIL_ListComparison_SameStartTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testHasSameStartShouldReturnTrueIfBothListsAreNull() {
		// Arrange
		List<Integer> testHaystackList;
		List<Integer> testNeedleList;
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameStart;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameStartShouldReturnTrueIfBothListsAreNEmpty() {
		// Arrange
		List<Integer> testHaystackList = new List<Integer>();
		List<Integer> testNeedleList = new List<Integer>();
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameStart;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameStartShouldReturnTrueIfTheFirstElementOfEachListIsEqual() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, 10
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue, 11
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameStart;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameStartShouldReturnFalseIfTheFirstElementOfEachListIsNotEqual() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, 10
		};
		Integer otherValue = 2;
		List<Integer> testNeedleList = new List<Integer>{
				otherValue, 11
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameStart;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}