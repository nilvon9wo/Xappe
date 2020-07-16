@IsTest
public class XAP_UTIL_MapFactoryMock extends XAP_UTIL_MapFactory {
	public List<SObject> receviedSObjects;
	public Set<SObjectField> receviedSObjectFields;
	public Map<String, SObject> returnedSobjectByString;

	public override Map<String, SObject> mapLastQualifiedSObjectByNonuniqueSpecifiedFields(
			List<SObject> homogeneousSObjectList,
			Set<SObjectField> sObjectFieldSet
	) {
		this.receviedSObjects = homogeneousSObjectList;
		this.receviedSObjectFields = sObjectFieldSet;
		return returnedSobjectByString;
	}
}