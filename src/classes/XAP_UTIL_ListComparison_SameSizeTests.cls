@IsTest
public with sharing class XAP_UTIL_ListComparison_SameSizeTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testIsSameSizeShouldReturnTrueIfBothListsAreNull() {
		// Arrange
		List<Integer> testHaystackList;
		List<Integer> testNeedleList;
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isSameSize;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testIsSameSizeShouldReturnTrueIfBothListsAreEmpty() {
		// Arrange
		List<Integer> testHaystackList = new List<Integer>();
		List<Integer> testNeedleList = new List<Integer>();
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.isSameSize;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testIsSameSizeShouldReturnTrueIfBothListsHaveSameNumberOfMembers() {
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
			result = comparisonUnderTest.isSameSize;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testIsSameSizeShouldReturnFalseIfBothListsHaveDifferentNumberOfMembers() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				testValue
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
			result = comparisonUnderTest.isSameSize;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}