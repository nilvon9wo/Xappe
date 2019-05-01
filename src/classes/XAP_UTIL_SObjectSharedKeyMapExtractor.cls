public virtual class XAP_UTIL_SObjectSharedKeyMapExtractor {
    private static XAP_UTIL_SObjectSharedKeyMapExtractor instance;
    protected XAP_UTIL_SObjectSharedKeyMapExtractor() {
    }

    public static XAP_UTIL_SObjectSharedKeyMapExtractor getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_SObjectSharedKeyMapExtractor();
        }
        return instance;
    }

    public Map<Id, List<SObject>> mapBySpecifiedIdField(List<SObject> sObjectList, SObjectField idField) {
        Map<Object, List<SObject>> sObjectListBySpecifiedObjectMap
                = new MapBySharedKeyExtractor(idField, new XAP_PRED_SObjectFieldHasNonNullValue(idField))
                        .extractFrom(sObjectList);
        return (Map<Id, List<SObject>>) JSON.deserialize(
                JSON.serialize(sObjectListBySpecifiedObjectMap), Map<Id, List<SObject>>.class
        );
    }

    private class MapBySharedKeyExtractor {
        SObjectField keyField;
        XAP_PRED_SObjectPredicateIntf predicate;

        MapBySharedKeyExtractor(SObjectField keyField, XAP_PRED_SObjectPredicateIntf predicate) {
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