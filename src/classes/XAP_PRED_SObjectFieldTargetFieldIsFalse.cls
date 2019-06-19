public class XAP_PRED_SObjectFieldTargetFieldIsFalse implements XAP_PRED_SObjectPredicateIntf {
	SObjectField BooleanField;

	public XAP_PRED_SObjectFieldTargetFieldIsFalse(SObjectField targetField) {
		this.BooleanField = targetField;
	}
	public Boolean isTrueFor(SObject sObj) {
		return !(Boolean) sObj.get(this.BooleanField);
	}
}