public interface XAP_DAO_SDML_AccessCtrlIntf {
    SObject insertAsUser(SObject someObj, List<String> fieldsToSet);
    SObject insertAsUser(SObject someObj, List<Schema.SObjectField> fieldsToSet);
    //SFDCAccessControlResults.InsertResults insertAsUser(SObject [] someObjs, List<String> fieldsToSet);
    //SFDCAccessControlResults.InsertResults insertAsUser(SObject [] someObjs, List<Schema.SObjectField> fieldsToSet);

    SObject updateAsUser(SObject someObj, List<String> fieldsToUpdate);
    SObject updateAsUser(SObject someObj, List<Schema.SObjectField> fieldsToUpdate);
    //SFDCAccessControlResults.UpdateResults updateAsUser(Map<ID, sObject> objMap, List<String> fieldsToUpdate);
    //SFDCAccessControlResults.UpdateResults updateAsUser(Map<ID, sObject> objMap, List<Schema.SObjectField> fieldsToUpdate);

    void deleteAsUser(SObject someObj);
    //SFDCAccessControlResults.DeleteResults deleteAsUser(SObject [] someObjs);

    List<Schema.SObjectField> getViewableFields(SObjectType someType);
    List<Schema.SObjectField> getUpdateableFields(SObjectType someType);
    List<Schema.SObjectField> getCreatableFields(SObjectType someType);

    Boolean isAuthorizedToView(Schema.SObjectType someType, List<String> fieldNames);
    Boolean isAuthorizedToCreate(Schema.SObjectType someType, List<String> fieldNames);
    Boolean isAuthorizedToUpdate(Schema.SObjectType someType, List<String> fieldNames);

    Boolean isAuthorizedToView(Schema.SObjectType someType, List<Schema.SObjectField> fields);
    Boolean isAuthorizedToCreate(Schema.SObjectType someType, List<Schema.SObjectField> fields);
    Boolean isAuthorizedToUpdate(Schema.SObjectType someType, List<Schema.SObjectField> fields);

    Boolean isAuthorizedToDelete(Schema.SObjectType someType);
}