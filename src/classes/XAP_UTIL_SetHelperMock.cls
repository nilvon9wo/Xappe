@IsTest
public class XAP_UTIL_SetHelperMock extends XAP_UTIL_SetHelper {

	public List<SObject> receivedSObjectList;
	public List<List<SObject>> receivedSObjectListList = new List<List<SObject>>();
	
	public SObjectField receivedIdField;
	public List<SObjectField> receivedIdFieldList = new List<SObjectField>();
	
	public Set<Id> returnResultIdSet;
	public List<Set<Id>> returnResultIdSetList; 
	
	private Integer extractionCounter = 0;

    public override Set<Id> extractNonNullIdsFrom(List<SObject> sObjectList, SObjectField idField){
    	this.receivedSObjectList = sObjectList;
    	this.receivedSObjectListList.add(sObjectList);
    	
    	this.receivedIdField = idField;
    	this.receivedIdFieldList.add(idField);
    	
    	return (returnResultIdSetList == null)
    		? this.returnResultIdSet
    		: this.returnResultIdSetList[extractionCounter++];
    }     
}