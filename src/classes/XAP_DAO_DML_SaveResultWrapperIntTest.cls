@IsTest
public class XAP_DAO_DML_SaveResultWrapperIntTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final Database.SaveResult SAVE_RESULT = createSaveResult();
	private static final XAP_DAO_DML_SaveResultWrapper WRAPPER_UNDER_TEST = new XAP_DAO_DML_SaveResultWrapper(SAVE_RESULT);

	@IsTest public static void testGetIdShouldReturnAppropriateId() {
		// Arrange
		// Nothing to do here

		// Act
		Id resultId;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultId = WRAPPER_UNDER_TEST.getId();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(SAVE_RESULT.id, resultId);
	}

	@IsTest public static void testIsSuccessShouldReturnAppropriateStatus() {
		// Arrange
		// Nothing to do here

		// Act
		Boolean result;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			result = WRAPPER_UNDER_TEST.isSuccess();
		}
		Test.stopTest();

		// Assert
		System.assertEquals(SAVE_RESULT.isSuccess(), result);
	}

	@IsTest public static void testGetErrorListShouldReturnAppropriateResult() {
		// Arrange
		// Nothing to do here

		// Act
		List<XAP_DAO_DML_DatabaseErrorWrapper> resultWrapperList;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultWrapperList = WRAPPER_UNDER_TEST.getErrorList();
		}
		Test.stopTest();

		// Assert
		System.assert(resultWrapperList.isEmpty());
	}

	@IsTest public static void testWrapperConstructionShouldBePossibleWithoutASeedError() {
		// Arrange
		// Nothing to do here

		// Act
		XAP_DAO_DML_SaveResultWrapper resultWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultWrapper = new XAP_DAO_DML_SaveResultWrapper();
		}
		Test.stopTest();

		// Assert
		System.assertNotEquals(null, resultWrapper);
	}

	private static Database.SaveResult createSaveResult() {
		Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
				.setInsertMode(XFTY_InsertModeEnum.LATER)
				.supply();
		Boolean notAllOrNone = false;
		return Database.insert(testAccount, notAllOrNone);
	}
}