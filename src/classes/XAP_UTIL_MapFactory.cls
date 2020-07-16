public virtual class XAP_UTIL_MapFactory {
    protected XAP_UTIL_MapFactory() {
    }

    private static XAP_UTIL_MapFactory instance;

    public static XAP_UTIL_MapFactory getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_MapFactory();
        }
        return instance;
    }

	public Map<Id, List<SObject>> mapBySpecifiedIdField(List<SObject> homogeneousSObjectList, SObjectField idField) {
		if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
			return null;
		}

		Map<Id, List<SObject>> sObjectListBySpecifiedIdMap = new Map<Id, List<SObject>>();
		for (SObject sObj : homogeneousSObjectList) {
			Id specifiedId = (Id) sObj.get(idField);
			if (!String.isBlank(specifiedId)) {
				if (!sObjectListBySpecifiedIdMap.containsKey(specifiedId)) {
					sObjectListBySpecifiedIdMap.put(specifiedId, new List<SObject>());
				}
				sObjectListBySpecifiedIdMap.get(specifiedId).add(sObj);
			}
		}

		String mapType = 'Map<Id, List<' + homogeneousSObjectList[0].getSObjectType() + '>>';
		Map<Id, List<SObject>> concreteSObjectListByIdMap = (Map<Id, List<SObject>>) Type.forName(mapType).newInstance();
		concreteSObjectListByIdMap.putAll(sObjectListBySpecifiedIdMap);
		return concreteSObjectListByIdMap;
	}

	public Map<Id, SObject> mapByUniqueSpecifiedIdField(List<SObject> sObjectList, SObjectField idField) {
		if (sObjectList == null || sObjectList.isEmpty()) {
			return null;
		}

		Map<Id, SObject> sObjectBySpecifiedIdMap = new Map<Id, SObject>();
		for (SObject sObj : sObjectList) {
			Id specifiedId = (Id) sObj.get(idField);
			if (!String.isBlank(specifiedId)) {
				if (sObjectBySpecifiedIdMap.containsKey(specifiedId)) {
					throw new XAP_UTIL_MapManyToOneException(
							'Many-to-one relationships.  '
									+ ' Id ' + specifiedId + ' is assigned to both'
									+ ' 1: ' + sObj + ' and '
									+ ' 2: ' + sObjectBySpecifiedIdMap.get(specifiedId)
					);
				}
				sObjectBySpecifiedIdMap.put(specifiedId, sObj);
			}
		}

		return sObjectBySpecifiedIdMap;
	}

	public Map<String, SObject> mapByUniqueSpecifiedStringField(List<SObject> sObjectList, SObjectField stringField) {
		if (sObjectList == null || sObjectList.isEmpty()) {
			return null;
		}

		Map<String, SObject> sObjectBySpecifiedStringMap = new Map<String, SObject>();
		for (SObject sObj : sObjectList) {
			String specifiedId = (String) sObj.get(stringField);
			if (!String.isBlank(specifiedId)) {
				if (sObjectBySpecifiedStringMap.containsKey(specifiedId)) {
					throw new XAP_UTIL_MapManyToOneException(
							'Many-to-one relationships.  '
									+ ' Id ' + specifiedId + ' is assigned to both'
									+ ' 1: ' + sObj + ' and '
									+ ' 2: ' + sObjectBySpecifiedStringMap.get(specifiedId)
					);
				}
				sObjectBySpecifiedStringMap.put(specifiedId, sObj);
			}
		}

		return sObjectBySpecifiedStringMap;
	}

	// NOTE: This method ignores duplicate values.
	// The last SObject to be placed into the Map "wins".
	// We need this because (for example) the multiple Cases may reference the same client order.
	public virtual Map<String, SObject> mapLastQualifiedSObjectByNonuniqueSpecifiedFields(
			List<SObject> homogeneousSObjectList,
			Set<SObjectField> sObjectFieldSet
	) {
		if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
			return null;
		}

		String mapType = 'Map<String,' + homogeneousSObjectList[0].getSObjectType() + '>';
		Map<String, SObject> sObjectBySpecifiedFieldsMap = (Map<String, SObject>) Type.forName(mapType).newInstance();
		for (SObject sObj : homogeneousSObjectList) {
			for (SObjectField sObjectField : sObjectFieldSet) {
				String value = String.valueOf(sObj.get(sObjectField));
				if (!String.isBlank(value)) {
					sObjectBySpecifiedFieldsMap.put(value, sObj);
				}
			}
		}

		return sObjectBySpecifiedFieldsMap;
	}
}