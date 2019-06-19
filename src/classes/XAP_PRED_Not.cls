public class XAP_PRED_Not implements XAP_PRED_SObjectPredicateIntf {
	XAP_PRED_SObjectPredicateIntf predicate;

	public XAP_PRED_Not(XAP_PRED_SObjectPredicateIntf predicate) {
		this.predicate = predicate;
	}

	public Boolean isTrueFor(SObject sObj) {
		return !this.predicate
				.isTrueFor(sObj);
	}
}