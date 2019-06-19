public virtual class XAP_UTIL_SObjectValueSetExtractor {
	protected XAP_UTIL_SObjectValueSetExtractor() {
	}

	private static XAP_UTIL_SObjectValueSetExtractor instance;

	public static XAP_UTIL_SObjectValueSetExtractor getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_SObjectValueSetExtractor();
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
		return new Set<Id>((List<Id>) new ListForSetExtractor(extractedField, predicate)
				.extractFrom(sObjectList));
	}

	public virtual Set<String> extractNonBlankStringsFrom(List<SObject> sObjectList, SObjectField extractedField) {
		return this.extractStringSet(sObjectList, extractedField, new XAP_PRED_SObjectFieldHasNonBlankValue(extractedField));
	}

	public Set<String> extractStringSet(
			List<SObject> sObjectList,
			SObjectField extractedField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return new Set<String>((List<String>) new ListForSetExtractor(extractedField, predicate)
				.extractFrom(sObjectList));
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