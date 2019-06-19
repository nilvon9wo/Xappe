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
	public static final Boolean OPERATION_IS_PERMITTED = true;

	public Boolean checkInsert(SObjectType sObjectType, List<String> fieldNameList) {
		this.checkSObjectIsInsertable(sObjectType);
		for (String fieldName : fieldNameList) {
			this.checkFieldIsInsertable(sObjectType, fieldName);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkInsert(SObjectType sObjectType, List<SObjectField> sObjectFieldList) {
		this.checkSObjectIsInsertable(sObjectType);
		for (SObjectField fieldToken : sObjectFieldList) {
			checkFieldIsInsertable(sObjectType, fieldToken);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkUpdate(SObjectType sObjectType, List<String> fieldNameList) {
		this.checkSObjectIsUpdateable(sObjectType);
		for (String fieldName : fieldNameList) {
			this.checkFieldIsUpdateable(sObjectType, fieldName);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkUpdate(SObjectType sObjectType, List<SObjectField> sObjectFieldList) {
		this.checkSObjectIsUpdateable(sObjectType);
		for (SObjectField fieldToken : sObjectFieldList) {
			this.checkFieldIsUpdateable(sObjectType, fieldToken);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkFieldIsInsertable(SObjectType sObjectType, String fieldName) {
		return this.checkFieldIsInsertable(
				sObjectType, XAP_DESC_SObjectDescribe.getDescribe(sObjectType).getField(fieldName)
		);
	}

	public Boolean checkFieldIsInsertable(SObjectType sObjectType, SObjectField sObjectField) {
		return this.checkFieldIsInsertable(sObjectType, sObjectField.getDescribe());
	}

	public Boolean checkFieldIsInsertable(SObjectType sObjectType, DescribeFieldResult fieldDescribe) {
		if (BYPASS_INTERNAL_FLS_AND_CRUD) {
			return OPERATION_IS_PERMITTED;
		}
		if (!fieldDescribe.isCreateable()) {
			throw new XAP_DAO_DML_FieldLevelSecurityException(
					XAP_DAO_DML_OperationTypeEnum.CREATE,
					sObjectType, fieldDescribe.getSobjectField()
			);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkFieldIsUpdateable(SObjectType sObjectType, String fieldName) {
		return this.checkFieldIsUpdateable(
				sObjectType, XAP_DESC_SObjectDescribe.getDescribe(sObjectType).getField(fieldName)
		);
	}

	public Boolean checkFieldIsUpdateable(SObjectType sObjectType, SObjectField sObjectField) {
		return this.checkFieldIsUpdateable(sObjectType, sObjectField.getDescribe());
	}

	public Boolean checkFieldIsUpdateable(SObjectType sObjectType, DescribeFieldResult fieldDescribe) {
		if (BYPASS_INTERNAL_FLS_AND_CRUD) {
			return OPERATION_IS_PERMITTED;
		}
		if (!fieldDescribe.isUpdateable()) {
			throw new XAP_DAO_DML_FieldLevelSecurityException(
					XAP_DAO_DML_OperationTypeEnum.MODIFY,
					sObjectType,
					fieldDescribe.getSobjectField()
			);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkSObjectIsInsertable(SObjectType sObjectType) {
		if (BYPASS_INTERNAL_FLS_AND_CRUD) {
			return OPERATION_IS_PERMITTED;
		}
		if (!sObjectType.getDescribe().isCreateable()) {
			throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.CREATE, sObjectType);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkSObjectIsUpdateable(SObjectType sObjectType) {
		if (BYPASS_INTERNAL_FLS_AND_CRUD) {
			return OPERATION_IS_PERMITTED;
		}
		if (!sObjectType.getDescribe().isUpdateable()) {
			throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.MODIFY, sObjectType);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkSObjectIsDeletable(SObjectType sObjectType) {
		if (BYPASS_INTERNAL_FLS_AND_CRUD) {
			return OPERATION_IS_PERMITTED;
		}
		if (!sObjectType.getDescribe().isDeletable()) {
			throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.REMOVE, sObjectType);
		}
		return OPERATION_IS_PERMITTED;
	}

	public Boolean checkSObjectIsUndeletable(SObjectType sObjectType) {
		if (BYPASS_INTERNAL_FLS_AND_CRUD) {
			return OPERATION_IS_PERMITTED;
		}
		if (!sObjectType.getDescribe().isUndeletable()) {
			throw new XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum.RESTORE, sObjectType);
		}
		return OPERATION_IS_PERMITTED;
	}
}