public class XAP_DAO_DML_CrudException extends XAP_DAO_DML_SecurityException {
	public XAP_DAO_DML_CrudException(XAP_DAO_DML_OperationTypeEnum operationType, SObjectType sObjectType) {
		this.operationType = operationType;
		this.sObjectType = sObjectType;
		if (operationType == XAP_DAO_DML_OperationTypeEnum.CREATE) {
			this.setMessage(sObjectType + ' is not Insertable.');
		}
		else if (operationType == XAP_DAO_DML_OperationTypeEnum.MODIFY) {
			this.setMessage(sObjectType + ' is not Updateable.');
		}
		else if (operationType == XAP_DAO_DML_OperationTypeEnum.REMOVE) {
			this.setMessage(sObjectType + ' is not Deletable.');
		}
		else if (operationType == XAP_DAO_DML_OperationTypeEnum.RESTORE) {
			this.setMessage(sObjectType + ' is not Undeletable.');
		}
	}
}