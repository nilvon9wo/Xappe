public class XAP_PRED_SObjectFieldIsBlank implements XAP_PRED_SObjectPredicateIntf {
    SObjectField targetField;

    public XAP_PRED_SObjectFieldIsBlank(SObjectField targetField) {
        this.targetField = targetField;
    }

    public Boolean isTrueFor(SObject newSObject) {
        return String.isBlank(String.valueOf(newSObject.get(this.targetField)));
    }
}