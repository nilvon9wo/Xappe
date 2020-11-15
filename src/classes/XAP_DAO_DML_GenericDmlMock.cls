@IsTest
public class XAP_DAO_DML_GenericDmlMock implements XAP_DAO_DML_GenericDmlIntf {
	public List<XAP_DAO_DML_ResultListWrapperIntf> dmlResultListWrapperList;
	private Integer returnedResult = 0;

	public Exception thrownException;
	public Integer resultToThrowExceptionOn;

	// Insert Methods -----------------------------------------------------------------------------------------
	public List<List<SObject>> insertedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> insertWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, Database.DMLOptions dmlOptions) {
		return new XAP_DAO_DML_SaveResultListWrapper(Database.insert(sObjectList, dmlOptions));
	}

	public XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.insertedSObjectListList.add(sObjectList);
		}
		this.insertWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_SaveResultListWrapper) this.getNextResultList();
	}

	public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList) {
		return this.doInsert(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Publish Methods -----------------------------------------------------------------------------------------
	public List<List<SObject>> publishedSObjectListList = new List<List<SObject>>();

	public virtual XAP_DAO_DML_SaveResultListWrapper doPublish(List<SObject> sObjectList) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.publishedSObjectListList.add(sObjectList);
		}
		return (XAP_DAO_DML_SaveResultListWrapper) this.getNextResultList();
	}

	// Update Methods -----------------------------------------------------------------------------------------
	public List<List<SObject>> updatedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> updateWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.updatedSObjectListList.add(sObjectList);
		}
		this.updateWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_SaveResultListWrapper) this.getNextResultList();
	}

	public virtual XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> sObjectList) {
		return this.doUpdate(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Upsert Methods -----------------------------------------------------------------------------------------
	public List<List<SObject>> upsertedSObjectListList = new List<List<SObject>>();
	public List<SObjectField> upsertForeignKeyList = new List<SObjectField>();
	public List<XAP_DAO_DML_OperationModeEnum> upsertWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> sObjectList, SObjectField foreignKeyField, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.upsertedSObjectListList.add(sObjectList);
			for (SObject sObj : sObjectList) {
				if (sObj.Id == null) {
					XFTY_IdMocker.addId(sObj);
				}
			}
		}
		this.upsertForeignKeyList.add(foreignKeyField);
		this.upsertWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_UpsertResultListWrapper) this.getNextResultList();
	}

	public XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		return this.doUpsert(sObjectList, null, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	public virtual XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList) {
		return this.doUpsert(homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Delete Methods -----------------------------------------------------------------------------------------
	public List<List<SObject>> deletedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> deleteWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.deletedSObjectListList.add(sObjectList);
		}
		this.deleteWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_DeleteResultListWrapper) this.getNextResultList();
	}

	public virtual XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> sObjectList) {
		return this.doDelete(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}

	// Undelete Methods -----------------------------------------------------------------------------------------
	public List<List<SObject>> undeletedSObjectListList = new List<List<SObject>>();
	public List<XAP_DAO_DML_OperationModeEnum> undeleteWasAllOrNoneList = new List<XAP_DAO_DML_OperationModeEnum>();

	public XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
		if (sObjectList != null && !sObjectList.isEmpty()) {
			this.undeletedSObjectListList.add(sObjectList);
		}
		this.undeleteWasAllOrNoneList.add(operationMode);
		return (XAP_DAO_DML_UndeleteResultListWrapper) this.getNextResultList();
	}

	public virtual XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> sObjectList) {
		return this.doUndelete(sObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
	}


	private XAP_DAO_DML_ResultListWrapperIntf getNextResultList() {
		if (thrownException != null && returnedResult == resultToThrowExceptionOn) {
			throw  thrownException;
		}

		return (dmlResultListWrapperList != null)
				? dmlResultListWrapperList[returnedResult++]
				: null;
	}

}