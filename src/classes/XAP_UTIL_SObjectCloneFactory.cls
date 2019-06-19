public virtual class XAP_UTIL_SObjectCloneFactory {
	private XAP_UTIL_SObjectCloneFactory() {
	}

	private static XAP_UTIL_SObjectCloneFactory instance;

	public static XAP_UTIL_SObjectCloneFactory getInstance() {
		if (instance == null) {
			instance = new XAP_UTIL_SObjectCloneFactory();
		}
		return instance;
	}

	public static final Boolean PRESERVE_ID = true;
	public static final Boolean PRESERVE_READONLY_TIMESTAMPS = true;
	public static final Boolean PRESERVE_AUTONUMBER = true;
	public static final Boolean DEEP_CLONE = true;

	public virtual List<SObject> perfectClone(List<SObject> sObjectList) {
		return sObjectList.deepClone(
				PRESERVE_ID,
				PRESERVE_READONLY_TIMESTAMPS,
				PRESERVE_AUTONUMBER
		);
	}

	public virtual SObject perfectClone(SObject sObj) {
		return (sObj != null)
				? sObj.clone(
						PRESERVE_ID,
						DEEP_CLONE,
						PRESERVE_READONLY_TIMESTAMPS,
						PRESERVE_AUTONUMBER
				)
				: null;
	}
}