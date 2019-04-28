public interface XAP_SOQL_SObjectSelectorIntf {
	Schema.SObjectType getSObjectType();
	List<SObject> selectSObjectsById(Set<Id> idSet);	
    
}