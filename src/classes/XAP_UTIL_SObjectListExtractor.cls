public virtual class XAP_UTIL_SObjectListExtractor {
	private static XAP_UTIL_SObjectListExtractor instance;
	protected XAP_UTIL_SObjectListExtractor() {
	}

	public static XAP_UTIL_SObjectListExtractor getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_SObjectListExtractor();
		}
		return instance;
	}

	public virtual List<SObject> extractWhereAllPredicatesTrue(
			List<SObject> sObjectList,
			List<XAP_PRED_SObjectPredicateIntf> predicateList
	) {
		return new ListExtractor(new XAP_PRED_AllPredicatesTrue(predicateList))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereAnyPredicatesTrue(
			List<SObject> sObjectList,
			List<XAP_PRED_SObjectPredicateIntf> predicateList
	) {
		return new ListExtractor(new XAP_PRED_AnyPredicatesTrue(predicateList))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereSpecifiedValue(
			List<SObject> sObjectList,
			SObjectField sObjectField,
			String value
	) {
		return new ListExtractor(new XAP_PRED_SObjectFieldHasTargetValue(sObjectField, value))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereTrue(List<SObject> sObjectList, SObjectField BooleanField) {
		return new ListExtractor(new XAP_PRED_SObjectFieldTargetFieldIsTrue(BooleanField))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereFalse(List<SObject> sObjectList, SObjectField BooleanField) {
		return new ListExtractor(new XAP_PRED_SObjectFieldTargetFieldIsFalse(BooleanField))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereNotNull(List<SObject> sObjectList, SObjectField sObjectField) {
		return new ListExtractor(new XAP_PRED_SObjectFieldHasNonNullValue(sObjectField))
				.extractFrom(sObjectList);
	}

	public virtual List<SObject> extractWhereIsNull(List<SObject> sObjectList, SObjectField sObjectField) {
		return new ListExtractor(new XAP_PRED_SObjectFieldHasNullValue(sObjectField))
				.extractFrom(sObjectList);
	}

	private class ListExtractor {
		XAP_PRED_SObjectPredicateIntf predicate;

		ListExtractor(XAP_PRED_SObjectPredicateIntf predicate) {
			this.predicate = predicate;
		}

		public List<SObject> extractFrom(List<SObject> sObjectList) {
			List<SObject> resultList = new List<SObject>();
			for (SObject sObj : sObjectList) {
				if (this.predicate.isTrueFor(sObj)) {
					resultList.add(sObj);
				}
			}
			return resultList;
		}
	}
}