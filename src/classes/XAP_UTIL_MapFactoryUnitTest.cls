@IsTest
public class XAP_UTIL_MapFactoryUnitTest {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;
    private static final XAP_UTIL_MapFactory MAP_FACTORY_UNDER_TEST = XAP_UTIL_MapFactory.getInstance();

    private static final Case TEST_RMA_CASE
            = (Case) (new XFTY_DummySObjectSupplier(Case.SObjectType))
                    .setInclusivity(XFTY_InsertInclusivityEnum.REQUIRED)
                    .setInsertMode(XFTY_InsertModeEnum.MOCK)
                    .supply();

    private static final Case TEST_RMA_CASE_NEW
            = (Case) (new XFTY_DummySObjectSupplier(Case.SObjectType))
                    .setOverrideTemplate(new Case(
                            AccountId = TEST_RMA_CASE.AccountId
                    ))
                    .setInclusivity(XFTY_InsertInclusivityEnum.REQUIRED)
                    .setInsertMode(XFTY_InsertModeEnum.MOCK)
                    .supply();

    private static final List<String> IDENTIFIERS = new List<String>{
            'first',
            'second',
            'third'
    };

    private static final List<Contact> TEST_CONTACTS = new List<Contact>{
            new Contact(FirstName = IDENTIFIERS[0]),
            new Contact(LastName = IDENTIFIERS[1]),
            new Contact(Email = IDENTIFIERS[2])
    };

    private static final Set<SObjectField> TEST_CONTACT_IDENTIFIER_FIELDS = new Set<SObjectField>{
            Contact.FirstName,
            Contact.LastName,
            Contact.Email
    };


    @IsTest
    static void testMapLastQualifiedSObjectByNonUniqueSpecifiedFieldsShouldReturnSobjectBySpecifiedFieldsMap() {
        //Arrange
        Case caseWithReadOnlyField = (Case) TEST_ReadOnlyHelper.setReadOnlyField(
                TEST_RMA_CASE,
                new Map<Schema.SObjectField, Object>{
                        Case.CaseNumber => '10002344',
                        Case.Subject => 'R0009872'
                }
        );
        List<Case> caseList = new List<Case>{
                caseWithReadOnlyField
        };
        Set<SObjectField> sObjFieldSet = new Set<SObjectField>{
                Case.CaseNumber,
                Case.Subject
        };

        //Act
        Map<String, SObject> resultMapByUniqueSpecifiedFields;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultMapByUniqueSpecifiedFields
                    = MAP_FACTORY_UNDER_TEST.mapLastQualifiedSObjectByNonuniqueSpecifiedFields(
                    caseList,
                    sObjFieldSet
            );
        }

