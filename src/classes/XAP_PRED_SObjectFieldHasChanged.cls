public class XAP_PRED_SObjectFieldHasChanged implements XAP_PRED_SObjectPredicateIntf {
	SObjectField targetField;
	Map<Id, SObject> oldSObjectByIdMap;

	public XAP_PRED_SObjectFieldHasChanged(SObjectField targetField, Map<Id, SObject> oldSObjectByIdMap) {
		this.targetField = targetField;
		this.oldSObjectByIdMap = oldSObjectByIdMap;
	}

	public Boolean isTrueFor(SObject newSObject) {
		Object currentValue = newSObject.get(targetField);
		Id newSObjectId = newSObject.Id;
		return this.oldSObjectByIdMap == null
				|| this.oldSObjectByIdMap.isEmpty()
				|| this.oldSObjectByIdMap.get(newSObjectId) == null
				|| currentValue != this.getOldValue(newSObjectId);
	}

	@TestVisible
	private Object getOldValue(Id newSObjectId) {
		return this.getValueOrNull(this.oldSObjectByIdMap.get(newSObjectId), this.targetField);
	}

	@TestVisible
	private Object getValueOrNull(SObject sObj, SObjectField targetField) {
		return (sObj != null)
				? sObj.get(targetField)
				: null;
	}
}