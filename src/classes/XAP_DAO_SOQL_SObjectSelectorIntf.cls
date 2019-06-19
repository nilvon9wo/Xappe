public interface XAP_DAO_SOQL_SObjectSelectorIntf {
	SObjectType getSObjectType();
	List<SObject> selectById(Set<Id> idSet);

}