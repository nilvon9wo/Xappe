@IsTest
public class XAP_DAO_DML_DeleteResultListWrapIntTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

	@IsTest public static void testGetResultWrapperListShouldReturnListWithExpectedProperties() {
		// Arrange
		Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supply();
		Boolean notAllOrNone = false;
		Database.DeleteResult testDeleteResult = Database.delete(testAccount, notAllOrNone);
		List<Database.DeleteResult> testDeleteResultList = new List<Database.DeleteResult>{
				testDeleteResult
		};
		XAP_DAO_DML_DeleteResultListWrapper wrapperUnderTest = new XAP_DAO_DML_DeleteResultListWrapper(testDeleteResultList);

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
		System.assertEquals(testDeleteResult.id, resultWrapper.getId());
		System.assertEquals(testDeleteResult.isSuccess(), resultWrapper.isSuccess());
		System.assert(resultWrapper.getErrorList().isEmpty());
	}
}