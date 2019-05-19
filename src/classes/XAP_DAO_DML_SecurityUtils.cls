/**
 * Inspired by and derived from FinancialForce.com's Apex Commons.
 * @see: https://github.com/financialforcedev/fflib-apex-common/blob/master/fflib/src/classes/fflib_SecurityUtils.cls
 */
public class XAP_DAO_DML_SecurityUtils {
    private XAP_DAO_DML_SecurityUtils() {
    }

    private static XAP_DAO_DML_SecurityUtils instance;

    public static XAP_DAO_DML_SecurityUtils getInstance() {
        if (instance == null) {
            instance = new XAP_DAO_DML_SecurityUtils();
        }
        return instance;
    }

    public static Boolean BYPASS_INTERNAL_FLS_AND_CRUD = false;

    public static void checkInsert(SObjectType sObjectType, List<String> fieldNames) {
        checkSObjectIsInsertable(sObjectType);
        for (String fieldName : fieldNames) {
            checkFieldIsInsertable(sObjectType, fieldName);
        }
    }

    public static void checkInsert(SObjectType sObjectType, List<SObjectField> fieldTokens) {
        checkSObjectIsInsertable(sObjectType);
        for (SObjectField fieldToken : fieldTokens) {
            checkFieldIsInsertable(sObjectType, fieldToken);
        }
    }

    public static void checkUpdate(SObjectType sObjectType, List<String> fieldNames) {
        checkSObjectIsUpdateable(sObjectType);
        for (String fieldName : fieldNames) {
            checkFieldIsUpdateable(sObjectType, fieldName);
        }
    }

    public static void checkUpdate(SObjectType sObjectType, List<SObjectField> fieldTokens) {
        checkSObjectIsUpdateable(sObjectType);
        for (SObjectField fieldToken : fieldTokens) {
            checkFieldIsUpdateable(sObjectType, fieldToken);
        }
    }

    public static void checkFieldIsInsertable(SObjectType sObjectType, String fieldName) {
        checkFieldIsInsertable(sObjectType, XAP_DESC_SObjectDescribe.getDescribe(sObjectType).getField(fieldName));
    }

    public static void checkFieldIsInsertable(SObjectType sObjectType, SObjectField fieldToken) {
        checkFieldIsInsertable(sObjectType, fieldToken.getDescribe());
    }

    public static void checkFieldIsInsertable(SObjectType sObjectType, DescribeFieldResult fieldDescribe) {
        if (BYPASS_INTERNAL_FLS_AND_CRUD) {
            return;
        }
        if (!fieldDescribe.isCreateable()) {
            throw new XAP_DAO_DML_FieldLevelSecurityException(
                    XAP_DAO_DML_OperationTypeEnum.CREATE, 
                    sObjectType, fieldDescribe.getSobjectField()
            );
        }
    }

    public static void checkFieldIsUpdateable(SObjectType sObjectType, String fieldName) {
        checkFieldIsUpdateable(sObjectType, XAP_DESC_SObjectDescribe.getDescribe(sObjectType).getField(fieldName));
    }

    public static void checkFieldIsUpdateable(SObjectType sObjectType, SObjectField fieldToken) {
        checkFieldIsUpdateable(sObjectType, fieldToken.getDescribe());
    }

    public static void checkFieldIsUpdateable(SObjectType sObjectType, DescribeFieldResult fieldDescribe) {
        if (BYPASS_INTERNAL_FLS_AND_CRUD) {
            return;
        }
        if (!fieldDescribe.isUpdateable()) {
            throw new XAP_DAO_DML_FieldLevelSecurityException(
                    XAP_DAO_DML_OperationTypeEnum.MODIFY, 
                    sObjectType, 
                    fieldDescribe.getSobjectField()
            ); 
        }
    }

    public static void checkSObjectIsInsertable(SObjectType sObjectType) {
        if (BYPASS_INTERNAL_FLS_AND_CRUD) {
            return;
        }
        if (!sObjectType.getDescribe().isCreateable()) {
            throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.CREATE, sObjectType);
        }
    }

    public static void checkSObjectIsUpdateable(SObjectType sObjectType) {
        if (BYPASS_INTERNAL_FLS_AND_CRUD) {
            return;
        }
        if (!sObjectType.getDescribe().isUpdateable()) {
            throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.MODIFY, sObjectType);
        }
    }

    public static void checkSObjectIsDeletable(SObjectType sObjectType) {
        if (BYPASS_INTERNAL_FLS_AND_CRUD) {
            return;
        }
        if (!sObjectType.getDescribe().isDeletable()) {
            throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.REMOVE, sObjectType);
        }
    }

    public static void checkSObjectIsUndeletable(SObjectType sObjectType) {
        if (BYPASS_INTERNAL_FLS_AND_CRUD) {
            return;
        }
        if (!sObjectType.getDescribe().isUndeletable()) {
            throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.RESTORE, sObjectType);
        }
    }
}