public abstract class XAP_UTIL_SObjectBlenderAbs implements XAP_UTIL_SObjectBlenderIntf {
	XAP_UTIL_SObjectCloneFactory cloneFactory;

	public XAP_UTIL_SObjectBlenderAbs(
			XAP_UTIL_SObjectCloneFactory cloneFactory
	) {
		this.cloneFactory = cloneFactory;
	}

	public XAP_UTIL_SObjectBlenderAbs() {
		this(XAP_UTIL_SObjectCloneFactory.getInstance());
	}

	public virtual XAP_UTIL_SObjectBlendResult blend(
			SObject targetSObject,
			SObject providerSObject,
			Map<SObjectField, SObjectField> providerFieldByTargetFieldMap
	) {
		XAP_UTIL_SObjectBlendResult result
				= new XAP_UTIL_SObjectBlendResult(this.cloneFactory.perfectClone(targetSObject));
		if (providerSObject == null) {
			return result;
		}

		for (SObjectField targetField : providerFieldByTargetFieldMap.keySet()) {
			this.blend(result, targetSObject, targetField, providerSObject, providerFieldByTargetFieldMap);
		}
		return result;
	}

	public virtual XAP_UTIL_SObjectBlendResult blend(
			SObject targetSObject,
			SObject providerSObject,
			Set<SObjectField> fieldSet
	) {
		return this.blend(targetSObject, providerSObject, this.makeFieldMap(fieldSet));
	}

	public virtual XAP_UTIL_SObjectBlendResult blend(
			SObject targetSObject,
			SObject providerSObject,
			List<SObjectField> fieldList
	) {
		return this.blend(targetSObject, providerSObject, new Set<SObjectField>(fieldList));
	}

	@TestVisible
	protected abstract XAP_UTIL_SObjectBlendResult blend(
			XAP_UTIL_SObjectBlendResult result,
			SObject targetSObject,
			SObjectField targetField,
			SObject providerSObject,
			Map<SObjectField, SObjectField> providerFieldByTargetFieldMap
	);

	@TestVisible
	private Map<SObjectField, SObjectField> makeFieldMap(Set<SObjectField> fieldSet) {
		Map<SObjectField, SObjectField> providerFieldByTargetFieldMap = new Map<SObjectField, SObjectField>();
		for (SObjectField field : fieldSet) {
			providerFieldByTargetFieldMap.put(field, field);
		}
		return providerFieldByTargetFieldMap;
	}
}