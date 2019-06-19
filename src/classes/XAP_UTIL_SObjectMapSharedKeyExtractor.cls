public virtual class XAP_UTIL_SObjectMapSharedKeyExtractor {
	private XAP_UTIL_SObjectMapSharedKeyExtractor() {
	}

	private static XAP_UTIL_SObjectMapSharedKeyExtractor instance;
	public static XAP_UTIL_SObjectMapSharedKeyExtractor getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_SObjectMapSharedKeyExtractor();
		}
		return instance;
	}
	// Return by Object -- Most efficient -----------------------------------------------------------------------------

	public Map<Object, List<SObject>> toSObjectListByObjectMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return new MapExtractor(keyField, predicate)
				.extractFrom(sObjectList);
	}

	public Map<Object, List<SObject>> toSObjectListByObjectMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toSObjectListByObjectMap(sObjectList, keyField, new XAP_PRED_SObjectFieldHasNonBlankValue(keyField));
	}

	// Return by Id -- Inefficient ------------------------------------------------------------------------------------

	public Map<Id, List<SObject>> toSObjectListByIdMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		Map<Object, List<SObject>> sObjectListByObjectMap
				= this.toSObjectListByObjectMap(sObjectList, keyField, predicate);

		Map<Id, List<SObject>> sObjectListByIdMap = new Map<Id, List<SObject>>();
		for (Object key : sObjectListByObjectMap.keySet()) {
			sObjectListByIdMap.put((Id) key, sObjectListByObjectMap.get(key));
		}
		return sObjectListByIdMap;
	}

	public Map<Id, List<SObject>> toSObjectListByIdMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toSObjectListByIdMap(sObjectList, keyField, new XAP_PRED_SObjectFieldHasNonNullValue(keyField));
	}

	public Map<Id, List<SObject>> toDereferencedSObjectListByIdMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return (Map<Id, List<SObject>>) JSON.deserialize(
				this.toJson(sObjectList, keyField, predicate),
				Map<Id, List<SObject>>.class
		);
	}

	public Map<Id, List<SObject>> toDereferencedSObjectListByIdMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toDereferencedSObjectListByIdMap(
				sObjectList, keyField, new XAP_PRED_SObjectFieldHasNonNullValue(keyField)
		);
	}

	// Return by String -- Inefficient --------------------------------------------------------------------------------

	public Map<String, List<SObject>> toSObjectListByStringMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		Map<Object, List<SObject>> sObjectListByObjectMap
				= this.toSObjectListByObjectMap(sObjectList, keyField, predicate);

		Map<String, List<SObject>> sObjectListByStringMap = new Map<String, List<SObject>>();
		for (Object key : sObjectListByObjectMap.keySet()) {
			sObjectListByStringMap.put((String) key, sObjectListByObjectMap.get(key));
		}
		return sObjectListByStringMap;
	}

	public Map<String, List<SObject>> toSObjectListByStringMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toSObjectListByStringMap(sObjectList, keyField);
	}

	public Map<String, List<SObject>> toDereferencedSObjectListByStringMap(
			List<SObject> sObjectList,
			SObjectField keyField,
			XAP_PRED_SObjectPredicateIntf predicate
	) {
		return (Map<String, List<SObject>>) JSON.deserialize(
				this.toJson(sObjectList, keyField, predicate),
				Map<String, List<SObject>>.class
		);
	}

	public Map<String, List<SObject>> toDereferencedSObjectListByStringMap(List<SObject> sObjectList, SObjectField keyField) {
		return this.toDereferencedSObjectListByStringMap(sObjectList, keyField);
	}

	// Return as Json: Inefficient and Breaks Object references -------------------------------------------------------

	public String toJson(List<SObject> sObjectList, SObjectField keyField, XAP_PRED_SObjectPredicateIntf predicate) {
		return JSON.serialize(
				this.toSObjectListByObjectMap(sObjectList, keyField, predicate)
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

		public Map<Object, List<SObject>> extractFrom(List<SObject> sObjectList) {
			if (sObjectList == null || sObjectList.isEmpty()) {
				return null;
			}

			Map<Object, List<SObject>> sObjectListByKeyMap = new Map<Object, List<SObject>>();
			for (SObject sObj : sObjectList) {
				if (this.predicate.isTrueFor(sObj)) {
					Object key = sObj.get(this.keyField);
					if (!sObjectListByKeyMap.containsKey(key)) {
						sObjectListByKeyMap.put(key, new List<SObject>());
					}
					sObjectListByKeyMap.get(key).add(sObj);
				}
			}
			return sObjectListByKeyMap;
		}
	}
}