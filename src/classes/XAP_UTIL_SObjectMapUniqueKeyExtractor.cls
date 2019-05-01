public virtual class XAP_UTIL_SObjectMapUniqueKeyExtractor {
    private static XAP_UTIL_SObjectMapUniqueKeyExtractor instance;
    protected XAP_UTIL_SObjectMapUniqueKeyExtractor() {
    }

    public static XAP_UTIL_SObjectMapUniqueKeyExtractor getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_SObjectMapUniqueKeyExtractor();
        }
        return instance;
    }

    public Map<Id, SObject> mapBySpecifiedIdField(List<SObject> sObjectList, SObjectField idField) {
        Map<Object, SObject> sObjectBySpecifiedObjectMap
                = new MapExtractor(idField, new XAP_PRED_SObjectFieldHasNonNullValue(idField))
                        .extractFrom(sObjectList);
        return (Map<Id, SObject>) JSON.deserialize(
                JSON.serialize(sObjectBySpecifiedObjectMap), Map<Id, SObject>.class
        );
    }

    public Map<String, SObject> mapBySpecifiedStringField(List<SObject> sObjectList, SObjectField stringField) {
        Map<Object, SObject> sObjectListBySpecifiedObjectMap
                = new MapExtractor(stringField, new XAP_PRED_SObjectFieldHasNonBlankValue(stringField))
                        .extractFrom(sObjectList);
        return (Map<String, SObject>) JSON.deserialize(
                JSON.serialize(sObjectListBySpecifiedObjectMap), Map<String, SObject>.class
        );
    }



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

            Map<Object, SObject> sObjectListByKeyMap = new Map<Object, SObject>();
            for (SObject sObj : sObjectList) {
                if (this.predicate.isTrueFor(sObj)) {
                    Object key = sObj.get(this.keyField);
                    if (sObjectListByKeyMap.containsKey(key)) {
                        throw new XAP_UTIL_MapManyToOneException(
                                'Unique key is expected: '
                                        + 'Key ' + key + ' is assigned to both'
                                        + ' 1: ' + sObj + ' and '
                                        + ' 2: ' + sObjectListByKeyMap.get(key)
                        );
                    }
                    sObjectListByKeyMap.put(key, sObj);
                }
            }

            return sObjectListByKeyMap;
        }
    }
}