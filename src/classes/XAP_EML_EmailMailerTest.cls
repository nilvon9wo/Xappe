@IsTest
public with sharing class XAP_EML_EmailMailerTest {
    private static final User TEST_RUNNER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final List<User> TEST_USER_LIST = new List<User>{
            TEST_RUNNER
    };

    private static final XAP_DAO_ApexEmailNotificationSelMock MOCK_APEX_EMAIL_NOTIFICATION_SELECTOR
            = new XAP_DAO_ApexEmailNotificationSelMock();
    private static final XAP_EML_EmailMailer MAILER_UNDER_TEST
            = new XAP_EML_EmailMailer(MOCK_APEX_EMAIL_NOTIFICATION_SELECTOR);

    private static final String TEST_EMAIL_ADDRESS = 'test@example.com';
    private static final List<ApexEmailNotification> TEST_APEX_EMAIL_NOTIFICATION_LIST
            = (List<ApexEmailNotification>) new XFTY_DummySObjectSupplier(ApexEmailNotification.SObjectType)
                    .setOverrideTemplateList(new List<ApexEmailNotification>{
                            new ApexEmailNotification(),
                            new ApexEmailNotification(Email = TEST_EMAIL_ADDRESS)
                    })
                    .setInclusivity(XFTY_InsertInclusivityEnum.REQUIRED)
                    .setInsertMode(XFTY_InsertModeEnum.MOCK)
                    .supplyList();
    private static final List<String> TEST_EMAIL_ADDRESS_LIST = new List<String>{
            TEST_EMAIL_ADDRESS
    };

    private static final XAP_EML_EmailAlertableMock TEST_ALERTABLE = new XAP_EML_EmailAlertableMock();
    private static final String TEST_SUBJECT = 'Test subject';
    private static final String TEST_BODY = 'Test body';

    @IsTest
    public static void testBuildRecipientsByTypeMapShouldCreateListsOfUsersAndEmails() {
        // Arrange
        TEST_APEX_EMAIL_NOTIFICATION_LIST[0].User = TEST_RUNNER;
        MOCK_APEX_EMAIL_NOTIFICATION_SELECTOR.returnedApexEmailNotificationList = TEST_APEX_EMAIL_NOTIFICATION_LIST;

        // Act
        Map<Type, List<Object>> resultMap;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultMap = MAILER_UNDER_TEST.buildRecipientsByTypeMap();
        }
        Test.stopTest();

        // Assert
        System.assertEquals(2, resultMap.size());
        System.assert(resultMap.get(User.class).contains(TEST_RUNNER));
        System.assert(resultMap.get(String.class).contains(TEST_EMAIL_ADDRESS));
    }

    @IsTest
    public static void testBuildEmailMessageListShouldCreateEmailAlertsForBothUsersAndArbitraryEmails() {
        // Arrange
        TEST_ALERTABLE.returnedEmailSubject = TEST_SUBJECT;
        TEST_ALERTABLE.returnedEmailBody = TEST_BODY;

        // Act
        List<Messaging.SingleEmailMessage> resultList;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultList = MAILER_UNDER_TEST.buildEmailMessageList(
                    TEST_USER_LIST, TEST_EMAIL_ADDRESS_LIST, TEST_ALERTABLE
            );
        }
        Test.stopTest();

        // Assert
        System.assertEquals(2, resultList.size());

        Messaging.SingleEmailMessage resultUserMessage = resultList[0];
        System.assertEquals(TEST_RUNNER.Id, resultUserMessage.getTargetObjectId());
        assertEmailMessage(resultUserMessage);

        Messaging.SingleEmailMessage resultEmailAddressMessage = resultList[1];
        System.assertEquals(TEST_EMAIL_ADDRESS_LIST, resultEmailAddressMessage.getToAddresses());
        assertEmailMessage(resultEmailAddressMessage);
    }

    @IsTest
    public static void testBuildEmailMessageListShouldCreateEmailAlertsForUsers() {
        // Arrange
        TEST_ALERTABLE.returnedEmailSubject = TEST_SUBJECT;
        TEST_ALERTABLE.returnedEmailBody = TEST_BODY;

        // Act
        List<Messaging.SingleEmailMessage> resultList;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultList = MAILER_UNDER_TEST.buildEmailMessageList(TEST_USER_LIST, TEST_ALERTABLE);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(1, resultList.size());
        Messaging.SingleEmailMessage resultMessage = resultList[0];
        System.assertEquals(TEST_RUNNER.Id, resultMessage.getTargetObjectId());
        assertEmailMessage(resultMessage);
    }

    @IsTest
    public static void testBuildEmailMessageListShouldNotCreateEmailsIfNoUsers() {
        // Arrange
        List<User> emptyUserList = new List<User>();

        // Act
        List<Messaging.SingleEmailMessage> resultList;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultList = MAILER_UNDER_TEST.buildEmailMessageList(emptyUserList, TEST_ALERTABLE);
        }
        Test.stopTest();

        // Assert
        System.assert(resultList.isEmpty());
    }

    @IsTest
    public static void testBuildEmailMessageListShouldCreateEmailAlertsForArbitraryEmails() {
        // Arrange
        TEST_ALERTABLE.returnedEmailSubject = TEST_SUBJECT;
        TEST_ALERTABLE.returnedEmailBody = TEST_BODY;

        // Act
        List<Messaging.SingleEmailMessage> resultList;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultList = MAILER_UNDER_TEST.buildEmailMessageList(TEST_EMAIL_ADDRESS_LIST, TEST_ALERTABLE);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(1, resultList.size());
        Messaging.SingleEmailMessage resultMessage = resultList[0];
        System.assertEquals(TEST_EMAIL_ADDRESS_LIST, resultMessage.getToAddresses());
        assertEmailMessage(resultMessage);
    }

    @IsTest
    public static void testBuildEmailMessageListShouldNotCreateEmailsIfNoArbitraryEmails() {
        // Arrange
        List<String> emptyEmailAddressList = new List<String>();

        // Act
        List<Messaging.SingleEmailMessage> resultList;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            resultList = MAILER_UNDER_TEST.buildEmailMessageList(emptyEmailAddressList, TEST_ALERTABLE);
        }
        Test.stopTest();

        // Assert
        System.assert(resultList.isEmpty());
    }

    @IsTest
    public static void testCreateEmailShouldCreateMessageWithCorrectSubjectAndBody() {
        // Arrange
        TEST_ALERTABLE.returnedEmailSubject = TEST_SUBJECT;
        TEST_ALERTABLE.returnedEmailBody = TEST_BODY;

        // Act
        Messaging.SingleEmailMessage result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = MAILER_UNDER_TEST.createEmail(TEST_ALERTABLE);
        }
        Test.stopTest();

        // Assert
        assertEmailMessage(result);
    }

    @IsTest
    public static void testSendShouldSignifySentMessagesByAugmentingCounter() {
        // Arrange
        Messaging.SingleEmailMessage testMessage = new Messaging.SingleEmailMessage();
        testMessage.setSaveAsActivity(false);
        testMessage.setTargetObjectId(TEST_RUNNER.Id);
        testMessage.setPlainTextBody(TEST_BODY);
        List<Messaging.SingleEmailMessage> testMessageList = new List<Messaging.SingleEmailMessage>{
                testMessage
        };

        // Act
        XAP_EML_SendEmailResultListWrapper result;
        Test.startTest();
        System.runAs(TEST_RUNNER) {
            result = MAILER_UNDER_TEST.send(testMessageList);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(1, XAP_EML_EmailMailer.MESSAGES_SENT_COUNT);
        System.assert(result.sendEmailResults[0].isSuccess());
    }

    private static void assertEmailMessage(Messaging.SingleEmailMessage result) {
        System.assertEquals(TEST_SUBJECT, result.getSubject());
        System.assertEquals(TEST_BODY, result.getPlainTextBody());
    }
}