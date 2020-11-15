//@see: https://github.com/jongpie/NebulaFramework/blob/dev/src/classes/TestingUtils.cls
@IsTest
public with sharing class XAP_TEST_ReadOnlyHelper {
	public static SObject setReadOnlyField(SObject sobj, Map<SObjectField, Object> changesToFields) {
		String serializedRecord = JSON.serialize(sobj);
		Map<String, Object> deserializedRecordMap = (Map<String, Object>) JSON.deserializeUntyped(serializedRecord);

		// Loop through the deserialized record map and put the field & value
		// Since it's a map, if the field already exists on the SObject, it's updated (or added if it wasn't there already)
		for (SObjectField sobjectField : changesToFields.keySet()) {
			String fieldName = sobjectField.getDescribe().getName();
			deserializedRecordMap.put(fieldName, changesToFields.get(sobjectField));
		}

		String reserializedRecord = JSON.serialize(deserializedRecordMap);
		return (SObject) JSON.deserialize(reserializedRecord, SObject.class);
	}

	public static SObject setParentRelationships(SObject sobj, Map<String, SObject> parentSObjectByRelationName) {
		String serializedRecord = JSON.serialize(sobj);
		Map<String, Object> deserializedRecordMap = (Map<String, Object>) JSON.deserializeUntyped(serializedRecord);

		for (String relationshipName : parentSObjectByRelationName.keySet()) {
			deserializedRecordMap.put(relationshipName, parentSObjectByRelationName.get(relationshipName));
		}

		String reserializedRecord = JSON.serialize(deserializedRecordMap);
		return (SObject) JSON.deserialize(reserializedRecord, SObject.class);
	}

	public static SObject setChildRelationships(SObject sobj, Map<String, List<SObject>> sobjectListByRelationName) {
		String serializedRecord = JSON.serialize(sobj);
		Map<String, Object> deserializedRecordMap = (Map<String, Object>) JSON.deserializeUntyped(serializedRecord);

		for (String relationshipName : sobjectListByRelationName.keySet()) {
			List<SObject> sobjectList = sobjectListByRelationName.get(relationshipName);
			Map<String, Object> relationshipMap = new Map<String, Object> {
					'totalSize' => sobjectList.size(),
					'done' => true,
					'records' => sobjectList
			};
			deserializedRecordMap.put(relationshipName, relationshipMap);
		}

		String reserializedRecord = JSON.serialize(deserializedRecordMap);
		return (SObject) JSON.deserialize(reserializedRecord, SObject.class);
	}
}
