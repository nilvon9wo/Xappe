@IsTest
public class XAP_DAO_DML_SaveResultListWrapperIntTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testGetResultWrapperListShouldReturnListWithExpectedProperties() {
		// Arrange
		Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
				.setInsertMode(XFTY_InsertModeEnum.LATER)
				.supply();
		Boolean notAllOrNone = false;
		Database.SaveResult testSaveResult = Database.insert(testAccount, notAllOrNone);
		List<Database.SaveResult> testSaveResultList = new List<Database.SaveResult>{
				testSaveResult
		};
		XAP_DAO_DML_SaveResultListWrapper wrapperUnderTest = new XAP_DAO_DML_SaveResultListWrapper(testSaveResultList);

		// Act
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultWrapperList = wrapperUnderTest.getResultWrapperList();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(testSaveResult.id, resultWrapper.getId());
		System.assertEquals(testSaveResult.isSuccess(), resultWrapper.isSuccess());
		System.assert(resultWrapper.getErrorList().isEmpty());
	}
}