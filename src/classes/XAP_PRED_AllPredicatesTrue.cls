public class XAP_PRED_AllPredicatesTrue implements XAP_PRED_SObjectPredicateIntf {
	List<XAP_PRED_SObjectPredicateIntf> predicateList;

	public XAP_PRED_AllPredicatesTrue(List<XAP_PRED_SObjectPredicateIntf> predicateList) {
		this.predicateList = predicateList;
	}

	public Boolean isTrueFor(SObject sObj) {
		for (XAP_PRED_SObjectPredicateIntf predicate : this.predicateList) {
			if (!predicate.isTrueFor(sObj)) {
				return false;
			}
		}
		return true;
	}
}