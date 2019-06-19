public class XAP_DAO_DML_FieldLevelSecurityException extends XAP_DAO_DML_SecurityException {
	private SObjectField sObjectField;

	public XAP_DAO_DML_FieldLevelSecurityException(
			XAP_DAO_DML_OperationTypeEnum operationType,
			SObjectType sObjectType,
			SObjectField sObjectField
	) {
		this.operationType = operationType;
		this.sObjectType = sObjectType;
		this.sObjectField = sObjectField;
		if (operationType == XAP_DAO_DML_OperationTypeEnum.CREATE) {
			this.setMessage(sObjectType + '.' + sObjectField + 'is not insertable');
		}
		else if (operationType == XAP_DAO_DML_OperationTypeEnum.MODIFY) {
			this.setMessage(sObjectType + '.' + sObjectField + 'is not updatable');
		}
	}
}