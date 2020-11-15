public with sharing class XAP_PRED_SObjectFieldIsChanged implements XAP_PRED_SObjectPredicateIntf {
    private Map<Id, SObject> oldSObjectByIdMap;
    private SObjectField sObjectField;

    public XAP_PRED_SObjectFieldIsChanged(Map<Id, SObject> oldSObjectByIdMap, SObjectField sObjectField) {
        this.oldSObjectByIdMap = oldSObjectByIdMap;
        this.sObjectField = sObjectField;
    }

    public Boolean isTrueFor(SObject newValue) {
        SObject oldValue = this.oldSObjectByIdMap.get(newValue.Id);
        return oldValue == null
                || newValue.get(this.sObjectField) != oldValue.get(this.sObjectField);
    }
}