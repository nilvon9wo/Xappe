public virtual class XAP_UTIL_SObjectMapSwapper {
    private static XAP_UTIL_SObjectMapSwapper instance;
    protected XAP_UTIL_SObjectMapSwapper() {
    }

    public static XAP_UTIL_SObjectMapSwapper getInstance() {
        if (instance == null) {
            instance = new XAP_UTIL_SObjectMapSwapper();
        }
        return instance;
    }

    public Map<SObjectField, SObjectField> swap(Map<SObjectField, SObjectField> valueByKeyMap) {
        Map<SObjectField, SObjectField> keyByValueMap = new Map<SObjectField, SObjectField>();
        for (SObjectField key : valueByKeyMap.keySet()) {
            SObjectField value = valueByKeyMap.get(key);
            if (!keyByValueMap.containsKey(value)) {
                keyByValueMap.put(value, key);
            } else {
                throw new XAP_UTIL_MapManyToOneException(
                        'Swap can only be used for maps with one-to-one relationships.  '
                                + ' Conflicting values: '
                                + ' Existing mapping for ' + value + ': ' + keyByValueMap.get(value)
                                + '; new mapping for value: ' + key + '.'
                );
            }
        }
        return keyByValueMap;
    }
}
