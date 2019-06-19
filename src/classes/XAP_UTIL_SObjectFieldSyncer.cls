/**
 * The SObject Field Syncer ensures that
 * -- for the fields specified, and only the fields specified --
 * 1. The target SObject has the same values for all fields; and
 * 2. Thet String values are compared for equality (including case).
 */
public class XAP_UTIL_SObjectFieldSyncer extends XAP_UTIL_SObjectBlenderAbs {
	@TestVisible
	protected override XAP_UTIL_SObjectBlendResult blend(
			XAP_UTIL_SObjectBlendResult result,
			SObject targetSObject,
			SObjectField targetField,
			SObject providerSObject,
			Map<SObjectField, SObjectField> providerFieldByTargetFieldMap
	) {
		SObjectField providerField = providerFieldByTargetFieldMap.get(targetField);
		Object providerFieldValue = providerSObject.get(providerField);
		this.sync(result, targetSObject, targetField, providerFieldValue);
		return result;
	}

	private XAP_UTIL_SObjectBlendResult sync(
			XAP_UTIL_SObjectBlendResult result,
			SObject targetSObject,
			SObjectField targetField, Object providerFieldValue
	) {
		if (targetSObject == null) {
			return null;
		}

		Object targetFieldValue = targetSObject.get(targetField);
		Boolean isDifferent = targetFieldValue != providerFieldValue
				|| this.isUnequalString(targetFieldValue, providerFieldValue);

		if (isDifferent) {
			result.updatedSObject.put(targetField, providerFieldValue);
			result.isTargetChanged = true;
		}
		return result;
	}

	private Boolean isUnequalString(Object targetFieldValue, Object providerFieldValue) {
		if (
				!(targetFieldValue instanceof String)
						|| !(providerFieldValue instanceof String)
				) {
			return false;
		}

		String targetStringValue = (String) targetFieldValue;
		String providerStringValue = (String) providerFieldValue;
		return !targetStringValue.equals(providerStringValue);
	}
}