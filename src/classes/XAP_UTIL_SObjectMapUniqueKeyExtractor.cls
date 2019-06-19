public virtual class XAP_UTIL_SObjectMapUniqueKeyExtractor {
	private XAP_UTIL_SObjectMapUniqueKeyExtractor() {
	}

	private static XAP_UTIL_SObjectMapUniqueKeyExtractor instance;
	public static XAP_UTIL_SObjectMapUniqueKeyExtractor getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_SObjectMapUniqueKeyExtractor();
		}
		return instance;
	}

	// Return by Object -- Most efficient -----------------------------------------------------------------------------

	public Map<Object, SObject> toSObjectByObjectMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return new MapExtractor(keyField, predicate)
				.extractFrom(sObjectList);
	}

	public Map<Object, SObject> toSObjectByObjectMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toSObjectByObjectMap(sObjectList, keyField, new XAP_PRED_SObjectFieldHasNonBlankValue(keyField));
	}

	// Return by Id -- Inefficient ------------------------------------------------------------------------------------

	public Map<Id, SObject> toSObjectByIdMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		Map<Object, SObject> sObjectByObjectMap
				= this.toSObjectByObjectMap(sObjectList, keyField, predicate);

		Map<Id, SObject> sObjectByIdMap = new Map<Id, SObject>();
		for (Object key : sObjectByObjectMap.keySet()) {
			sObjectByIdMap.put((Id) key, sObjectByObjectMap.get(key));
		}
		return sObjectByIdMap;
	}

	public Map<Id, SObject> toSObjectByIdMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toSObjectByIdMap(sObjectList, keyField, new XAP_PRED_SObjectFieldHasNonNullValue(keyField));
	}

	public Map<Id, SObject> toDereferencedSObjectByIdMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return (Map<Id, SObject>) JSON.deserialize(
				this.toJson(sObjectList, keyField, predicate),
				Map<Id, SObject>.class
		);
	}

	public Map<Id, SObject> toDereferencedSObjectByIdMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toDereferencedSObjectByIdMap(
				sObjectList, keyField, new XAP_PRED_SObjectFieldHasNonNullValue(keyField)
		);
	}

	// Return by String -- Inefficient --------------------------------------------------------------------------------

	public Map<String, SObject> toSObjectByStringMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		Map<Object, SObject> sObjectByObjectMap
				= this.toSObjectByObjectMap(sObjectList, keyField, predicate);

		Map<String, SObject> sObjectByStringMap = new Map<String, SObject>();
		for (Object key : sObjectByObjectMap.keySet()) {
			sObjectByStringMap.put((String) key, sObjectByObjectMap.get(key));
		}
		return sObjectByStringMap;
	}

	public Map<String, SObject> toSObjectByStringMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toSObjectByStringMap(sObjectList, keyField);
	}

	public Map<String, SObject> toDereferencedSObjectByStringMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return (Map<String, SObject>) JSON.deserialize(
				this.toJson(sObjectList, keyField, predicate),
				Map<String, SObject>.class
		);
	}

	public Map<String, SObject> toDereferencedSObjectByStringMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toDereferencedSObjectByStringMap(sObjectList, keyField);
	}

	// Return as Json: Inefficient and Breaks Object references -------------------------------------------------------

	public String toJson(List<SObject> sObjectList, SObjectField keyField, XAP_PRED_SObjectPredicateIntf predicate) {
		return JSON.serialize(
				this.toSObjectByObjectMap(sObjectList, keyField, predicate)
		);
	}

	// Extractor class ------------------------------------------------------------------------------------------------

	private class MapExtractor {
		SObjectField keyField;
		XAP_PRED_SObjectPredicateIntf predicate;

		MapExtractor(SObjectField keyField, XAP_PRED_SObjectPredicateIntf predicate) {
			this.keyField = keyField;
			this.predicate = predicate;
		}

		public Map<Object, SObject> extractFrom(List<SObject> sObjectList) {
			if (sObjectList == null || sObjectList.isEmpty()) {
				return null;
			}

			Map<Object, SObject> sObjectByKeyMap = new Map<Object, SObject>();
			for (SObject sObj : sObjectList) {
				if (this.predicate.isTrueFor(sObj)) {
					Object key = sObj.get(this.keyField);
					if (sObjectByKeyMap.containsKey(key)) {
						throw new XAP_UTIL_MapManyToOneException(
								'Unique key is expected: '
										+ 'Key ' + key + ' is assigned to both'
										+ ' 1: ' + sObj + ' and '
										+ ' 2: ' + sObjectByKeyMap.get(key)
						);
					}
					sObjectByKeyMap.put(key, sObj);
				}
			}

			return sObjectByKeyMap;
		}
	}
}