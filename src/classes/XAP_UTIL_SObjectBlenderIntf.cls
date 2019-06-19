public interface XAP_UTIL_SObjectBlenderIntf {
	XAP_UTIL_SObjectBlendResult blend(
			SObject targetSObject,
			SObject providerSObject,
			Map<SObjectField, SObjectField> providerFieldByTargetFieldMap
	);
}