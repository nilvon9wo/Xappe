public class XAP_DAO_DML_SecurityConfig {
    private static final XAP_DAO_DML_SecurityCheckModeEnum DEFAULT_CRUD_MODE
            = XAP_DAO_DML_SecurityCheckModeEnum.FOR_EVERY_SOBJECT;
    private static final XAP_DAO_DML_SecurityCheckModeEnum DEFAULT_FLS_MODE
            = XAP_DAO_DML_SecurityCheckModeEnum.FOR_EVERY_SOBJECT;

    public XAP_DAO_DML_SecurityConfig(
            XAP_DAO_DML_SecurityCheckModeEnum fieldLevelMode,
            XAP_DAO_DML_SecurityCheckModeEnum crudMode
    ) {
        this.fieldLevelMode = fieldLevelMode;
        this.crudMode = crudMode;
    }

    public XAP_DAO_DML_SecurityConfig(XAP_DAO_DML_SecurityCheckModeEnum fieldLevelMode) {
        this(fieldLevelMode, DEFAULT_CRUD_MODE);
    }

    public XAP_DAO_DML_SecurityConfig() {
        this(DEFAULT_FLS_MODE);
    }

    private XAP_DAO_DML_SecurityCheckModeEnum crudMode;
    public XAP_DAO_DML_SecurityConfig setCrudMode(XAP_DAO_DML_SecurityCheckModeEnum securityCrudCheckMode) {
        this.crudMode = crudMode;
        return this;
    }

    private XAP_DAO_DML_SecurityCheckModeEnum fieldLevelMode;
    public XAP_DAO_DML_SecurityConfig setFieldLevelMode(XAP_DAO_DML_SecurityCheckModeEnum securityFieldLevelCheckMode) {
        this.fieldLevelMode = fieldLevelMode;
        return this;
    }

    private List<SObjectType> sObjectTypesToCheckList;
    public XAP_DAO_DML_SecurityConfig setSObjectTypesToCheckList(List<SObjectType> sObjectTypesToCheckList) {
        this.sObjectTypesToCheckList = sObjectTypesToCheckList;
        return this;
    }

    private List<SObjectField> sObjectFieldsToCheckList;
    public XAP_DAO_DML_SecurityConfig setSObjectFieldsToCheckList(List<SObjectField> sObjectFieldsToCheckList) {
        this.sObjectFieldsToCheckList = sObjectFieldsToCheckList;
        return this;
    }
}