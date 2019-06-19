public virtual class XAP_UTIL_SObjectCensusTaker {
	public virtual Map<SObjectField, Object> getPopulatedFieldsAsMap(SObject sObj) {
		if (sObj == null) {
			return null;
		}

		String sObjectName = this.getSObjectName(sObj);
		Map<String, SObjectField> sObjectFieldByStringMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();

		Map<SObjectField, Object> valueBySObjectFieldMap = new Map<SObjectField, Object>();
		for (String propertyName : sObj.getPopulatedFieldsAsMap().keySet()) {
			SObjectField sObjectField = sObjectFieldByStringMap.get(propertyName);
			valueBySObjectFieldMap.put(sObjectField, sObj.get(propertyName));
		}

		return valueBySObjectFieldMap;
	}

	@TestVisible
	private String getSObjectName(SObject sObj) {
		SObjectType sObjectType = sObj.getSObjectType();
		return sObjectType.getDescribe().getName();
	}
}