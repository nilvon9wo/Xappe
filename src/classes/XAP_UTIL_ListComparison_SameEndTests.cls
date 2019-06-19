@IsTest
public with sharing class XAP_UTIL_ListComparison_SameEndTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testHasSameEndShouldReturnTrueIfBothListsAreNull() {
		// Arrange
		List<Integer> testHaystackList;
		List<Integer> testNeedleList;
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameEnd;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameEndShouldReturnTrueIfBothListsAreNEmpty() {
		// Arrange
		List<Integer> testHaystackList = new List<Integer>();
		List<Integer> testNeedleList = new List<Integer>();
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameEnd;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameEndShouldReturnTrueIfTheLastElementOfEachListIsEqual() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				10, testValue
		};
		List<Integer> testNeedleList = new List<Integer>{
				11, testValue
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameEnd;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasSameEndShouldReturnFalseIfTheLastElementOfEachListIsNotEqual() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				10, testValue
		};
		Integer otherValue = 2;
		List<Integer> testNeedleList = new List<Integer>{
				11, otherValue
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasSameEnd;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}