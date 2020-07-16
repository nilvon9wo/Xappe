@IsTest
public class XAP_UTIL_ListFlattenerUnitTest {

	private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_UTIL_ListFlattener HELPER_UNDER_TEST = XAP_UTIL_ListFlattener.getInstance();

	private static final List<Case> TEST_CASE_LIST =
			(List<Case>) new XFTY_DummySObjectSupplier(Case.SObjectType)
					.setQuantityPerTemplate(5)
					.setInsertMode(XFTY_InsertModeEnum.MOCK)
					.setInclusivity(XFTY_InsertInclusivityEnum.REQUIRED)
					.supplyList();

	@IsTest public static void testFlattenListOfListsShouldReturnCorrectList() {
		// Arrange
		List<SObject> testCaseList = new List<SObject>{
				TEST_CASE_LIST[0],
				TEST_CASE_LIST[1]
		};
		List<SObject> testCaseList2 = new List<SObject>{
				TEST_CASE_LIST[2],
				TEST_CASE_LIST[3],
				TEST_CASE_LIST[4]
		};
		List<List<SObject>> listToFlatten = new List<List<SObject>>();
		listToFlatten.add(testCaseList);
		listToFlatten.add(testCaseList2);

		// Act
		List<SObject> resultList;
		Test.startTest();
		System.runAs(TEST_USER) {
			resultList = HELPER_UNDER_TEST.flattenListOfLists(listToFlatten);
		}
		Test.stopTest();

		// Assert
		for(Case testCase : TEST_CASE_LIST){
			System.assert(resultList.contains(testCase));
		}
	}
}