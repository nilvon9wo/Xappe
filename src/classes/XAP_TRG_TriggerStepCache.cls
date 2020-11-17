public with sharing class XAP_TRG_TriggerStepCache {
    private XAP_TRG_TriggerStepSelector stepSelector;

    private XAP_TRG_TriggerStepCache(XAP_TRG_TriggerStepSelector stepSelector) {
        this.stepSelector = stepSelector;
    }

    private XAP_TRG_TriggerStepCache() {
        this(XAP_TRG_TriggerStepSelector.getInstance());
    }

    private static XAP_TRG_TriggerStepCache instance;
    public static XAP_TRG_TriggerStepCache getInstance() {
        if (instance == null) {
            instance = new XAP_TRG_TriggerStepCache();
        }
        return instance;
    }

    private static final String SEPARATOR = ':::';

    private Map<String, List<XAP_TRG_Trigger_Step__mdt>> stepListByKeyMap {
        get {
            if (this.stepListByKeyMap == null) {
                this.stepListByKeyMap = this.buildStepsByKeyMap();
            }
            return this.stepListByKeyMap;
        }
        set;
    }

    private Map<String, XAP_TRG_TriggerSteppable> stepByClassNameMap = new Map<String, XAP_TRG_TriggerSteppable>();

    public List<XAP_TRG_TriggerSteppable> get(XAP_TRG_TriggerContext context) {
        String key = this.createKey(context);
        List<XAP_TRG_Trigger_Step__mdt> stepRecordsList = this.stepListByKeyMap.get(key);
        if (stepRecordsList.isEmpty()) {
            throw new XAP_TRG_TriggerException('No steps found for ' + context.sObjectType + ' ' + context.operationType);
        }

        return this.get(stepRecordsList);
    }

    private List<XAP_TRG_TriggerSteppable> get(List<XAP_TRG_Trigger_Step__mdt> stepRecordsList) {
        List<XAP_TRG_TriggerSteppable> stepInstanceList = new List<XAP_TRG_TriggerSteppable>();
        XAP_TRG_Trigger_Step__mdt previousStepRecord = new XAP_TRG_Trigger_Step__mdt();
        for (XAP_TRG_Trigger_Step__mdt currentStepRecord : stepRecordsList) {
            if (
                    currentStepRecord.Is_Active__c
                            && this.checkSortOrderUniqueness(currentStepRecord, previousStepRecord)
                    ) {
                stepInstanceList.add(this.get(currentStepRecord));
                previousStepRecord = currentStepRecord;
            }
            else {
                System.debug(LoggingLevel.WARN, 'Inactive step: ' + currentStepRecord.DeveloperName);
            }
        }
        return stepInstanceList;
    }

    private Boolean checkSortOrderUniqueness(
            XAP_TRG_Trigger_Step__mdt currentStepRecord,
            XAP_TRG_Trigger_Step__mdt previousStepRecord
    ) {
        if (currentStepRecord.Sort_Order__c == previousStepRecord.Sort_Order__c) {
            throw new XAP_TRG_TriggerException(
                    'Ambiguous sort value in ' + currentStepRecord.DeveloperName + '.  '
                            + 'Each sort value can only be user once '
                            + 'per combination of SObject Type, Operation Timing, and Operation Type.'
            );
        }
        return true;
    }

    private  XAP_TRG_TriggerSteppable get(XAP_TRG_Trigger_Step__mdt stepRecord) {
        String className = stepRecord.Class_Name__c;
        XAP_TRG_TriggerSteppable stepInstance = this.stepByClassNameMap.get(className);
        return (stepInstance == null)
                ? this.get(stepRecord, Type.forName(className))
                : stepInstance;
    }

    public XAP_TRG_TriggerSteppable get(XAP_TRG_Trigger_Step__mdt stepRecord, Type stepType) {
        if (stepType == null) {
            this.handleMissingClass(stepRecord, 'missing');
        }

        if (stepType != null) {
            try {
                return this.createStepInstance(stepRecord, stepType);
            }
            catch (TypeException ex) {
                this.handleMissingClass(stepRecord, 'inapplicable');
            }
        }

        return null;
    }

    private void handleMissingClass(XAP_TRG_Trigger_Step__mdt stepRecord, String issue) {
        String message = 'Class ' + stepRecord.Class_Name__c + ' is ' + issue
                + ' for ' + stepRecord.DeveloperName + ' trigger step.';

        if (stepRecord.Throw_Error_If_Class_Missing__c) {
            throw new XAP_TRG_TriggerException(message);
        }
        else {
            System.debug(LoggingLevel.WARN, message);
        }
    }


    private XAP_TRG_TriggerSteppable createStepInstance(XAP_TRG_Trigger_Step__mdt stepRecord, Type stepType) {
        XAP_TRG_TriggerSteppable stepInstance = (XAP_TRG_TriggerSteppable) stepType.newInstance();

        if (stepRecord.Reuse_Instance__c) {
            this.stepByClassNameMap.put(stepRecord.Class_Name__c, stepInstance);
        }

        return stepInstance;
    }

    private Map<String, List<XAP_TRG_Trigger_Step__mdt>> buildStepsByKeyMap() {
        List<XAP_TRG_Trigger_Step__mdt> stepList = this.stepSelector.selectAll();
        return this.buildStepsByKeyMap(stepList);
    }

    private Map<String, List<XAP_TRG_Trigger_Step__mdt>> buildStepsByKeyMap(List<XAP_TRG_Trigger_Step__mdt> stepList) {
        Map<String, List<XAP_TRG_Trigger_Step__mdt>> stepListByKeyMap = new Map<String, List<XAP_TRG_Trigger_Step__mdt>>();
        for (XAP_TRG_Trigger_Step__mdt step : stepList) {
            String key = this.createKey(step);
            List<XAP_TRG_Trigger_Step__mdt> keyStepList = stepListByKeyMap.get(key);
            if (keyStepList == null) {
                keyStepList = new List<XAP_TRG_Trigger_Step__mdt>();
                stepListByKeyMap.put(key, keyStepList);
            }
            keyStepList.add(step);
        }
        return stepListByKeyMap;
    }

    private String createKey(XAP_TRG_TriggerContext triggerContext) {
        return this.createKey(triggerContext.sObjectType, triggerContext.operationType);
    }

    private String createKey(SObjectType sObjectType, TriggerOperation operation) {
        String sObjectName = sObjectType.getDescribe()
                .getName();
        String operationName = operation.name();
        return createKey(sObjectName, operationName);
    }

    private String createKey(XAP_TRG_Trigger_Step__mdt step) {
        String operationName = step.DeveloperName + '_' + step.Operation_Type__c;
        return this.createKey(step.SObject_Type__c, step.DeveloperName);
    }

    private String createKey(String sObjectName, String operationName) {
        return (sObjectName + SEPARATOR + operationName).toUpperCase();
    }
}