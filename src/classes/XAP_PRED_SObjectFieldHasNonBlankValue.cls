public class XAP_PRED_SObjectFieldHasNonBlankValue implements XAP_PRED_SObjectPredicateIntf {
	SObjectField targetField;

	public XAP_PRED_SObjectFieldHasNonBlankValue(SObjectField targetField) {
		this.targetField = targetField;
	}
	public Boolean isTrueFor(SObject sObj) {
		return String.isNotBlank(
				String.valueOf(sObj.get(this.targetField))
		);
	}
}