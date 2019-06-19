public class XAP_PRED_SObjectFieldHasNullValue implements XAP_PRED_SObjectPredicateIntf {
	SObjectField targetField;

	public XAP_PRED_SObjectFieldHasNullValue(SObjectField targetField) {
		this.targetField = targetField;
	}
	public Boolean isTrueFor(SObject sObj) {
		return (sObj.get(this.targetField) == null);
	}
}