@IsTest
public class XAP_DAO_TRANS_MultiDmlOpProcessIntTest {
    private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final XAP_DAO_TRANS_MultiDmlOperationProcessor PROCESSOR_UNDER_TEST
            = XAP_DAO_TRANS_MultiDmlOperationProcessor.getInstance();

    private static final List<Account> TEST_ACCOUNT_LIST = (List<Account>) new XFTY_DummySObjectSupplier(Account.SObjectType)
            .setInclusivity(XFTY_InsertInclusivityEnum.REQUIRED)
            .setInsertMode(XFTY_InsertModeEnum.RELATED_ONLY)
            .supplyList();

    private static final List<Case> TEST_CASE_LIST = (List<Case>) new XFTY_DummySObjectSupplier(Case.SObjectType)
            .setInclusivity(XFTY_InsertInclusivityEnum.REQUIRED)
            .setInsertMode(XFTY_InsertModeEnum.RELATED_ONLY)
            .supplyList();

    private static final String TEST_CASE_SUBJECT = 'Stock availability';

    @IsTest public static void testProcessShouldPerformSingleDmlOperationsCorrectly() {
        // Arrange
        List<Account> testAccountList = TEST_ACCOUNT_LIST.deepClone(true, true, true);
        List<XAP_DAO_TRANS_DmlOperationIntf> testOperationList = new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new XAP_DAO_TRANS_SimpleInserter(testAccountList)
        };

