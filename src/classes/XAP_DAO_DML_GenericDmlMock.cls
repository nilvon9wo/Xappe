@IsTest
public class XAP_DAO_DML_GenericDmlMock extends XAP_DAO_DML_InheritedSharingDml {
	// These need to be lists in case there are multiple DML operations during your test.
	// Otherwise, only the last operation would be verifiable.
	public List<List<SObject>> insertedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> insertWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> updatedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> updateWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> upsertedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> upsertWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> deletedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> deleteWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<List<SObject>> undeletedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> undeleteWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public List<XAP_DAO_DML_ResultListWrapperIntf> dmlResultListWrapperList;
	private Integer returnedResult = 0;

	public override XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (objectList != null && !objectList.isEmpty()) {
			this.insertedSObjectListList.add(objectList);
		}
		this.insertWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_SaveResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (objectList != null && !objectList.isEmpty()) {
			this.updatedSObjectListList.add(objectList);
		}
		this.updateWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_SaveResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (objectList != null && !objectList.isEmpty()) {
			this.upsertedSObjectListList.add(objectList);
		}
		this.upsertWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_UpsertResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (objectList != null && !objectList.isEmpty()) {
			this.deletedSObjectListList.add(objectList);
		}
		this.deleteWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_DeleteResultListWrapper) this.getNextResultList();
	}

	public override XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (objectList != null && !objectList.isEmpty()) {
			this.undeletedSObjectListList.add(objectList);
		}
		this.undeleteWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_UndeleteResultListWrapper) this.getNextResultList();
	}

	private XAP_DAO_DML_ResultListWrapperIntf getNextResultList() {
		return (dmlResultListWrapperList != null)
				? dmlResultListWrapperList[returnedResult++]
				: null;
	}
}