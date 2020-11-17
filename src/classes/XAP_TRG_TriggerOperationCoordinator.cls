public with sharing virtual class XAP_TRG_TriggerOperationCoordinator {
	private XAP_TRG_TriggerSettingSelector triggerSettingSelector;

	@TestVisible
	private XAP_TRG_TriggerOperationCoordinator(XAP_TRG_TriggerSettingSelector automationSettingSelector) {
		this.triggerSettingSelector = automationSettingSelector;
	}

	@TestVisible
	private XAP_TRG_TriggerOperationCoordinator() {
		this(XAP_TRG_TriggerSettingSelector.getInstance());
	}

	private static XAP_TRG_TriggerOperationCoordinator instance;
	public static XAP_TRG_TriggerOperationCoordinator getInstance() {
		if (instance == null) {
			instance = new XAP_TRG_TriggerOperationCoordinator();
		}
		return null;
	}

	@TestVisible private static Map<SObjectType, Boolean> IS_ENABLED_BY_SOBJECT_TYPE_MAP;
	@TestVisible private static final Boolean IS_ENABLED = true;
	@TestVisible private static final Boolean IS_DISABLED = false;

	@TestVisible
	private static final Map<SObjectType, Set<System.TriggerOperation>> OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP
			= new Map<SObjectType, Set<System.TriggerOperation>>();

	@TestVisible
	private static final List<XAP_TRG_TriggerContext> TRIGGER_IN_PROGRESS_LIST = new List<XAP_TRG_TriggerContext>();

	// isExecutable ---------------------------------------------------------------------------------------------------------

	public virtual Boolean isExecutable(XAP_TRG_TriggerContext triggerProperties) {
		return this.isEnabledForProfile()
				&& this.isEnabledForSObject(triggerProperties.sObjectType)
				&& this.isNotAlreadyInProgress(triggerProperties);
	}

	// isEnabledForProfile ---------------------------------------------------------------------------------------------------------

	@TestVisible
	private virtual Boolean isEnabledForProfile() {
		XAP_TRG_Trigger_Settings__c triggerSettings = triggerSettingSelector.get();
		Boolean isEnabled = this.returnValueOrTrue(triggerSettings.All_Triggers_Enabled__c);
		if (!isEnabled) {
			System.debug(LoggingLevel.WARN, '!!! Triggers disabled for profile');
		}
		return isEnabled;
	}

	// isEnabledForSObject ---------------------------------------------------------------------------------------------------------

	@TestVisible
	private virtual Boolean isEnabledForSObject(SObjectType sObjectType) {
		if (IS_ENABLED_BY_SOBJECT_TYPE_MAP == null) {
			IS_ENABLED_BY_SOBJECT_TYPE_MAP = this.buildIsEnabledBySObjectTypeMap();
		}

		Boolean isEnabled = this.returnValueOrTrue(IS_ENABLED_BY_SOBJECT_TYPE_MAP.get(sObjectType));
		if (!isEnabled) {
			System.debug(LoggingLevel.WARN, '!!! Triggers disabled for ' + sObjectType);
		}
		return isEnabled;
	}

	public virtual Map<SObjectType, Boolean> dynamicDisable(Set<SObjectType> sObjectTypeSet) {
		return this.dynamicUpdate(sObjectTypeSet, IS_DISABLED);
	}

	public virtual Map<SObjectType, Boolean> dynamicEnable(Set<SObjectType> sObjectTypeSet) {
		return this.dynamicUpdate(sObjectTypeSet, IS_ENABLED);
	}

	@TestVisible
	private Map<SObjectType, Boolean> dynamicUpdate(Set<SObjectType> sObjectTypeSet, Boolean isEnabled) {
		if (IS_ENABLED_BY_SOBJECT_TYPE_MAP == null) {
			IS_ENABLED_BY_SOBJECT_TYPE_MAP = new Map<SObjectType, Boolean>();
		}

		for (SObjectType sObjectType : sObjectTypeSet) {
			IS_ENABLED_BY_SOBJECT_TYPE_MAP.put(sObjectType, isEnabled);
		}
		return IS_ENABLED_BY_SOBJECT_TYPE_MAP;
	}

	@TestVisible
	private Map<SObjectType, Boolean> buildIsEnabledBySObjectTypeMap() {
		// Instantiating this value upon class construction causes unexpected behaviours.
		XAP_TRG_Trigger_Settings__c triggerSetting = triggerSettingSelector.get();

		return new Map<SObjectType, Boolean>{
				Account.SObjectType => triggerSetting.Account_Trigger_Enabled__c
		};
	}

	// isNotAlreadyInProgress --------------------------------------------------------------------------------------------

	@TestVisible
	private virtual Boolean isNotAlreadyInProgress(XAP_TRG_TriggerContext triggerProperties) {
		SObjectType sObjectType = triggerProperties.sObjectType;
		System.TriggerOperation operation = triggerProperties.operationType;

		Set<System.TriggerOperation> operationSet = OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(sObjectType);
		Boolean inProgress = operationSet != null && operationSet.contains(operation);
		if (inProgress) {
			System.debug(LoggingLevel.WARN, '!!!' + sObjectType + ' trigger ' + operation + ' already in progress.');
		}
		return !inProgress;
	}

	public virtual Map<SObjectType, Set<System.TriggerOperation>> addToInProgress(XAP_TRG_TriggerContext triggerProperties) {
		SObjectType sObjectType = triggerProperties.sObjectType;
		Set<System.TriggerOperation> operationSet = OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(sObjectType);
		if (operationSet == null) {
			OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.put(sObjectType, new Set<System.TriggerOperation>());
		}
		OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(sObjectType).add(triggerProperties.operationType);

		TRIGGER_IN_PROGRESS_LIST.add(triggerProperties);
		return OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP;
	}

	public virtual Map<SObjectType, Set<System.TriggerOperation>> removeFromInProgress(XAP_TRG_TriggerContext triggerProperties) {
		SObjectType sObjectType = triggerProperties.sObjectType;
		Set<System.TriggerOperation> operationSet = OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(sObjectType);
		if (operationSet != null) {
			operationSet.remove(triggerProperties.operationType);
		}
		if (operationSet.isEmpty()) {
			OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.remove(sObjectType);
		}
		removeFromInProgressList(triggerProperties);
		return OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP;
	}

	@TestVisible
	private List<XAP_TRG_TriggerContext> removeFromInProgressList(XAP_TRG_TriggerContext triggerProperties) {
		Integer index = findInProgressIndex(triggerProperties);
		TRIGGER_IN_PROGRESS_LIST.remove(index);
		return TRIGGER_IN_PROGRESS_LIST;
	}

	@TestVisible
	private Integer findInProgressIndex(XAP_TRG_TriggerContext needle) {
		for (Integer i = 0; i < TRIGGER_IN_PROGRESS_LIST.size(); i++) {
			XAP_TRG_TriggerContext triggerItem = TRIGGER_IN_PROGRESS_LIST[i];
			if (triggerItem.equals(needle)) {
				return i;
			}
		}
		return -1;    // This should never happen!
	}

	// Context providers (experimental methods, not currently needed for CB)-----------------------------------------------

	public Boolean isExecuting(XAP_TRG_TriggerSObjectTypeOperation sObjectTypeOperation) {
		return
				OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(sObjectTypeOperation.sObjectType) != null
						&& OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(sObjectTypeOperation.sObjectType)
						.contains(sObjectTypeOperation.operation);
	}

	public Boolean isExecutingExclusively(XAP_TRG_TriggerSObjectTypeOperation sObjectTypeOperation) {
		return this.isExecuting(sObjectTypeOperation)
				&& OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.size() == 1
				&& OPERATION_SET_IN_PROGRESS_BY_SOBJECT_TYPE_MAP.get(sObjectTypeOperation.sObjectType).size() == 1;
	}

	// Helpers  ---------------------------------------------------------------------------------------------------------

	@TestVisible
	private Boolean returnValueOrTrue(Boolean value) {
		return (value != null) ? value : true;
	}

	public List<XAP_TRG_TriggerContext> getTriggerProgressList() {
		return TRIGGER_IN_PROGRESS_LIST.clone();
	}
}
