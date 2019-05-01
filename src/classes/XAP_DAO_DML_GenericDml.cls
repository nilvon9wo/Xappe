public virtual class XAP_DAO_DML_GenericDml {
    public static Boolean IS_ALL_OR_NONE = true;
    public static Boolean NOT_ALL_OR_NONE = false;

    @TestVisible
    protected XAP_DAO_DML_GenericDml() {
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

    public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> objectList, Boolean isAllOrNone) {
        return new XAP_DAO_DML_SaveResultListWrapper(Database.insert(objectList, isAllOrNone));
    }

    public virtual XAP_DAO_DML_SaveResultListWrapper doInsert(List<SObject> objectList) {
        return this.doInsert(objectList, IS_ALL_OR_NONE);
    }

    // Update Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> objectList, Boolean isAllOrNone) {
        return new XAP_DAO_DML_SaveResultListWrapper(Database.update(objectList, isAllOrNone));
    }

    public virtual XAP_DAO_DML_SaveResultListWrapper doUpdate(List<SObject> objectList) {
        return this.doUpdate(objectList, IS_ALL_OR_NONE);
    }

    // Upsert Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList, Boolean isAllOrNone) {
        if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
            return null;
        }

        // @see: https://salesforce.stackexchange.com/questions/215514/how-can-i-upsert-a-homogeneous-listsobject-in-a-good-way/215518#215518
        String listType = 'List<' + homogeneousSObjectList[0].getSObjectType() + '>';
        List<SObject> concreteSObjectList = (List<SObject>) Type.forName(listType).newInstance();
        concreteSObjectList.addAll(homogeneousSObjectList);

        return new XAP_DAO_DML_UpsertResultListWrapper(Database.upsert(homogeneousSObjectList, isAllOrNone));
    }

    public virtual XAP_DAO_DML_UpsertResultListWrapper doUpsert(List<SObject> homogeneousSObjectList) {
        return this.doUpsert(homogeneousSObjectList, IS_ALL_OR_NONE);
    }

    // Delete Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> objectList, Boolean isAllOrNone) {
        return new XAP_DAO_DML_DeleteResultListWrapper(Database.delete(objectList, isAllOrNone));
    }

    public virtual XAP_DAO_DML_DeleteResultListWrapper doDelete(List<SObject> objectList) {
        return this.doDelete(objectList, IS_ALL_OR_NONE);
    }

    // Undelete Methods -----------------------------------------------------------------------------------------

    public virtual XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> objectList, Boolean isAllOrNone) {
        return new XAP_DAO_DML_UndeleteResultListWrapper(Database.undelete(objectList, isAllOrNone));
    }

    public virtual XAP_DAO_DML_UndeleteResultListWrapper doUndelete(List<SObject> objectList) {
        return this.doUndelete(objectList, IS_ALL_OR_NONE);
    }
}
