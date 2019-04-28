@IsTest
public class XAP_UTIL_SObjectListExtractorMock extends XAP_UTIL_SObjectListExtractor {
	public List<SObject> receivedSObjectList;
	public SObjectField receivedSObjectField;
	public Id receivedId;
	public List<SObject> returnedSObjectList;
    public override List<SObject> extractByIdFrom(List<SObject> sObjectList, SObjectField sObjectField, Id id) {
    	this.receivedSObjectList = sObjectList;
    	this.receivedSObjectField = sObjectField;
    	this.receivedId = id;
    	return returnedSObjectList; 
    }    
}