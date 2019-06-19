public class XAP_PRED_AnyPredicatesFalse implements XAP_PRED_SObjectPredicateIntf {
	List<XAP_PRED_SObjectPredicateIntf> predicateList;

	public XAP_PRED_AnyPredicatesFalse(List<XAP_PRED_SObjectPredicateIntf> predicateList) {
		this.predicateList = predicateList;
	}

	public Boolean isTrueFor(SObject sObj) {
		for (XAP_PRED_SObjectPredicateIntf predicate : this.predicateList) {
			if (!predicate.isTrueFor(sObj)) {
				return true;
			}
		}
		return false;
	}
}