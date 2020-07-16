@IsTest
public class XAP_UTIL_ListFlattenerMock extends XAP_Util_ListFlattener {
	public List<List<SObject>> receivedSObjectListOfListsToFlatten;
	public List<SObject> flattenedSObjectList;

	public override List<SObject> flattenListOfLists(List<List<SObject>> listOfListsToFlatten) {
		this.receivedSObjectListOfListsToFlatten = listOfListsToFlatten;
		return this.flattenedSObjectList;
	}
}