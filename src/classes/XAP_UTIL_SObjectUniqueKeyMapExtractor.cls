public virtual class XAP_UTIL_SObjectUniqueKeyMapExtractor {
    private static XAP_UTIL_SObjectUniqueKeyMapExtractor instance;
    protected XAP_UTIL_SObjectUniqueKeyMapExtractor() {
    }

    public static XAP_UTIL_SObjectUniqueKeyMapExtractor getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_SObjectUniqueKeyMapExtractor();
        }
        return instance;
    }

    public static Map<Id, SObject> mapBySpecifiedIdField(List<SObject> homogeneousSObjectList, SObjectField idField) {
        Map<Object, SObject> sObjectBySpecifiedObjectMap
                = new MapByUniqueKeyExtractor(idField, new XAP_PRED_SObjectFieldHasNonNullValue(idField))
                        .extractFrom(homogeneousSObjectList);

        String mapType = 'Map<Id, ' + homogeneousSObjectList[0].getSObjectType() + '>';
        Map<Id, SObject> concreteSObjectListByIdMap = (Map<Id, SObject>) Type.forName(mapType).newInstance();
        // FIXME: concreteSObjectListByIdMap.putAll(sObjectBySpecifiedObjectMap);
        return concreteSObjectListByIdMap;
    }

    private class MapByUniqueKeyExtractor {
        SObjectField keyField;
        XAP_PRED_SObjectPredicateIntf predicate;

        MapByUniqueKeyExtractor(SObjectField keyField, XAP_PRED_SObjectPredicateIntf predicate) {
            this.keyField = keyField;
            this.predicate = predicate;
        }

        public Map<Object, SObject> extractFrom(List<SObject> homogeneousSObjectList) {
            if (homogeneousSObjectList == null || homogeneousSObjectList.isEmpty()) {
                return null;
            }

            Map<Object, SObject> sObjectListByKeyMap = new Map<Object, SObject>();
            for (SObject sObj : homogeneousSObjectList) {
                if (this.predicate.isTrueFor(sObj)) {
                    Object key = sObj.get(this.keyField);
                    if (sObjectListByKeyMap.containsKey(key)) {
                        throw new XAP_UTIL_MapManyToOneException(
                                'Many-to-one relationships.  '
                                        + ' Id ' + sObj.Id + ' is assigned to both'
                                        + ' 1: ' + sObj + ' and '
                                        + ' 2: ' + sObjectListByKeyMap.get(sObj.Id)
                        );
                    }
                    sObjectListByKeyMap.put(key, sObj);
                }
            }

            return sObjectListByKeyMap;
        }
    }
}