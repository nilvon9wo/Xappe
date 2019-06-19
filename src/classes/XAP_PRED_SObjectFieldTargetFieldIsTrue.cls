public class XAP_PRED_SObjectFieldTargetFieldIsTrue implements XAP_PRED_SObjectPredicateIntf {
	SObjectField BooleanField;

	public XAP_PRED_SObjectFieldTargetFieldIsTrue(SObjectField targetField) {
		this.BooleanField = targetField;
	}
	public Boolean isTrueFor(SObject sObj) {
		return (Boolean) sObj.get(this.BooleanField);
	}
}