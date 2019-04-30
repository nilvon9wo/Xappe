public class XAP_PRED_SObjectFieldTargetFieldIsTrue implements XAP_PRED_SObjectPredicateIntf {
    SObjectField booleanField;

    public XAP_PRED_SObjectFieldTargetFieldIsTrue(SObjectField targetField) {
        this.booleanField = targetField;
    }
    public Boolean isTrueFor(SObject sObj) {
        return (Boolean) sObj.get(this.booleanField);
    }
}