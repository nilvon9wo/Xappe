public class XAP_DESC_FieldsMap extends XAP_DESC_NamespacedAttributeMap{

	@testVisible
	public XAP_DESC_FieldsMap(Map<String,Schema.SObjectField> valueByNameMap){
		super(valueByNameMap);
	}

	public Schema.SObjectField get(String name){
		return this.get(name, true);
	}

	public Schema.SObjectField get(String name, Boolean implyNamespace){
		return (Schema.SObjectField) this.getObject(name, implyNamespace);
	}

	public List<Schema.SObjectField> values(){
		return (List<Schema.SObjectField>) valueByNameMap.values();
	}
}