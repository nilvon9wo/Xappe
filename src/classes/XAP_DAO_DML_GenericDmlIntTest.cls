@IsTest
public class XAP_DAO_DML_GenericDmlIntTest {
	private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
	private static final XAP_DAO_DML_InheritedSharingDml DML_HANDLER = XAP_DAO_DML_InheritedSharingDml.getInstance();

	// Insert Tests -------------------------------------------------------------------------------------------------

	@IsTest public static void testDoInsertShouldReturnAppropriateWrappedResult() {
		// Arrange
		Account testAccount = new Account();
		XAP_DAO_DML_OperationModeEnum testOperationMode = XAP_DAO_DML_OperationModeEnum.BEST_EFFORT;

		// Act
		XAP_DAO_DML_SaveResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doInsert(new List<Account>{
					testAccount
			}, testOperationMode);
		}
		Test.stopTest();

		// Assert
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(null, resultWrapper.getId());
		System.assertEquals(false, resultWrapper.isSuccess());
		System.assertEquals(1, resultWrapper.getErrorList().size());
	}

	@IsTest public static void testDoInsertShouldBeAllOrNoneByDefault() {
		// Arrange
		Account testAccount = new Account();

		// Act
		Boolean exceptionCaught = false;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			try {
				DML_HANDLER.doInsert(new List<Account>{
						testAccount
				});
			}
			catch (System.DmlException ex) {
				System.assert(ex.getMessage().contains('REQUIRED_FIELD_MISSING'));
				exceptionCaught = true;
			}
		}
		Test.stopTest();

		// Assert
		System.assert(exceptionCaught);
	}

	// Update Tests -------------------------------------------------------------------------------------------------

	@IsTest public static void testDoUpdateShouldReturnAppropriateWrappedResult() {
		// Arrange
		Account testAccount = new Account();
		XAP_DAO_DML_OperationModeEnum testOperationMode = XAP_DAO_DML_OperationModeEnum.BEST_EFFORT;

		// Act
		XAP_DAO_DML_SaveResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doUpdate(new List<Account>{
					testAccount
			}, testOperationMode);
		}
		Test.stopTest();

		// Assert
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(null, resultWrapper.getId());
		System.assertEquals(false, resultWrapper.isSuccess());
		System.assertEquals(1, resultWrapper.getErrorList().size());
	}

	@IsTest public static void testDoUpdateShouldBeAllOrNoneByDefault() {
		// Arrange
		Account testAccount = new Account();

		// Act
		Boolean exceptionCaught = false;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			try {
				DML_HANDLER.doUpdate(new List<Account>{
						testAccount
				});
			}
			catch (System.DmlException ex) {
				System.assert(ex.getMessage().contains('MISSING_ARGUMENT'));
				exceptionCaught = true;
			}
		}
		Test.stopTest();

		// Assert
		System.assert(exceptionCaught);
	}

	// Upsert Tests -------------------------------------------------------------------------------------------------

	@IsTest public static void testDoUpsertShouldReturnAppropriateWrappedResult() {
		// Arrange
		Account testAccount = new Account();
		XAP_DAO_DML_OperationModeEnum testOperationMode = XAP_DAO_DML_OperationModeEnum.BEST_EFFORT;

		// Act
		XAP_DAO_DML_UpsertResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doUpsert(new List<Account>{
					testAccount
			}, testOperationMode);
		}
		Test.stopTest();

		// Assert
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(null, resultWrapper.getId());
		System.assertEquals(false, resultWrapper.isSuccess());
		System.assertEquals(1, resultWrapper.getErrorList().size());
	}

	@IsTest public static void testDoUpsertShouldBeAllOrNoneByDefault() {
		// Arrange
		Account testAccount = new Account();

		// Act
		Boolean exceptionCaught = false;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			try {
				DML_HANDLER.doUpsert(new List<Account>{
						testAccount
				});
			}
			catch (System.DmlException ex) {
				System.assert(ex.getMessage().contains('REQUIRED_FIELD_MISSING'));
				exceptionCaught = true;
			}
		}
		Test.stopTest();

		// Assert
		System.assert(exceptionCaught);
	}

	@IsTest public static void testDoUpsertShouldReturnNullWhenProvidedEmptyList() {
		// Arrange
		XAP_DAO_DML_OperationModeEnum testOperationMode = XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE;

		// Act
		XAP_DAO_DML_UpsertResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doUpsert(new List<Account>{
			}, testOperationMode);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(null, resultListWrapper);
	}

	@IsTest public static void testDoUpsertShouldReturnNullWhenProvidedWithNull() {
		// Arrange
		XAP_DAO_DML_OperationModeEnum testOperationMode = XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE;

		// Act
		XAP_DAO_DML_UpsertResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doUpsert(null, testOperationMode);
		}
		Test.stopTest();

		// Assert
		System.assertEquals(null, resultListWrapper);
	}

	// Delete Tests -------------------------------------------------------------------------------------------------
	// Note: I would have prefered to test a failing operation, but Database.delete only handles DMLExceptions.
	// 			Anything I could think to do to sabotage the deletion set off a different Exception.
	//			Maybe if we set two objects with a master-detail relationship, deleting the master might fail in a desired way...
	//			But I don't want to manipulate the org to make this test...

	@IsTest public static void testDoDeleteShouldReturnAppropriateWrappedResult() {
		// Arrange
		Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supply();
		Id testAccountId = testAccount.Id;
		XAP_DAO_DML_OperationModeEnum testOperationMode = XAP_DAO_DML_OperationModeEnum.BEST_EFFORT;

		// Act
		XAP_DAO_DML_DeleteResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doDelete(new List<Account>{
					testAccount
			}, testOperationMode);
		}
		Test.stopTest();

		// Assert
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(testAccountId, resultWrapper.getId());
		System.assertEquals(true, resultWrapper.isSuccess());
		System.assert(resultWrapper.getErrorList().isEmpty());
	}

	@IsTest public static void testDoDeleteShouldBeShouldReturnAppropriateWrappedResultByDefault() {
		// Arrange
		Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supply();
		Id testAccountId = testAccount.Id;

		// Act
		XAP_DAO_DML_DeleteResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doDelete(new List<Account>{
					testAccount
			});
		}
		Test.stopTest();

		// Assert
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(testAccountId, resultWrapper.getId());
		System.assertEquals(true, resultWrapper.isSuccess());
		System.assert(resultWrapper.getErrorList().isEmpty());
	}

	// Undelete Tests -------------------------------------------------------------------------------------------------
	// Note: I would have prefered to test a failing operation, but I'm not aware of any condition which would prevent undelete.
	//		Maybe if the object to be deleted needs a unique value which has subsequently been taken?
	//		But I don't want to manipulate the org to make this test...

	@IsTest public static void testDoUndeleteShouldReturnAppropriateWrappedResult() {
		// Arrange
		Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supply();
		Id testAccountId = testAccount.Id;
		delete (testAccount);
		XAP_DAO_DML_OperationModeEnum testOperationMode = XAP_DAO_DML_OperationModeEnum.BEST_EFFORT;

		// Act
		XAP_DAO_DML_UndeleteResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doUndelete(new List<Account>{
					testAccount
			}, testOperationMode);
		}
		Test.stopTest();

		// Assert
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(testAccountId, resultWrapper.getId());
		System.assertEquals(true, resultWrapper.isSuccess());
		System.assert(resultWrapper.getErrorList().isEmpty());
	}

	@IsTest public static void testDoUndeleteShouldBeAllOrNoneByDefault() {
		// Arrange
		Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
				.setInsertMode(XFTY_InsertModeEnum.NOW)
				.supply();
		Id testAccountId = testAccount.Id;
		delete (testAccount);

		// Act
		XAP_DAO_DML_UndeleteResultListWrapper resultListWrapper;
		Test.startTest();
		System.runAs(TEST_RUNNER) {
			resultListWrapper = DML_HANDLER.doUndelete(new List<Account>{
					testAccount
			});
		}
		Test.stopTest();

		// Assert
		List<XAP_DAO_DML_ResultWrapperIntf> resultWrapperList = resultListWrapper.getResultWrapperList();
		System.assertEquals(1, resultWrapperList.size());

		XAP_DAO_DML_ResultWrapperIntf resultWrapper = resultWrapperList[0];
		System.assertEquals(testAccountId, resultWrapper.getId());
		System.assertEquals(true, resultWrapper.isSuccess());
		System.assert(resultWrapper.getErrorList().isEmpty());
	}
}