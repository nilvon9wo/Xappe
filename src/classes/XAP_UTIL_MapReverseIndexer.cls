public class XAP_UTIL_MapReverseIndexer {
    List<Object> keyObjectList;
    List<Object> valueObjectList;
    public XAP_UTIL_MapReverseIndexer(Map<String, String> valueByKeyMap){
        this.keyObjectList = new List<String>(valueByKeyMap.keySet());
        this.valueObjectList = valueByKeyMap.values();
    }

    public XAP_UTIL_MapReverseIndexer(Map<Double, Double> valueByKeyMap){
        this.keyObjectList = new List<Double>(valueByKeyMap.keySet());
        this.valueObjectList = valueByKeyMap.values();
    }

    public XAP_UTIL_MapReverseIndexer(Map<Integer, Integer> valueByKeyMap){
        this.keyObjectList = new List<Integer>(valueByKeyMap.keySet());
        this.valueObjectList = valueByKeyMap.values();
    }

    public XAP_UTIL_MapReverseIndexer(Map<SObjectField, SObjectField> valueByKeyMap){
        this.keyObjectList = new List<SObjectField>(valueByKeyMap.keySet());
        this.valueObjectList = valueByKeyMap.values();
    }

    private Map<Object, Object> keyByValueMap {
        get{
            if (this.keyByValueMap == null) {
                this.keyByValueMap = this.buildKeyByValueMap();
            }
            return this.keyByValueMap;
        }
        private set;
    }

    public Object get(Object value) {
        return this.keyByValueMap.get(value);
    }

    private Map<Object, Object> buildKeyByValueMap() {
        Map<Object, Object> keyByValueMap = new Map<Object, Object>();
        for (Integer i = 0; i < this.keyObjectList.size(); i++) {
            Object key = this.keyObjectList[i];
            Object value = this.valueObjectList[i];

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