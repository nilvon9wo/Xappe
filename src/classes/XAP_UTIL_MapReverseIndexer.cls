public class XAP_UTIL_MapReverseIndexer {
	List<Object> keyObjectList;
	List<Object> valueObjectList;
	public XAP_UTIL_MapReverseIndexer(Map<String, String> valueByKeyMap) {
		this.keyObjectList = new List<String>(valueByKeyMap.keySet());
		this.valueObjectList = valueByKeyMap.values();
	}

	public XAP_UTIL_MapReverseIndexer(Map<Double, Double> valueByKeyMap) {
		this.keyObjectList = new List<Double>(valueByKeyMap.keySet());
		this.valueObjectList = valueByKeyMap.values();
	}

	public XAP_UTIL_MapReverseIndexer(Map<Integer, Integer> valueByKeyMap) {
		this.keyObjectList = new List<Integer>(valueByKeyMap.keySet());
		this.valueObjectList = valueByKeyMap.values();
	}

	public XAP_UTIL_MapReverseIndexer(Map<SObjectField, SObjectField> valueByKeyMap) {
		this.keyObjectList = new List<SObjectField>(valueByKeyMap.keySet());
		this.valueObjectList = valueByKeyMap.values();
	}

	private Map<Object, List<Object>> keyListByValueMap {
		get {
			if (this.keyListByValueMap == null) {
				this.keyListByValueMap = this.buildKeyListByValueMap();
			}
			return this.keyListByValueMap;
		}
		private set;
	}

	public Object get(Object value) {
		return this.keyListByValueMap.get(value);
	}

	private Map<Object, List<Object>> buildKeyListByValueMap() {
		Map<Object, List<Object>> keyListByValueMap = new Map<Object, List<Object>>();
		for (Integer i = 0; i < this.keyObjectList.size(); i++) {
			Object key = this.keyObjectList[i];
			Object value = this.valueObjectList[i];
			if (!keyListByValueMap.containsKey(value)) {
				keyListByValueMap.put(value, new List<Object>());
			}
			keyListByValueMap.get(value).add(key);
		}
		return keyListByValueMap;
	}
}