        //Assert
        System.assert(!resultMapByUniqueSpecifiedFields.isEmpty());
        System.assert(resultMapByUniqueSpecifiedFields.containsKey(caseWithReadOnlyField.CaseNumber));
        System.assert(resultMapByUniqueSpecifiedFields.containsKey(caseWithReadOnlyField.Subject));
    }

    @IsTest
    static void testMapByUniqueSpecifiedIdFieldShouldReturnSobjectBySpecifiedFieldsMap() {
        //Arrange
        List<Case> caseList = new List<Case>{
                TEST_RMA_CASE
        };

        //Act
        Map<Id, SObject> resultMapByUniqueSpecifiedIdField;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultMapByUniqueSpecifiedIdField
                    = MAP_FACTORY_UNDER_TEST.mapByUniqueSpecifiedIdField(
                    caseList,
                    Case.AccountId
            );
        }

        //Assert
        System.assert(!resultMapByUniqueSpecifiedIdField.isEmpty());
        System.assert(resultMapByUniqueSpecifiedIdField.containsKey(TEST_RMA_CASE.AccountId));
    }

    @IsTest
    static void testMapByUniqueSpecifiedIdFieldWithDuplicateValueForKeyShouldReturnException() {
        //Arrange
        List<Case> caseList = new List<Case>{
                TEST_RMA_CASE,
                TEST_RMA_CASE_NEW
        };

        //Act
        XAP_UTIL_MapManyToOneException resultMapManyToOneException;
        Test.startTest();
        System.runAs(TEST_USER) {
            try {
                MAP_FACTORY_UNDER_TEST.mapByUniqueSpecifiedIdField(
                        caseList,
                        Case.AccountId
                );
            } catch (XAP_UTIL_MapManyToOneException mapManyToOneException) {
                resultMapManyToOneException = mapManyToOneException;
            }

        }

        //Assert
        System.assert(String.isNotEmpty(resultMapManyToOneException.getMessage()));
    }

    @IsTest
    static void testMapBySpecifiedIdFieldShouldReturnListOfSobjectBySpecifiedIdField() {
        //Arrange
        List<Case> caseList = new List<Case>{
                TEST_RMA_CASE
        };

        //Act
        Map<Id, List<SObject>> resultMapByUniqueSpecifiedIdField;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultMapByUniqueSpecifiedIdField
                    = MAP_FACTORY_UNDER_TEST.mapBySpecifiedIdField(
                    caseList,
                    Case.AccountId
            );
        }

        //Assert
        System.assert(!resultMapByUniqueSpecifiedIdField.isEmpty());
        System.assert(resultMapByUniqueSpecifiedIdField.containsKey(TEST_RMA_CASE.AccountId));
        System.assertEquals(caseList, resultMapByUniqueSpecifiedIdField.get(TEST_RMA_CASE.AccountId));
    }

    @IsTest
    public static void testMapLastQualifiedSObjectByNonuniqueSpecifiedFields() {
        //Arrange
        Map<String, SObject> resultSobjectByString;

        //Act
        System.runAs(TEST_USER) {
            Test.startTest();
            resultSobjectByString = MAP_FACTORY_UNDER_TEST.mapLastQualifiedSObjectByNonuniqueSpecifiedFields(
                    TEST_CONTACTS, TEST_CONTACT_IDENTIFIER_FIELDS
            );
            Test.stopTest();
        }

        //Assert
        System.assertEquals(TEST_CONTACTS[0], resultSobjectByString.get(IDENTIFIERS[0]));
        System.assertEquals(TEST_CONTACTS[1], resultSobjectByString.get(IDENTIFIERS[1]));
        System.assertEquals(TEST_CONTACTS[2], resultSobjectByString.get(IDENTIFIERS[2]));
    }

    @IsTest
    public static void testMapLastQualifiedSObjectByNonuniqueSpecifiedFieldsShouldReturnNullWhenEmptyList() {
        //Arrange
        Map<String, SObject> resultSobjectByString;

        //Act
        System.runAs(TEST_USER) {
            Test.startTest();
            resultSobjectByString = MAP_FACTORY_UNDER_TEST.mapLastQualifiedSObjectByNonuniqueSpecifiedFields(
                    new List<Contact>(), TEST_CONTACT_IDENTIFIER_FIELDS
            );
            Test.stopTest();
        }

        //Assert
        System.assertEquals(null, resultSobjectByString);
    }

    @IsTest
    public static void testMapLastQualifiedSObjectByNonuniqueSpecifiedFieldsDuplicateValuesCheck() {
        //Arrange
        TEST_CONTACTS[1].LastName = IDENTIFIERS[0];
        Map<String, SObject> resultSobjectByString;

        //Act
        System.runAs(TEST_USER) {
            Test.startTest();
            resultSobjectByString = MAP_FACTORY_UNDER_TEST.mapLastQualifiedSObjectByNonuniqueSpecifiedFields(
                    TEST_CONTACTS, TEST_CONTACT_IDENTIFIER_FIELDS
            );
            Test.stopTest();
        }

        //Assert
        System.assert(!resultSobjectByString.containsKey(IDENTIFIERS[1]));
        System.assertEquals(TEST_CONTACTS[1], resultSobjectByString.get(IDENTIFIERS[0]));
        System.assertEquals(TEST_CONTACTS[2], resultSobjectByString.get(IDENTIFIERS[2]));
    }
}