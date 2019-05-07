public virtual class XAP_UTIL_SObjectListSetter {
    private static XAP_UTIL_SObjectListSetter instance;
    protected XAP_UTIL_SObjectListSetter() {
    }

    public static XAP_UTIL_SObjectListSetter getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_SObjectListSetter();
        }
        return instance;
    }

    public virtual List<SObject> setAllTrue(List<SObject> sObjectList, Set<SObjectField> booleanFieldSet) {
        return this.setAllToValue(sObjectList, booleanFieldSet, true);
    }

    public virtual List<SObject> setAllTrue(List<SObject> sObjectList, SObjectField booleanField) {
        return this.setAllToValue(sObjectList, booleanField, true);
    }

    public virtual List<SObject> setAllFalse(List<SObject> sObjectList, Set<SObjectField> booleanFieldSet) {
        return this.setAllToValue(sObjectList, booleanFieldSet, false);
    }

    public virtual List<SObject> setAllFalse(List<SObject> sObjectList, SObjectField booleanField) {
        return this.setAllToValue(sObjectList, booleanField, false);
    }

    public virtual List<SObject> setAllNull(List<SObject> sObjectList, Set<SObjectField> sObjectFieldSet) {
        return this.setAllToValue(sObjectList, sObjectFieldSet, null);
    }

    public virtual List<SObject> setAllNull(List<SObject> sObjectList, SObjectField sObjectField) {
        return this.setAllToValue(sObjectList, sObjectField, null);
    }

    // When possible, prefer SObjectField sObjectField.
    // This method exists for instances when a similar field exists on multiple SObject Types
    // and a generic List<SObject> needs to set all of them.
    public virtual List<SObject> setAllNull(List<SObject> sObjectList, String sObjectField) {
        return this.setAllToValue(sObjectList, sObjectField, null);
    }

    public virtual List<SObject> setAllNow(List<SObject> sObjectList, SObjectField datetimeField) {
        return this.setAllToValue(sObjectList, datetimeField, Datetime.now());
    }

    public virtual List<SObject> setAllToValue(List<SObject> sObjectList, Set<SObjectField> sObjectFieldSet, Object value) {
        for (SObjectField sObjectField : sObjectFieldSet) {
            this.setAllToValue(sObjectList, sObjectField, value);
        }
        return sObjectList;
    }

    public virtual List<SObject> setAllToValue(List<SObject> sObjectList, SObjectField sObjectField, Object value) {
        for (SObject sObj : sObjectList) {
            sObj.put(sObjectField, value);
        }
        return sObjectList;
    }

    public virtual List<SObject> setAllToValue(List<SObject> sObjectList, String sObjectField, Object value) {
        for (SObject sObj : sObjectList) {
            sObj.put(sObjectField, value);
        }
        return sObjectList;
    }
}