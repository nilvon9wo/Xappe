public class DESC_FieldsMap extends DESC_NamespacedAttributeMap{

	@testVisible
	public DESC_FieldsMap(Map<String,Schema.SObjectField> valueByNameMap){
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