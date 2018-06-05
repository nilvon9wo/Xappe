public class XAP_DESC_GlobalDescribeMap extends XAP_DESC_NamespacedAttributeMap{
	@testVisible
	public XAP_DESC_GlobalDescribeMap(Map<String,Schema.SObjectType> valueByNameMap){
		super(valueByNameMap);
	}

	public Schema.SObjectType get(String name){
		return this.get(name, true);
	}

	public Schema.SObjectType get(String name, Boolean implyNamespace){
		return (Schema.SObjectType) this.getObject(name, implyNamespace);
	}

	public List<Schema.SObjectType> values(){
		return (List<Schema.SObjectType>) valueByNameMap.values();
	}
}