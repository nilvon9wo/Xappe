// We deliberately do not use the Selector Framework here to keep this lightweight,
// as well as allow for it to be used completely independently.
public with sharing class XAP_TRG_TriggerStepSelector {
    private XAP_TRG_TriggerStepSelector(){
    }

    private static XAP_TRG_TriggerStepSelector instance;
    public static XAP_TRG_TriggerStepSelector getInstance() {
        if (instance == null) {
            instance = new XAP_TRG_TriggerStepSelector();
        }
        return instance;
    }

    public List<XAP_TRG_Trigger_Step__mdt> selectAll() {
        return [
                SELECT Class_Name__c, Is_Active__c, Operation_Timing__c, Operation_Type__c, Reuse_Instance__c,
                        SObject_Type__c, Sort_Order__c, Throw_Error_If_Class_Missing__c
                FROM XAP_TRG_Trigger_Step__mdt
                ORDER BY Sort_Order__c ASC
        ];
    }
}