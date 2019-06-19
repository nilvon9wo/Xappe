public class XAP_DESC_GlobalDescribeMap extends XAP_DESC_NamespacedAttributeMap {
	@TestVisible
	public XAP_DESC_GlobalDescribeMap(Map<String, SObjectType> valueByNameMap) {
		super(valueByNameMap);
	}

	public SObjectType get(String name) {
		return this.get(name, true);
	}

	public SObjectType get(String name, Boolean implyNamespace) {
		return (SObjectType) this.getObject(name, implyNamespace);
	}

	public List<SObjectType> values() {
		return (List<SObjectType>) valueByNameMap.values();
	}
}