public interface XAP_DAO_SObjectSelectorIntf {
	Schema.SObjectType getSObjectType();
	List<SObject> selectSObjectsById(Set<Id> idSet);	
    
}