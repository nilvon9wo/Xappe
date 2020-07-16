//@see: https://github.com/jongpie/NebulaFramework/blob/dev/src/classes/TestingUtils.cls
@IsTest
public class TEST_ReadOnlyHelper {
	public static SObject setReadOnlyField(SObject sobj, Map<Schema.SObjectField, Object> changesToFields) {
		String serializedRecord = JSON.serialize(sobj);
		Map<String, Object> deserializedRecordMap = (Map<String, Object>) JSON.deserializeUntyped(serializedRecord);

		for (Schema.SObjectField sobjectField : changesToFields.keySet()) {
			String fieldName = sobjectField.getDescribe().getName();
			deserializedRecordMap.put(fieldName, changesToFields.get(sobjectField));
		}

		String reserializedRecord = JSON.serialize(deserializedRecordMap);
		return (SObject) JSON.deserialize(reserializedRecord, SObject.class);
	}

	public static SObject setRelationship(SObject sobj, Map<String, List<SObject>> sobjectListByRelationName) {
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