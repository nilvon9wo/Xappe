/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see: https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/XAP_DAO_SOQL_SecurityUtilsTest.cls
 */
@IsTest
private class XAP_DAO_SOQL_SecurityUtilsTest {
    private static final XAP_DAO_SOQL_SecurityUtils UTIL_UNDER_TEST = XAP_DAO_SOQL_SecurityUtils.getInstance();

    static User setupTestUser(String profileName) {
        //username global uniqueness is still enforced in tests 
        //make sure we get something unique to avoid issues with parallel tests
        String uniqueness = Datetime.now() + ':' + Math.random();
        try {
            throw new NullPointerException();
        }
        catch (Exception e) {
            uniqueness += e.getStackTraceString(); //includes the top level test method name without having to pass it
        }
        Profile p = [SELECT Id, Name FROM Profile WHERE Name = :profileName];
        User result = new User(
                Username = UserInfo.getUserId() + '.' + uniqueness.hashCode()
                        + '@' + UserInfo.getOrganizationId() + '.sfdcOrg',
                Alias = 'testExec',
                Email = 'apextests@example.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Testing',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert result;
        return result;
    }

    @IsTest
    static void readonly_field_access() {
        User testUser = setupTestUser('Read Only');
        System.runAs(testUser) {
            {
                XAP_DAO_SOQL_SObjectReadException ex;
                try {
                    UTIL_UNDER_TEST.checkFieldIsReadable(Contact.SObjectType, 'LastNAME');
                }
                catch (XAP_DAO_SOQL_SObjectReadException e) {
                    ex = e;
                }
                System.assertEquals(null, ex, 'Read only profile should be able to read Contact.LastName');
            }

            XAP_DAO_SOQL_SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
            { //no exceptions, despite no rights
                UTIL_UNDER_TEST.checkFieldIsReadable(Contact.SObjectType, 'LastNAME');
            }
        }
    }

    @IsTest
    static void readonly_object_access() {
        User testUser = setupTestUser('Read Only');
        System.runAs(testUser) {
            {
                XAP_DAO_SOQL_SObjectReadException ex;
                try {
                    UTIL_UNDER_TEST.checkObjectIsReadable(Contact.SObjectType);
                }
                catch (XAP_DAO_SOQL_SObjectReadException e) {
                    ex = e;
                }
                System.assertEquals(null, ex, 'Read only profile should be able to read Contact');
            }

            XAP_DAO_SOQL_SecurityUtils.BYPASS_INTERNAL_FLS_AND_CRUD = true;
            { //no exceptions, despite no rights
                UTIL_UNDER_TEST.checkObjectIsReadable(Contact.SObjectType);
            }
        }
    }
}