public virtual class XAP_UTIL_SObjectMapSharedKeyExtractor {
    private static XAP_UTIL_SObjectMapSharedKeyExtractor instance;
    protected XAP_UTIL_SObjectMapSharedKeyExtractor() {
    }

    public static XAP_UTIL_SObjectMapSharedKeyExtractor getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_SObjectMapSharedKeyExtractor();
        }
        return instance;
    }

    public Map<Id, List<SObject>> mapBySpecifiedIdField(List<SObject> sObjectList, SObjectField idField) {
        return (Map<Id, List<SObject>>) JSON.deserialize(
                this.extractToMapJson(sObjectList, idField, new XAP_PRED_SObjectFieldHasNonNullValue(idField)),
                Map<Id, List<SObject>>.class
        );
    }

    public Map<String, List<SObject>> mapBySpecifiedStringField(List<SObject> sObjectList, SObjectField stringField) {
        return (Map<String, List<SObject>>) JSON.deserialize(
                this.extractToMapJson(sObjectList, stringField, new XAP_PRED_SObjectFieldHasNonBlankValue(stringField)),
                Map<String, List<SObject>>.class
        );
    }

    private String extractToMapJson(
            List<SObject> sObjectList,
            SObjectField keyField,
            XAP_PRED_SObjectPredicateIntf predicate
    ) {
        return JSON.serialize(
                new MapExtractor(keyField, predicate)
                        .extractFrom(sObjectList)
        );
    }

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