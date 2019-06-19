public virtual class XAP_DAO_DML_DmlLookup {
	@TestVisible
	protected XAP_DAO_DML_DmlLookup() {
	}

	private static XAP_DAO_DML_DmlLookup instance;

	public static XAP_DAO_DML_DmlLookup getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_DML_DmlLookup();
		}
		return instance;
	}

	private static final Map<XAP_DAO_DML_SharingModeEnum, XAP_DAO_DML_GenericDmlIntf> DML_TYPE_BY_SHARING_MODE_MAP
			= new Map<XAP_DAO_DML_SharingModeEnum, XAP_DAO_DML_GenericDmlIntf>{
					XAP_DAO_DML_SharingModeEnum.INHERIT => XAP_DAO_DML_InheritedSharingDml.getInstance(),
					XAP_DAO_DML_SharingModeEnum.WITH => XAP_DAO_DML_WithSharingDml.getInstance(),
					XAP_DAO_DML_SharingModeEnum.WITHOUT => XAP_DAO_DML_WithoutSharingDml.getInstance()
			};

	public XAP_DAO_DML_GenericDmlIntf get(XAP_DAO_DML_SharingModeEnum sharingMode) {
		return DML_TYPE_BY_SHARING_MODE_MAP.get(sharingMode);
	}
}