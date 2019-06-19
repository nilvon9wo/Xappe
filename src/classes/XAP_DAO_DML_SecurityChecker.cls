public virtual class XAP_DAO_DML_SecurityChecker {
	XAP_DAO_DML_SecurityUtils securityUtils;
	XAP_UTIL_Randomizer randomizer;

	@TestVisible
	private XAP_DAO_DML_SecurityChecker(XAP_DAO_DML_SecurityUtils securityUtils, XAP_UTIL_Randomizer randomizer) {
		this.securityUtils = securityUtils;
		this.randomizer = randomizer;
	}

	@TestVisible
	protected XAP_DAO_DML_SecurityChecker() {
		this(XAP_DAO_DML_SecurityUtils.getInstance(), XAP_UTIL_Randomizer.getInstance());
	}

	private static XAP_DAO_DML_SecurityChecker instance;

	public static XAP_DAO_DML_SecurityChecker getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_DML_SecurityChecker();
		}
		return instance;
	}

	private static final Boolean OPERATION_IS_PERMITTED = XAP_DAO_DML_SecurityUtils.OPERATION_IS_PERMITTED;
	private static final Boolean OPERATION_FOR_UNEXPECTED_TYPE_NOT_PERMITTED = false;

	public final static Set<XAP_DAO_DML_OperationTypeEnum> UNCHECKED_FIELD_OPERATION_SET
			= new Set<XAP_DAO_DML_OperationTypeEnum>{
					XAP_DAO_DML_OperationTypeEnum.REMOVE,
					XAP_DAO_DML_OperationTypeEnum.RESTORE
			};

	private XAP_DAO_DML_SecurityConfig securityConfig = new XAP_DAO_DML_SecurityConfig();
	public XAP_DAO_DML_SecurityChecker setSecurityConfig(XAP_DAO_DML_SecurityConfig securityConfig) {
		this.securityConfig = securityConfig;
		return this;
	}

	public Boolean check(List<SObject> sObjectList, Set<XAP_DAO_DML_OperationTypeEnum> operationTypeSet) {
		Boolean result = OPERATION_IS_PERMITTED;
		for (XAP_DAO_DML_OperationTypeEnum operationType : operationTypeSet) {
			result &= this.check(sObjectList, operationType);
		}
		return result;
	}

	private Boolean check(List<SObject> sObjectList, XAP_DAO_DML_OperationTypeEnum operationType) {
		return this.checkCrud(sObjectList, operationType, this.securityConfig.crudMode)
				&& (
				UNCHECKED_FIELD_OPERATION_SET.contains(operationType)
						|| this.checkFieldLevelSecurity(sObjectList, operationType, this.securityConfig.fieldLevelMode)

		);
	}

	// Check crud security---------------------------------------------------------------------------------------

	private Boolean checkCrud(
			List<SObject> sObjectList,
			XAP_DAO_DML_OperationTypeEnum operationType,
			XAP_DAO_DML_SecurityCheckModeEnum crudMode
	) {
		return (crudMode != XAP_DAO_DML_SecurityCheckModeEnum.FOR_LISTED_ITEMS)
				? this.checkCrud(this.pickForScreening(sObjectList, crudMode), operationType)
				: this.checkCrud(this.securityConfig.sObjectTypesToCheckSet, operationType);
	}

	private Boolean checkCrud(List<SObject> sObjectList, XAP_DAO_DML_OperationTypeEnum operationType) {
		Set<SObjectType> sObjectTypeSet = new Set<SObjectType>();
		for (SObject sObj : sObjectList) {
			sObjectTypeSet.add(sObj.getSObjectType());
		}
		return this.checkCrud(sObjectTypeSet, operationType);
	}

	private Boolean checkCrud(Set<SObjectType> sObjectTypeSet, XAP_DAO_DML_OperationTypeEnum operationType) {
		Boolean result = OPERATION_IS_PERMITTED;
		for (SObjectType sObjectType : sObjectTypeSet) {
			result &= this.checkCrud(sObjectType, operationType);
		}
		return result;
	}

	private Boolean checkCrud(SObjectType sObjectType, XAP_DAO_DML_OperationTypeEnum operationType) {
		return operationType.equals(XAP_DAO_DML_OperationTypeEnum.CREATE)
				? this.securityUtils.checkSObjectIsInsertable(sObjectType)
				: operationType.equals(XAP_DAO_DML_OperationTypeEnum.MODIFY)
						? this.securityUtils.checkSObjectIsUpdateable(sObjectType)
						: operationType.equals(XAP_DAO_DML_OperationTypeEnum.REMOVE)
								? this.securityUtils.checkSObjectIsDeletable(sObjectType)
								: operationType.equals(XAP_DAO_DML_OperationTypeEnum.RESTORE)
										? this.securityUtils.checkSObjectIsUndeletable(sObjectType)
										: OPERATION_FOR_UNEXPECTED_TYPE_NOT_PERMITTED;    // This should never happen.
	}

	// Check field level security---------------------------------------------------------------------------------------

	private Boolean checkFieldLevelSecurity(
			List<SObject> sObjectList,
			XAP_DAO_DML_OperationTypeEnum operationType,
			XAP_DAO_DML_SecurityCheckModeEnum fieldLevelMode
	) {
		return (fieldLevelMode != XAP_DAO_DML_SecurityCheckModeEnum.FOR_LISTED_ITEMS)
				? this.checkFieldLevelSecurity(this.pickForScreening(sObjectList, fieldLevelMode), operationType)
				: this.checkFieldLevelSecurity(this.securityConfig.sObjectFieldsToCheckSet, operationType);
	}

	private Boolean checkFieldLevelSecurity(List<SObject> sObjectList, XAP_DAO_DML_OperationTypeEnum operationType) {
		Map<SObjectType, List<String>> fieldNameListBySObjectTypeMap = new Map<SObjectType, List<String>>();
		for (SObject sObj : sObjectList) {
			Set<String> fieldNameSet = sObj.getPopulatedFieldsAsMap().keySet();
			for (String fieldName : fieldNameSet) {
				if (fieldNameListBySObjectTypeMap.get(sObj.getSObjectType()) == null) {
					fieldNameListBySObjectTypeMap.put(sObj.getSObjectType(), new List<String>());
				}
				fieldNameListBySObjectTypeMap.get(sObj.getSObjectType()).add(fieldName);
			}
		}
		return this.checkFieldLevelSecurity(fieldNameListBySObjectTypeMap, operationType);
	}

	private Boolean checkFieldLevelSecurity(
			Set<SObjectField> sObjectFieldSet,
			XAP_DAO_DML_OperationTypeEnum operationTypeSet
	) {
		Map<SObjectType, List<String>> fieldNameListBySObjectTypeMap = new Map<SObjectType, List<String>>();
		for (SObjectField sObjectField : sObjectFieldSet) {
			List<SObjectType> sObjectTypeList = sObjectField.getDescribe().getReferenceTo();
			String fieldName = sObjectField.getDescribe().getName();
			for (SObjectType sObjectType : sObjectTypeList) {
				if (fieldNameListBySObjectTypeMap.get(sObjectType) == null) {
					fieldNameListBySObjectTypeMap.put(sObjectType, new List<String>());
				}
				fieldNameListBySObjectTypeMap.get(sObjectType).add(fieldName);
			}
		}
		return this.checkFieldLevelSecurity(fieldNameListBySObjectTypeMap, operationTypeSet);
	}

	private Boolean checkFieldLevelSecurity(
			Map<SObjectType, List<String>> fieldNameListBySObjectTypeMap,
			XAP_DAO_DML_OperationTypeEnum operationType
	) {
		Boolean result = OPERATION_IS_PERMITTED;
		for (SObjectType sObjectType : fieldNameListBySObjectTypeMap.keySet()) {
			List<String> fieldNameList = fieldNameListBySObjectTypeMap.get(sObjectType);
			result &= operationType.equals(XAP_DAO_DML_OperationTypeEnum.CREATE)
					? this.securityUtils.checkInsert(sObjectType, fieldNameList)
					: operationType.equals(XAP_DAO_DML_OperationTypeEnum.MODIFY)
							? this.securityUtils.checkUpdate(sObjectType, fieldNameList)
							: OPERATION_FOR_UNEXPECTED_TYPE_NOT_PERMITTED;    // This should never happen.
		}
		return result;
	}

	// Pick for screening --------------------------------------------------------------------------------------------

	private List<SObject> pickForScreening(List<SObject> sObjectList, XAP_DAO_DML_SecurityCheckModeEnum crudMode) {
		if (
				XAP_DAO_DML_SecurityCheckModeEnum.FOR_EVERY_SOBJECT.equals(crudMode)
						|| XAP_DAO_DML_SecurityCheckModeEnum.FOR_LISTED_ITEMS.equals(crudMode)
				) {
			return sObjectList;
		}

		if (XAP_DAO_DML_SecurityCheckModeEnum.BIPASS.equals(crudMode)) {
			return new List<SObject>();
		}

		Integer indexForCheck = XAP_DAO_DML_SecurityCheckModeEnum.FOR_FIRST_SOBJECT_IN_LIST.equals(crudMode)
				? 0
				: XAP_DAO_DML_SecurityCheckModeEnum.FOR_LAST_SOBJECT_IN_LIST.equals(crudMode)
						? sObjectList.size() - 1
						: this.pickRandom(sObjectList.size());

		return new List<SObject>{
				sObjectList[indexForCheck]
		};
	}

	private Integer pickRandom(Integer listSize) {
		return this.randomizer.getRandomNumber(listSize - 1);
	}
}