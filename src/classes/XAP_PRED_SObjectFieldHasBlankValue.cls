public class XAP_PRED_SObjectFieldHasBlankValue implements XAP_PRED_SObjectPredicateIntf {
	SObjectField targetField;

	public XAP_PRED_SObjectFieldHasBlankValue(SObjectField targetField) {
		this.targetField = targetField;
	}
	public Boolean isTrueFor(SObject sObj) {
		return String.isBlank(
				String.valueOf(sObj.get(this.targetField))
		);
	}
}