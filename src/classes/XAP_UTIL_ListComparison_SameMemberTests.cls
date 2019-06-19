@IsTest
public with sharing class XAP_UTIL_ListComparison_SameMemberTests {
	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testHasAllMemberShouldReturnTrueIfNeedleListIsNull() {
		// Arrange
		List<Integer> testHaystackList;
		List<Integer> testNeedleList;
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasAllMembers;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasAllMemberShouldReturnTrueIfNeedleListIsEmpty() {
		// Arrange
		List<Integer> testHaystackList = new List<Integer>();
		List<Integer> testNeedleList = new List<Integer>();
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasAllMembers;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasAllMemberShouldReturnTrueIfHaystackHasEveryMemberOfNeedleList() {
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
			result = comparisonUnderTest.hasAllMembers;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasAllMemberShouldReturnTrueIfHaystackHasEveryMemberOfNeedleListAndExtraMembers() {
		// Arrange
		Integer testValue = 1;
		List<Integer> testHaystackList = new List<Integer>{
				testValue, 11
		};
		List<Integer> testNeedleList = new List<Integer>{
				testValue
		};
		XAP_UTIL_ListComparison comparisonUnderTest = new XAP_UTIL_ListComparison(testHaystackList, testNeedleList);

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_USER) {
			result = comparisonUnderTest.hasAllMembers;
		}
		Test.stopTest();

		// Assert
		System.assert(result);
	}

	@IsTest public static void testHasAllMemberShouldReturnFalseIfNeedleHasMemberNotInHaystack() {
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
			result = comparisonUnderTest.hasAllMembers;
		}
		Test.stopTest();

		// Assert
		System.assert(!result);
	}
}