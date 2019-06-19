public class XAP_DESC_FieldsMap extends XAP_DESC_NamespacedAttributeMap {

	@TestVisible
	public XAP_DESC_FieldsMap(Map<String, SObjectField> valueByNameMap) {
		super(valueByNameMap);
	}

	public SObjectField get(String name) {
		return this.get(name, true);
	}

	public SObjectField get(String name, Boolean implyNamespace) {
		return (SObjectField) this.getObject(name, implyNamespace);
	}

	public List<SObjectField> values() {
		return (List<SObjectField>) valueByNameMap.values();
	}
}