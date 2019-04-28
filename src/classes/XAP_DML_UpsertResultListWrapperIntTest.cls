@IsTest
public class XAP_DML_UpsertResultListWrapperIntTest {
    private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

    @IsTest public static void testGetResultWrapperListShouldReturnListWithExpectedProperties() {
        // Arrange
        Account testAccount = (Account) (new XFTY_DummySObjectSupplier(Account.SObjectType))
                .setInsertMode(XFTY_InsertModeEnum.LATER)
                .supply();
        Boolean notAllOrNone = false;
        Database.UpsertResult testUpsertResult = Database.upsert(testAccount, notAllOrNone);
        List<Database.UpsertResult> testUpsertResultList = new List<Database.UpsertResult>{
                testUpsertResult
        };
        XAP_DML_UpsertResultListWrapper wrapperUnderTest = new XAP_DML_UpsertResultListWrapper(testUpsertResultList);

        // Act
        List<XAP_DML_UpsertResultWrapper> resultWrapperList;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultWrapperList = wrapperUnderTest.getResultWrapperList();
        }
        Test.stopTest();

        // Assert
        System.assertEquals(1, resultWrapperList.size());

        XAP_DML_UpsertResultWrapper resultWrapper = resultWrapperList[0];
        System.assertEquals(testUpsertResult.id, resultWrapper.getId());
        System.assertEquals(testUpsertResult.isCreated(), resultWrapper.wasCreated);
        System.assertEquals(testUpsertResult.isSuccess(), resultWrapper.isSuccess());
        System.assert(resultWrapper.getErrorList().isEmpty());
    }
}