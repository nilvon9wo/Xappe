public with sharing class XAP_TRG_TriggerException extends Exception {
    XAP_TRG_Trigger_Step__mdt stepRecord;
    XAP_TRG_TriggerSteppable stepInstance;
    XAP_TRG_TriggerStepFailure failure;

    public XAP_TRG_TriggerException(TypeException ex, XAP_TRG_Trigger_Step__mdt stepRecord){
        this('Failure during creation of ' + stepRecord.Class_Name__c, ex);
        this.stepRecord = stepRecord;
    }

    public XAP_TRG_TriggerException(XAP_TRG_TriggerStepFailure failure, XAP_TRG_TriggerSteppable stepInstance){
        this('Failure during execution of ' + stepInstance, failure.getException());
        this.stepInstance = stepInstance;
        this.failure = failure;
    }
}