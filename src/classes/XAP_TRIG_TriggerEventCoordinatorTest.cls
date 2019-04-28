@IsTest
public with sharing class XAP_TRIG_TriggerEventCoordinatorTest {
    private static final User TEST_USER = TEST_DummyUserFactoryOutlet.TEST_ADMIN_USER;

    private static final XAP_TRIG_TriggerEventCoordinator COORDINATOR_UNDER_TEST = createMockTriggerEventCoordinator();

    private static final XAP_TRIG_TriggerSetting__c TEST_TRIGGER_SETTINGS
            = (XAP_TRIG_TriggerSetting__c) new XFTY_DummySObjectSupplier(XAP_TRIG_TriggerSetting__c.SObjectType)
                    .supply();

    private static final SObjectType TEST_SOBJECT_TYPE = Account.SObjectType;
    private static final System.TriggerOperation TEST_OPERATION = System.TriggerOperation.BEFORE_INSERT;
    private static final XAP_TRIG_TriggerWrapper TEST_TRIGGER_WRAPPER = createTriggerWrapper();

    // isExecutable tests --------------------------------------------------------------------------------------------

    @IsTest public static void isExecutableReturnsTrueIfEnabledForProfileAndEnabledForSObjectAndNotInProgress() {
        // Arrange
        // Nothing to do here

        // Act
        Boolean result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = COORDINATOR_UNDER_TEST.isExecutable(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assert(result);
    }

    @IsTest public static void isExecutableReturnsFalseIfEnabledForProfileAndEnabledForSObjectButInProgress() {
        // Arrange
        XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(
                TEST_TRIGGER_WRAPPER.sObjectType, new Set<System.TriggerOperation>{
                        TEST_TRIGGER_WRAPPER.operationType
                }
        );

        // Act
        Boolean result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = COORDINATOR_UNDER_TEST.isExecutable(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assert(!result);
    }

    @IsTest public static void isExecutableReturnsTrueIfEnabledForProfileAndNotInProgressButNotEnabledForSObject() {
        // Arrange
        XAP_TRIG_TriggerEventCoordinator.IS_ENABLED_BY_SOBJECT_TYPE_MAP = new Map<SObjectType, Boolean>{
                TEST_SOBJECT_TYPE => false
        };

        // Act
        Boolean result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = COORDINATOR_UNDER_TEST.isExecutable(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assert(!result);
    }

    @IsTest public static void isExecutableReturnsTrueIfEnabledForSObjectAndNotInProgressButNotEnabledForProfile() {
        // Arrange
        XAP_TRIG_TriggerSettingSelectorMock mockTriggerSettingSelector = new XAP_TRIG_TriggerSettingSelectorMock();
        TEST_TRIGGER_SETTINGS.TriggersEnabled__c = false;
        mockTriggerSettingSelector.returnedTriggerSetting = TEST_TRIGGER_SETTINGS;
        XAP_TRIG_SObjectTypeOperationConvertor sObjectTypeOperationHelper = new XAP_TRIG_SObjectTypeOperationConvertor();
        XAP_TRIG_TriggerEventCoordinator coordinatorUnderTest
                = new XAP_TRIG_TriggerEventCoordinator(sObjectTypeOperationHelper, mockTriggerSettingSelector);

        // Act
        Boolean result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = coordinatorUnderTest.isExecutable(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assert(!result);
    }

    // isEnabledForProfile tests --------------------------------------------------------------------------------------------

    @IsTest public static void isEnabledForProfileShouldReturnValueFromAutomationSetting() {
        // Arrange
        // Nothing to do here

        // Act
        Boolean result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = COORDINATOR_UNDER_TEST.isEnabledForProfile();
        }
        Test.stopTest();

        // Assert
        Boolean expectedResult = TEST_DummyXapTriggerSettingFactoryOutlet.DEFAULT_TRIGGER_ENABLED;
        System.assertEquals(expectedResult, result);
    }

    // isEnabledForSObject tests --------------------------------------------------------------------------------------------


    @IsTest public static void isEnabledForSObjectShouldReturnEnabledValueFromAutomationSetting() {
        // Arrange
        // Nothing to do here

        // Act
        Boolean result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = COORDINATOR_UNDER_TEST.isEnabledForSObject(TEST_SOBJECT_TYPE);
        }
        Test.stopTest();

        // Assert
        Boolean expectedResult = TEST_DummyXapTriggerSettingFactoryOutlet.DEFAULT_ACCOUNT_TRIGGER_ENABLED;
        System.assertEquals(expectedResult, result);
    }

    @IsTest public static void isEnabledForSObjectShouldReturnTrueForUnmappedSObjects() {
        // Arrange
        SObjectType unmappedSObjectType = User.SObjectType;

        // Act
        Boolean result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = COORDINATOR_UNDER_TEST.isEnabledForSObject(unmappedSObjectType);
        }
        Test.stopTest();

        // Assert
        Boolean expectedResult = true;
        System.assertEquals(expectedResult, result);
    }

    // buildIsEnabledBySObjectTypeMap tests --------------------------------------------------------------------------------------------

    @IsTest public static void testBuidIsEnabledBySObjectTypeMapShouldReturnMapFromAutomationSettings() {
        // Arrange
        // Nothing to do here

        // Act
        Map<SObjectType, Boolean> resultIsEnabledBySObjectTypeMap;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultIsEnabledBySObjectTypeMap = COORDINATOR_UNDER_TEST.buildIsEnabledBySObjectTypeMap();
        }
        Test.stopTest();

        // Assert
        System.assert(resultIsEnabledBySObjectTypeMap.get(Contact.SObjectType));
        System.assert(resultIsEnabledBySObjectTypeMap.get(User.SObjectType));
    }

    // isNotAlreadyInProgress tests --------------------------------------------------------------------------------------------

    @IsTest public static void testIsNotAlreadyInProgressShouldReteurnTrueWhenNotContainedInProgressSet() {
        // Arrange
        XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.remove(TEST_TRIGGER_WRAPPER.sObjectType);

        // Act
        Boolean resultValue;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultValue = COORDINATOR_UNDER_TEST.isNotAlreadyInProgress(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assert(resultValue);
    }

    @IsTest public static void testIsNotAlreadyInProgressShouldReteurnFalseWhenIsContainedInProgressSet() {
        // Arrange
        XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(
                TEST_TRIGGER_WRAPPER.sObjectType, new Set<System.TriggerOperation>{
                        TEST_TRIGGER_WRAPPER.operationType
                }
        );

        // Act
        Boolean resultValue;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultValue = COORDINATOR_UNDER_TEST.isNotAlreadyInProgress(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assert(!resultValue);
    }


    // addToInProgress tests --------------------------------------------------------------------------------------------

    @IsTest public static void testAddToInProgressShouldAddSpecifiedTypeToInProgressSet() {
        // Arrange
        XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.remove(TEST_TRIGGER_WRAPPER.sObjectType);

        // Act
        Map<SObjectType, Set<System.TriggerOperation>> resultOperationSetBySObjectMap;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultOperationSetBySObjectMap = COORDINATOR_UNDER_TEST.addToInProgress(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(
                XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP, resultOperationSetBySObjectMap
        );
        System.assert(resultOperationSetBySObjectMap.get(TEST_SOBJECT_TYPE) != null);
    }

    // removeFromInProgress tests --------------------------------------------------------------------------------------------

    @IsTest public static void testRemoveFromInProgressShouldRemoveSpecifiedTypeToInProgressSet() {
        // Arrange
        XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(
                TEST_TRIGGER_WRAPPER.sObjectType, new Set<System.TriggerOperation>{
                        TEST_TRIGGER_WRAPPER.operationType
                }
        );
        XAP_TRIG_TriggerEventCoordinator.TRIGGER_IN_PROGRESS_LIST.add(TEST_TRIGGER_WRAPPER);

        // Act
        Map<SObjectType, Set<System.TriggerOperation>> resultOperationSetBySObjectMap;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultOperationSetBySObjectMap = COORDINATOR_UNDER_TEST.removeFromInProgress(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        Set<System.TriggerOperation> resultOperationSet
                = XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(TEST_SOBJECT_TYPE);
        System.assertEquals(null, resultOperationSet);
    }

    @IsTest public static void testRemoveFromInProgressShouldRemoveOnlySpecifiedTypeToInProgressSet() {
        // Arrange
        System.TriggerOperation otherOperation = System.TriggerOperation.AFTER_UNDELETE;
        Set<System.TriggerOperation> operationSet = new Set<System.TriggerOperation>{
                TEST_TRIGGER_WRAPPER.operationType, otherOperation
        };
        XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(
                TEST_TRIGGER_WRAPPER.sObjectType, operationSet
        );
        XAP_TRIG_TriggerEventCoordinator.TRIGGER_IN_PROGRESS_LIST.add(TEST_TRIGGER_WRAPPER);

        // Act
        Map<SObjectType, Set<System.TriggerOperation>> resultOperationSetBySObjectMap;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultOperationSetBySObjectMap = COORDINATOR_UNDER_TEST.removeFromInProgress(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        Set<System.TriggerOperation> resultOperationSet
                = XAP_TRIG_TriggerEventCoordinator.OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(TEST_SOBJECT_TYPE);
        System.assertNotEquals(null, resultOperationSet);
        System.assert(!resultOperationSet.contains(TEST_OPERATION));
        System.assert(resultOperationSet.contains(otherOperation));
    }

    // returnValueOrTrue tests --------------------------------------------------------------------------------------------

    @IsTest public static void testReturnValueOrTrueShouldReturnTrueIfValueTrue() {
        // Arrange
        Boolean testValue = true;

        // Act
        Boolean resultValue;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultValue = COORDINATOR_UNDER_TEST.returnValueOrTrue(testValue);
        }
        Test.stopTest();

        // Assert
        System.assert(resultValue);
    }

    @IsTest public static void testReturnValueOrTrueShouldReturnFalseIfValueFalse() {
        // Arrange
        Boolean testValue = false;

        // Act
        Boolean resultValue;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultValue = COORDINATOR_UNDER_TEST.returnValueOrTrue(testValue);
        }
        Test.stopTest();

        // Assert
        System.assert(!resultValue);
    }

    @IsTest public static void testReturnValueOrTrueShouldReturnTrueIfTValueNull() {
        // Arrange
        Boolean testValue = null;

        // Act
        Boolean resultValue;
        Test.startTest();
        System.runAs(TEST_USER) {
            resultValue = COORDINATOR_UNDER_TEST.returnValueOrTrue(testValue);
        }
        Test.stopTest();

        // Assert
        System.assert(resultValue);
    }

    // findInProgressIndex tests ------------------------------------------------------------------------------------------------------

    @IsTest public static void testFindInProgressIndexShouldReturnNegativeOneIfTriggerNotFound() {
        // Arrange : Nothing to do here

        // Act
        Integer result;
        Test.startTest();
        System.runAs(TEST_USER) {
            result = COORDINATOR_UNDER_TEST.findInProgressIndex(TEST_TRIGGER_WRAPPER);
        }
        Test.stopTest();

        // Assert
        System.assertEquals(-1, result);
    }


    // Helpers ------------------------------------------------------------------------------------------------------

    private static XAP_TRIG_TriggerWrapper createTriggerWrapper() {
        XAP_TRIG_TriggerWrapper testTriggerWrapper = new XAP_TRIG_TriggerWrapper();
        testTriggerWrapper.sObjectType = TEST_SOBJECT_TYPE;
        testTriggerWrapper.operationType = TEST_OPERATION;
        return testTriggerWrapper;
    }

    private static XAP_TRIG_TriggerEventCoordinator createMockTriggerEventCoordinator() {
        XAP_TRIG_TriggerSettingSelectorMock mockAutomationSettingSelector = new XAP_TRIG_TriggerSettingSelectorMock();
        mockAutomationSettingSelector.returnedTriggerSetting = TEST_TRIGGER_SETTINGS;
        XAP_TRIG_SObjectTypeOperationConvertor sObjectTypeOperationHelper = new XAP_TRIG_SObjectTypeOperationConvertor();
        return new XAP_TRIG_TriggerEventCoordinator(sObjectTypeOperationHelper, mockAutomationSettingSelector);
    }
}