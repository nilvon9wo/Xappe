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

	public XAP_DAO_DML_SecurityCheckModeEnum crudMode { get; private set; }
	public XAP_DAO_DML_SecurityConfig setCrudMode(XAP_DAO_DML_SecurityCheckModeEnum securityCrudCheckMode) {
		this.crudMode = crudMode;
		return this;
	}

	public XAP_DAO_DML_SecurityCheckModeEnum fieldLevelMode { get; private set; }
	public XAP_DAO_DML_SecurityConfig setFieldLevelMode(XAP_DAO_DML_SecurityCheckModeEnum securityFieldLevelCheckMode) {
		this.fieldLevelMode = fieldLevelMode;
		return this;
	}

	public Set<SObjectType> sObjectTypesToCheckSet { get; private set; }
	public XAP_DAO_DML_SecurityConfig setSObjectTypesToCheckList(Set<SObjectType> sObjectTypesToCheckSet) {
		this.sObjectTypesToCheckSet = sObjectTypesToCheckSet;
		return this;
	}

	public Set<SObjectField> sObjectFieldsToCheckSet { get; private set; }
	public XAP_DAO_DML_SecurityConfig setSObjectFieldsToCheckList(Set<SObjectField> sObjectFieldsToCheckSet) {
		this.sObjectFieldsToCheckSet = sObjectFieldsToCheckSet;
		return this;
	}
}