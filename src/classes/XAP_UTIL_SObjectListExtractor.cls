public virtual class XAP_UTIL_SObjectListExtractor {
	protected XAP_UTIL_SObjectListExtractor() {
	}

	private static XAP_UTIL_SObjectListExtractor instance;

	public static XAP_UTIL_SObjectListExtractor getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_SObjectListExtractor();
		}
		return instance;
	}

	// Extract true for predicate collection ----------------------------------------------------------------------

	public virtual List<SObject> extractWhereAllPredicatesTrue(
			List<SObject> sObjectList,
			List<XAP_PRED_SObjectPredicateIntf> predicateList
	) {
		return (new AllPredicateListExtractor(predicateList))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereTrue(
			List<SObject> sObjectList,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return (new AllPredicateListExtractor(new List<XAP_PRED_SObjectPredicateIntf>{predicate}))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereNotNull(List<SObject> sObjectList, SObjectField sObjectField) {
		return this.extractWhereTrue(sObjectList, new XAP_PRED_SObjectFieldIsNotNull(sObjectField));
	}

	private class AllPredicateListExtractor extends ListExtractor {
		List<XAP_PRED_SObjectPredicateIntf> predicateList;

		AllPredicateListExtractor(List<XAP_PRED_SObjectPredicateIntf> predicateList) {
			this.predicateList = predicateList;
		}

		override Boolean isTrueFor(SObject sObj) {
			for (XAP_PRED_SObjectPredicateIntf predicate : predicateList) {
				if (!predicate.isTrueFor(sObj)) {
					return false;
				}
			}
			return true;
		}
	}

	// Abstract -----------------------------------------------------------------------------------------

	abstract public class ListExtractor {
		public List<SObject> extractFrom(List<SObject> sObjectList) {
			List<SObject> resultList = new List<SObject>();
			for (SObject sObj : sObjectList) {
				if (this.isTrueFor(sObj)) {
					resultList.add(sObj);
				}
			}
			return resultList;
		}

		abstract Boolean isTrueFor(SObject sObj);
	}
}