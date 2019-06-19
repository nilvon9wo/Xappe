public interface XAP_DAO_DML_GenericDmlIntf {
	XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, Database.DMLOptions dmlOptions);
	XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode);
	XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList);

	XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode);
	XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList);

	XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum operationMode);
	XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList);

	XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode);
	XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList);

	XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode);
	XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList);
}