public virtual class XAP_DAO_DML_OperationModeHelper {
	public static Boolean IS_ALL_OR_NONE = true;
	public static Boolean NOT_ALL_OR_NONE = false;

	@TestVisible
	protected XAP_DAO_DML_OperationModeHelper() {
	}

	private static XAP_DAO_DML_OperationModeHelper instance;

	public static XAP_DAO_DML_OperationModeHelper getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_DML_OperationModeHelper();
		}
		return instance;
	}

	public Boolean toBoolean(XAP_DAO_DML_OperationModeEnum operationMode) {
		if (operationMode == null) {
			throw new XAP_DAO_DML_AccessCtrlDmlException('Operation Mode must not be null.');
		}

		if (operationMode == XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE) {
			return IS_ALL_OR_NONE;
		}
		else if (operationMode == XAP_DAO_DML_OperationModeEnum.BEST_EFFORT) {
			return NOT_ALL_OR_NONE;
		}
		else {
			throw new XAP_DAO_DML_AccessCtrlDmlException('Invalid value for Operation Mode.');
		}
	}
}