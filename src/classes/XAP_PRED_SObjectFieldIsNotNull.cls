public class XAP_PRED_SObjectFieldIsNotNull implements XAP_PRED_SObjectPredicateIntf {
	SObjectField targetField;

	public XAP_PRED_SObjectFieldIsNotNull(SObjectField targetField) {
		this.targetField = targetField;
	}

	public Boolean isTrueFor(SObject newSObject) {
		return newSObject.get(this.targetField) != null;
	}
}