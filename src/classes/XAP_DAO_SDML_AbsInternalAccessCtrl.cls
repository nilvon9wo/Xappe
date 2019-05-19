public abstract class XAP_DAO_SDML_AbsInternalAccessCtrl implements XAP_DAO_SDML_AccessCtrlIntf {
    protected Boolean arrayAllOrNoneParam;

    public SObject insertAsUser(SObject someObj, List<String> fieldsToSet) {
        return null;
    }

    public SObject insertAsUser(SObject someObj, List<SObjectField> fieldsToSet) {
        return null;
    }

    public SObject updateAsUser(SObject someObj, List<String> fieldsToUpdate) {
        return null;
    }

    public SObject updateAsUser(SObject someObj, List<SObjectField> fieldsToUpdate) {
        return null;
    }

    public void deleteAsUser(SObject someObj) {
    }

    public List<SObjectField> getViewableFields(SObjectType someType) {
        return null;
    }

    public List<SObjectField> getUpdateableFields(SObjectType someType) {
        return null;
    }

    public List<SObjectField> getCreatableFields(SObjectType someType) {
        return null;
    }

    public Boolean isAuthorizedToView(SObjectType someType, List<String> fieldNames) {
        return true;
    }

    public Boolean isAuthorizedToCreate(SObjectType someType, List<String> fieldNames) {
        return true;
    }

    public Boolean isAuthorizedToUpdate(SObjectType someType, List<String> fieldNames) {
        return true;
    }

    public Boolean isAuthorizedToView(SObjectType someType, List<SObjectField> fields) {
        return true;
    }

    public Boolean isAuthorizedToCreate(SObjectType someType, List<SObjectField> fields) {
        return true;
    }

    public Boolean isAuthorizedToUpdate(SObjectType someType, List<SObjectField> fields) {
        return true;
    }

    public Boolean isAuthorizedToDelete(SObjectType someType) {
        return true;
    }

}