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

    public virtual Set<Id> extractNonNullIdsFrom(List<SObject> sObjectList, SObjectField idField) {
        Set<Object> objectSet = new SetExtractor(idField)
                .extractFrom(sObjectList);
        return (Set<Id>) JSON.deserialize(JSON.serialize(objectSet), Set<Id>.class);
    }

    public virtual Set<String> extractNonBlankStringsFrom(List<SObject> sObjectList, SObjectField stringField) {
        Set<Object> objectSet = new SetExtractor(stringField)
                .extractFrom(sObjectList);
        return (Set<String>) JSON.deserialize(JSON.serialize(objectSet), Set<String>.class);
    }


    private class SetExtractor {
        SObjectField extractionField;
        XAP_PRED_SObjectPredicateIntf predicate;

        SetExtractor(SObjectField extractionField, XAP_PRED_SObjectPredicateIntf predicate) {
            this.extractionField = extractionField;
            this.predicate = predicate;
        }

        SetExtractor(SObjectField extractionField) {
            this(extractionField, new XAP_PRED_SObjectFieldHasNonBlankValue(extractionField));
        }

        public Set<Object> extractFrom(List<SObject> sObjectList) {
            Set<Object> resultSet = new Set<Object>();
            for (SObject sObj : sObjectList) {
                if (this.predicate.isTrueFor(sObj)) {
                    resultSet.add(sObj.get(extractionField));
                }
            }
            return resultSet;
        }
    }

}