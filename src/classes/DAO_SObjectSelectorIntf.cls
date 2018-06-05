public interface DAO_SObjectSelectorIntf {
	Schema.SObjectType getSObjectType();
	List<SObject> selectSObjectsById(Set<Id> idSet);	
    
}