@IsTest
public with sharing class XAP_DAO_ApexEmailNotificationSelIntTest {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final XAP_DAO_ApexEmailNotificationSelector SELECTOR_UNDER_TEST
            = XAP_DAO_ApexEmailNotificationSelector.getInstance();

    @IsTest
    public static void testSelectAllYieldsSameResultAsCurrentOrg() {
        // Arrange : Nothing to do here
        // We can't perform any DML on ApexEmailNotification,
        // so we can't control the data which is selected.

        // Act
        List<ApexEmailNotification> resultList;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultList = SELECTOR_UNDER_TEST.selectAll();
        }
        Test.stopTest();

        // Assert
        List<ApexEmailNotification> expectedList = [
                SELECT Id
                FROM ApexEmailNotification
        ];
        System.assertEquals(expectedList.size(), resultList.size());
    }
}