public class XAP_PRED_SObjectFieldTargetFieldIsFalse implements XAP_PRED_SObjectPredicateIntf {
    SObjectField booleanField;

    public XAP_PRED_SObjectFieldTargetFieldIsFalse(SObjectField targetField) {
        this.booleanField = targetField;
    }
    public Boolean isTrueFor(SObject sObj) {
        return !(Boolean) sObj.get(this.booleanField);
    }
}