@IsTest
public with sharing class XAP_UTIL_ListComparison_IllMatchedTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testIsIllMatchedShouldReturnTrueWhenNeedleListContainsMemberNotInHaystack() {
		// Arrange
		List<Integer> testHaystackList;
		List<Integer> testNeedleList = new List<Integer>{
				1
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isIllMatched;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testIsIllMatchedShouldReturnFalseWhenNeedleListIsNull() {
		// Arrange
		List<Integer> testHaystackList = new List<Integer>();
		List<Integer> testNeedleList;
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isIllMatched;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsIllMatchedShouldReturnFalseWhenNeedleListIsEmpty() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				testValue
		};
		List<Integer> testNeedleList = new List<Integer>();
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isIllMatched;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}

	@IsTest public static void testIsIllMatchedShouldReturnFalseWhenHaystackContainsAllNeedleListMembers() {
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
			result = comparisonUnderTest.isIllMatched;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}