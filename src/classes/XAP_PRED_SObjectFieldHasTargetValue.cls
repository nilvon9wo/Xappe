public class XAP_PRED_SObjectFieldHasTargetValue implements XAP_PRED_SObjectPredicateIntf {
	SObjectField targetField;
	Object targetValue;

	public XAP_PRED_SObjectFieldHasTargetValue(SObjectField targetField, Object targetValue) {
		this.targetField = targetField;
		this.targetValue = targetValue;
	}

	public Boolean isTrueFor(SObject newSObject) {
		return this.targetValue == newSObject.get(this.targetField);
	}
}