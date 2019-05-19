public virtual inherited sharing class XAP_DAO_DML_GenericDml {
    XAP_DAO_DML_OperationModeHelper operationModeHelper;

    @TestVisible
    private XAP_DAO_DML_GenericDml(XAP_DAO_DML_OperationModeHelper operationModeHelper) {
        this.operationModeHelper = operationModeHelper;
    }

    @TestVisible
    protected XAP_DAO_DML_GenericDml() {
        this(XAP_DAO_DML_OperationModeHelper.getInstance());
    }

    private static XAP_DAO_DML_GenericDml instance;

    public static XAP_DAO_DML_GenericDml getInstance() {
        if (instance == null) {
            instance = new XAP_DAO_DML_GenericDml();
        }
        return instance;
    }

    // Insert Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> sObjectList, Database.DMLOptions dmlOptions) {
        return new XAP_DAO_DML_SaveResultListWrapper(Database.insert(sObjectList, dmlOptions));
    }

    public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
        return new XAP_DAO_DML_SaveResultListWrapper(Database.insert(objectList, this.convert(operationMode)));
    }

    public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> objectList) {
        return this.doInsert(objectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
    }

    // Update Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
        return new XAP_DAO_DML_SaveResultListWrapper(Database.update(objectList, this.convert(operationMode)));
    }

    public virtual XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> objectList) {
        return this.doUpdate(objectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
    }

    // Upsert Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum operationMode) {
        if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
            return null;
        }

        // @see: https://salesforce.stackexchange.com/questions/215514/how-can-i-upsert-a-homogeneous-listsobject-in-a-good-way/215518#215518
        String listType = 'List<' + homogeneousSObjectList[0].getSObjectType() + '>';
        List<SObject> concreteSObjectList = (List<SObject>) Type.forName(listType).newInstance();
        concreteSObjectList.addAll(homogeneousSObjectList);

        return new XAP_DAO_DML_UpsertResultListWrapper(Database.upsert(homogeneousSObjectList, this.convert(operationMode)));
    }

    public virtual XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList) {
        return this.doUpsert(homogeneousSObjectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
    }

    // Delete Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
        return new XAP_DAO_DML_DeleteResultListWrapper(Database.delete(objectList, this.convert(operationMode)));
    }

    public virtual XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> objectList) {
        return this.doDelete(objectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
    }

    // Undelete Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> objectList, XAP_DAO_DML_OperationModeEnum operationMode) {
        return new XAP_DAO_DML_UndeleteResultListWrapper(Database.undelete(objectList, this.convert(operationMode)));
    }

    public virtual XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> objectList) {
        return this.doUndelete(objectList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE);
    }
    // Helper Methods -----------------------------------------------------------------------------------------

    private Boolean convert(XAP_DAO_DML_OperationModeEnum operationMode) {
        return this.operationModeHelper.toBoolean(operationMode);
    }
}
