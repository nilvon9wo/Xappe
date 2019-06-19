public virtual inherited sharing class XAP_DAO_DML_SecureDml implements XAP_DAO_DML_GenericDmlIntf {
	XAP_DAO_DML_DmlLookup dmlLookup;
	XAP_DAO_DML_SecurityChecker securityChecker;

	@TestVisible
	private XAP_DAO_DML_SecureDml(XAP_DAO_DML_DmlLookup dmlLookup, XAP_DAO_DML_SecurityChecker securityChecker) {
		this.dmlLookup = dmlLookup;
		this.securityChecker = securityChecker;
	}

	@TestVisible
	protected XAP_DAO_DML_SecureDml() {
		this(XAP_DAO_DML_DmlLookup.getInstance(), XAP_DAO_DML_SecurityChecker.getInstance());
	}

	private static XAP_DAO_DML_SecureDml instance;

	public static XAP_DAO_DML_SecureDml getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_DML_SecureDml();
		}
		return instance;
	}

	private XAP_DAO_DML_SharingModeEnum sharingModeEnum = XAP_DAO_DML_SharingModeEnum.WITH;
	public XAP_DAO_DML_SecureDml setSharingMode(XAP_DAO_DML_SharingModeEnum sharingModeEnum) {
		this.sharingModeEnum = sharingModeEnum;
		return this;
	}

	private XAP_DAO_DML_OperationModeEnum operationMode = XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE;
	public XAP_DAO_DML_SecureDml setOperationMode(XAP_DAO_DML_OperationModeEnum operationMode) {
		this.operationMode = operationMode;
		return this;
	}

	public XAP_DAO_DML_SecureDml setSecurityConfig(XAP_DAO_DML_SecurityConfig securityConfig) {
		this.securityChecker.setSecurityConfig(securityConfig);
		return this;
	}

	// Insert ---------------------------------------------------------------------------------------------------------

	private static final Set<XAP_DAO_DML_OperationTypeEnum> CAN_INSERT_SET
			= new Set<XAP_DAO_DML_OperationTypeEnum>{XAP_DAO_DML_OperationTypeEnum.CREATE};

	public XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, Database.DMLOptions dmlOptions) {
		if (this.checkPermissions(sObjectList, CAN_INSERT_SET)) {
			this.withDmlFor(this.sharingModeEnum).doInsert(sObjectList, dmlOptions);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to insert ' + sObjectList[0].getSObjectType());
	}

	public XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (this.checkPermissions(sObjectList, CAN_INSERT_SET)) {
			this.withDmlFor(this.sharingModeEnum).doInsert(sObjectList, operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to insert ' + sObjectList[0].getSObjectType());
	}

	public XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList) {
		if (this.checkPermissions(sObjectList, CAN_INSERT_SET)) {
			this.withDmlFor(this.sharingModeEnum).doInsert(sObjectList, this.operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to insert ' + sObjectList[0].getSObjectType());
	}

	// Update ---------------------------------------------------------------------------------------------------------

	private static final Set<XAP_DAO_DML_OperationTypeEnum> CAN_UPDATE_SET
			= new Set<XAP_DAO_DML_OperationTypeEnum>{XAP_DAO_DML_OperationTypeEnum.MODIFY};

	public XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (this.checkPermissions(sObjectList, CAN_UPDATE_SET)) {
			this.withDmlFor(this.sharingModeEnum).doUpdate(sObjectList, operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to update ' + sObjectList[0].getSObjectType());
	}

	public XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList) {
		if (this.checkPermissions(sObjectList, CAN_UPDATE_SET)) {
			this.withDmlFor(this.sharingModeEnum).doUpdate(sObjectList, this.operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to update ' + sObjectList[0].getSObjectType());
	}

	// Upsert ---------------------------------------------------------------------------------------------------------

	private static final Set<XAP_DAO_DML_OperationTypeEnum> CAN_UPSERT_SET
			= new Set<XAP_DAO_DML_OperationTypeEnum>{XAP_DAO_DML_OperationTypeEnum.CREATE, XAP_DAO_DML_OperationTypeEnum.MODIFY};

	public XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (this.checkPermissions(homogeneousSObjectList, CAN_UPSERT_SET)) {
			this.withDmlFor(this.sharingModeEnum).doUpdate(homogeneousSObjectList, operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to upsert ' + homogeneousSObjectList[0].getSObjectType());
	}

	public XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList) {
		if (this.checkPermissions(homogeneousSObjectList, CAN_UPSERT_SET)) {
			this.withDmlFor(this.sharingModeEnum).doUpdate(homogeneousSObjectList, this.operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to upsert ' + homogeneousSObjectList[0].getSObjectType());
	}

	// Delete ---------------------------------------------------------------------------------------------------------

	private static final Set<XAP_DAO_DML_OperationTypeEnum> CAN_DELETE_SET
			= new Set<XAP_DAO_DML_OperationTypeEnum>{XAP_DAO_DML_OperationTypeEnum.REMOVE};

	public XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (this.checkPermissions(sObjectList, CAN_DELETE_SET)) {
			this.withDmlFor(this.sharingModeEnum).doDelete(sObjectList, operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to delete ' + sObjectList[0].getSObjectType());
	}

	public XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList) {
		if (this.checkPermissions(sObjectList, CAN_DELETE_SET)) {
			this.withDmlFor(this.sharingModeEnum).doDelete(sObjectList, this.operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to delete ' + sObjectList[0].getSObjectType());
	}

	// Undelete ---------------------------------------------------------------------------------------------------------

	private static final Set<XAP_DAO_DML_OperationTypeEnum> CAN_UNDELETE_SET
			= new Set<XAP_DAO_DML_OperationTypeEnum>{XAP_DAO_DML_OperationTypeEnum.RESTORE};

	public XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (this.checkPermissions(sObjectList, CAN_UNDELETE_SET)) {
			this.withDmlFor(this.sharingModeEnum).doUndelete(sObjectList, operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to undelete ' + sObjectList[0].getSObjectType());
	}

	public XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList) {
		if (this.checkPermissions(sObjectList, CAN_UNDELETE_SET)) {
			this.withDmlFor(this.sharingModeEnum).doUndelete(sObjectList, this.operationMode);
		}
		throw new XAP_DAO_DML_AccessCtrlDmlException('Insufficient access to undelete ' + sObjectList[0].getSObjectType());
	}

	private Boolean checkPermissions(List<SObject> sObjectList, Set<XAP_DAO_DML_OperationTypeEnum> operationTypeSet) {
		return this.securityChecker.check(
				sObjectList,
				operationTypeSet
		);
	}

	private XAP_DAO_DML_GenericDmlIntf withDmlFor(XAP_DAO_DML_SharingModeEnum sharingModeEnum) {
		return this.dmlLookup.get(sharingModeEnum);
	}
}