        // Act
        XAP_DAO_TRANS_DmlResultIntf result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = PROCESSOR_UNDER_TEST.process(testOperationList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.PERFECT, result.getSuccessLevel());
        assertAccountsSaved(testAccountList);
    }

    @IsTest public static void testProcessShouldPerformMultipleDmlOperationsCorrectly() {
        // Arrange
        List<Account> testAccountList = TEST_ACCOUNT_LIST.deepClone(true, true, true);
        List<Case> testCaseList = insertClonedTestCaseList();
        Case testCase = assignChatReasonToFirstCase(testCaseList);

        List<XAP_DAO_TRANS_DmlOperationIntf> testOperationList = new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new XAP_DAO_TRANS_SimpleInserter(testAccountList),
                new XAP_DAO_TRANS_SimpleUpdater(testCaseList)
        };

        // Act
        XAP_DAO_TRANS_DmlResultIntf result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = PROCESSOR_UNDER_TEST.process(testOperationList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.PERFECT, result.getSuccessLevel());
        assertAccountsSaved(testAccountList);
        assertCasesSaved(testCase);
    }

    @IsTest public static void testProcessShouldCatchArbitraryExceptionsRollbackAndReturnFailure() {
        // Arrange
        List<Account> testAccountList = TEST_ACCOUNT_LIST.deepClone(true, true, true);
        List<Case> testCaseList = insertClonedTestCaseList();
        assignChatReasonToFirstCase(testCaseList);

        List<XAP_DAO_TRANS_DmlOperationIntf> testOperationList = new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new XAP_DAO_TRANS_SimpleInserter(testAccountList),
                new XAP_DAO_TRANS_SimpleUpdater(testCaseList),
                new ArbitraryFailer()
        };

        // Act
        XAP_DAO_TRANS_DmlResultIntf result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = PROCESSOR_UNDER_TEST.process(testOperationList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.NONE, result.getSuccessLevel());
        assertAccountsUnsaved(testAccountList);
        assertCasesUnsaved(testCaseList);
    }

    @IsTest public static void testProcessShouldReturnRollbackAndReturnFailureWhenFirstTransactionFails() {
        // Arrange
        List<Account> testAccountList = TEST_ACCOUNT_LIST.deepClone(true, true, true);
        Account testAccount = testAccountList[0];
        testAccount.Name = '';

        List<Case> testCaseList = insertClonedTestCaseList();
        assignChatReasonToFirstCase(testCaseList);

        List<XAP_DAO_TRANS_DmlOperationIntf> testOperationList = new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new XAP_DAO_TRANS_SimpleInserter(testAccountList),
                new XAP_DAO_TRANS_SimpleUpdater(testCaseList)
        };

        // Act
        XAP_DAO_TRANS_DmlResultIntf result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = PROCESSOR_UNDER_TEST.process(testOperationList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.NONE, result.getSuccessLevel());
        assertAccountsUnsaved(testAccountList);
        assertCasesUnsaved(testCaseList);
    }

    @IsTest public static void testProcessShouldReturnRollbackAndReturnFailureWhenSecondTransactionFails() {
        // Arrange
        List<Account> testAccountList = TEST_ACCOUNT_LIST.deepClone(true, true, true);
        List<Case> testCaseList = insertClonedTestCaseList();
        assignChatReasonToFirstCase(testCaseList);

        List<XAP_DAO_TRANS_DmlOperationIntf> testOperationList = new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new XAP_DAO_TRANS_SimpleInserter(testAccountList),
                new XAP_DAO_TRANS_SimpleInserter(testCaseList)
        };

        // Act
        XAP_DAO_TRANS_DmlResultIntf result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = PROCESSOR_UNDER_TEST.process(testOperationList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.NONE, result.getSuccessLevel());
        assertAccountsUnsaved(testAccountList);
        assertCasesUnsaved(testCaseList);
    }

    @IsTest public static void testProcessShouldReturnRollbackAndReturnFailureWhenOnlyPartialSuccess() {
        // Arrange
        List<Account> testAccountList = TEST_ACCOUNT_LIST.deepClone(true, true, true);
        testAccountList.add(new Account());

        List<Case> testCaseList = insertClonedTestCaseList();
        assignChatReasonToFirstCase(testCaseList);

        List<XAP_DAO_TRANS_DmlOperationIntf> testOperationList = new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new XAP_DAO_TRANS_SimpleInserter(testAccountList)
                        .setOperationalMode(XAP_DAO_DML_OperationModeEnum.BEST_EFFORT),
                new XAP_DAO_TRANS_SimpleUpdater(testCaseList)
        };

        // Act
        XAP_DAO_TRANS_DmlResultIntf result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = PROCESSOR_UNDER_TEST.process(testOperationList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.NONE, result.getSuccessLevel());
        assertAccountsUnsaved(testAccountList);
        assertCasesUnsaved(testCaseList);
    }

    @IsTest public static void testProcessShouldReturnRollbackAndReturnSuccessWhenOnlyPartialSuccessButPartialSuccessEnabled() {
        // Arrange
        List<Account> testAccountList = TEST_ACCOUNT_LIST.deepClone(true, true, true);
        testAccountList.add(new Account());

        List<Case> testCaseList = insertClonedTestCaseList();
        Case testCase = assignChatReasonToFirstCase(testCaseList);

        List<XAP_DAO_TRANS_DmlOperationIntf> testOperationList = new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new XAP_DAO_TRANS_SimpleInserter(testAccountList)
                        .setOperationalMode(XAP_DAO_DML_OperationModeEnum.BEST_EFFORT),
                new XAP_DAO_TRANS_SimpleUpdater(testCaseList)
        };

        PROCESSOR_UNDER_TEST.enablePartialSuccess();

        // Act
        XAP_DAO_TRANS_DmlResultIntf result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = PROCESSOR_UNDER_TEST.process(testOperationList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(XAP_DAO_DML_SuccessLevelEnum.PARTIAL, result.getSuccessLevel());
        assertAccountsSaved(testAccountList);
        assertCasesSaved(testCase);
    }

    private static List<Case> insertClonedTestCaseList() {
        List<Case> testCaseList = TEST_CASE_LIST.deepClone(true, true, true);
        insert testCaseList;
        return testCaseList;
    }

    private static Case assignChatReasonToFirstCase(List<Case> testCaseList) {
        Case testCase = testCaseList[0];
        testCase.Subject = TEST_CASE_SUBJECT;
        return testCase;
    }

    private static void assertAccountsSaved(List<Account> testAccountList) {
        System.assertNotEquals(null, testAccountList[0].Id);
    }


    private static void assertAccountsUnsaved(List<Account> testAccountList) {
        List<Account> resultAccountList = [
                SELECT Id
                FROM Account
                WHERE Id IN :testAccountList
        ];
        System.assert(resultAccountList.isEmpty());
    }

    private static void assertCasesSaved(Case testCase) {
        Case resultCase = [
                SELECT Subject
                FROM Case
                WHERE Id = :testCase.Id
        ][0];
        System.assertEquals(TEST_CASE_SUBJECT, resultCase.Subject);
    }

    private static void assertCasesUnsaved(List<Case> testCaseList) {
        List<Case> resultCaseList = [
                SELECT Subject
                FROM Case
                WHERE Id IN :testCaseList
        ];
        System.assertEquals(null, resultCaseList[0].Subject);
    }


    private class ArbitraryFailer implements XAP_DAO_TRANS_DmlOperationIntf {
        public XAP_DAO_TRANS_DmlResultIntf doDml(
                Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> prerequisiteSObjectsByKeyMap
        ) {
            throw new TestException('Expected Exception');
        }
    }

    private class TestException extends Exception {
    }
}
