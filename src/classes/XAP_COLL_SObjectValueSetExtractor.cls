public virtual class XAP_COLL_SObjectValueSetExtractor {
	protected XAP_COLL_SObjectValueSetExtractor() {
	}

	private static XAP_COLL_SObjectValueSetExtractor instance;

	public static XAP_COLL_SObjectValueSetExtractor getInstance() {
		if (instance == null) {
			instance = new XAP_COLL_SObjectValueSetExtractor();
		}
		return instance;
	}

	public virtual Set<Id> extractNonNullIdsFrom(List<SObject> sObjectList, SObjectField extractedField) {
		return this.extractIdSet(sObjectList, extractedField, new XAP_PRED_SObjectFieldHasNonNullValue(extractedField));
	}

	public Set<Id> extractIdSet(
			List<SObject> sObjectList,
			SObjectField extractedField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		Set<Id> idSet = new Set<Id>();
		List<Object> objectList = new ListForSetExtractor(extractedField, predicate)
				.extractFrom(sObjectList);
		for (Object obj : objectList) {
			idSet.add((Id) obj);
		}
		return idSet;
	}

	public virtual Set<String> extractNonNullStringsFrom(List<SObject> sObjectList, SObjectField extractedField) {
		return this.extractStringSet(sObjectList, extractedField, new XAP_PRED_SObjectFieldHasNonNullValue(extractedField));
	}

	public Set<String> extractStringSet(
			List<SObject> sObjectList,
			SObjectField extractedField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		Set<String> stringSet = new Set<String>();
		List<Object> objectList = new ListForSetExtractor(extractedField, predicate)
				.extractFrom(sObjectList);
		for (Object obj : objectList) {
			stringSet.add((String) obj);
		}
		return stringSet;
	}

	private class ListForSetExtractor {
		SObjectField extractionField;
		XAP_PRED_SObjectPredicateIntf predicate;

		ListForSetExtractor(SObjectField extractedField, XAP_PRED_SObjectPredicateIntf predicate) {
			this.extractionField = extractedField;
			this.predicate = predicate;
		}

		public List<Object> extractFrom(List<SObject> sObjectList) {
			Set<Object> resultSet = new Set<Object>();
			for (SObject sObj : sObjectList) {
				if (this.predicate.isTrueFor(sObj)) {
					resultSet.add(sObj.get(extractionField));
				}
			}
			return new List<Object>(resultSet);
		}
	}
}