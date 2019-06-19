public class XAP_PRED_SObjectFieldHasNonNullValue implements XAP_PRED_SObjectPredicateIntf {
	SObjectField targetField;

	public XAP_PRED_SObjectFieldHasNonNullValue(SObjectField targetField) {
		this.targetField = targetField;
	}
	public Boolean isTrueFor(SObject sObj) {
		return (sObj.get(this.targetField) != null);
	}
}