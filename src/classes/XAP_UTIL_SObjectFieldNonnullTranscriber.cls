/**
 * The SObject Field Transcriber ensures that
 * -- for the fields specified, and only the fields specified --
 * the target SObject has the same values for all non-null provider values.
 *
 * When the provider offers a null, the original value will be kept.
 * (Empty values will overwrite, but in some contexts, Salesforce may be
 * unable to distinguish between nulls and empty values stored within SObjects.)
 */
public virtual class XAP_UTIL_SObjectFieldNonnullTranscriber extends XAP_UTIL_SObjectBlenderAbs {
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
		if (providerFieldValue != null) {
			this.transcribe(result, targetSObject, targetField, providerFieldValue);
		}
		return result;
	}

	@TestVisible
	private XAP_UTIL_SObjectBlendResult transcribe(
			XAP_UTIL_SObjectBlendResult result,
			SObject targetSObject,
			SObjectField targetField,
			Object providerFieldValue
	) {
		if (targetSObject == null) {
			return null;
		}

		Object targetFieldValue = targetSObject.get(targetField);
		if (targetFieldValue != providerFieldValue) {
			result.updatedSObject.put(targetField, providerFieldValue);
			result.isTargetChanged = true;
		}
		return result;
	}

}