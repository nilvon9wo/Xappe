public interface XAP_DAO_SOQL_SObjectSelectorIntf {
	Schema.SObjectType getSObjectType();
	List<SObject> selectById(Set<Id> idSet);
    
}