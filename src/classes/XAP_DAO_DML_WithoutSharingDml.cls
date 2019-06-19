public virtual without sharing class XAP_DAO_DML_WithoutSharingDml implements XAP_DAO_DML_GenericDmlIntf {
	XAP_DAO_DML_InheritedSharingDml inheritedSharingDml;

	@TestVisible
	private XAP_DAO_DML_WithoutSharingDml(XAP_DAO_DML_InheritedSharingDml inheritedSharingDml) {
		this.inheritedSharingDml = inheritedSharingDml;
	}

	@TestVisible
	protected XAP_DAO_DML_WithoutSharingDml() {
		this(XAP_DAO_DML_InheritedSharingDml.getInstance());
	}

	private static XAP_DAO_DML_WithoutSharingDml instance;

	public static XAP_DAO_DML_WithoutSharingDml getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_DML_WithoutSharingDml();
		}
		return instance;
	}

	public XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, Database.DMLOptions dmlOptions) {
		return this.inheritedSharingDml.doInsert(sObjectList, dmlOptions);
	}

	public XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.inheritedSharingDml.doInsert(sObjectList, operationMode);
	}

	public XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList) {
		return this.inheritedSharingDml.doInsert(sObjectList);
	}

	public XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.inheritedSharingDml.doUpdate(sObjectList, operationMode);
	}

	public XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList) {
		return this.inheritedSharingDml.doUpdate(sObjectList);
	}

	public XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.inheritedSharingDml.doUpsert(homogeneousSObjectList, operationMode);
	}

	public XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList) {
		return this.inheritedSharingDml.doUpsert(homogeneousSObjectList);
	}

	public XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.inheritedSharingDml.doDelete(sObjectList, operationMode);
	}

	public XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList) {
		return this.inheritedSharingDml.doDelete(sObjectList);
	}

	public XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.inheritedSharingDml.doUndelete(sObjectList, operationMode);
	}

	public XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList) {
		return this.inheritedSharingDml.doUndelete(sObjectList);
	}
}