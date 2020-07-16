// @see: https://salesforce.stackexchange.com/questions/23998/return-name-of-class-from-instance-of-that-class
public class XAP_ENUM_EnumConverter {
	private XAP_ENUM_EnumConverter() {
	}

	private static XAP_ENUM_EnumConverter instance;
	public static XAP_ENUM_EnumConverter getInstance() {
		if (instance == null) {
			instance = new XAP_ENUM_EnumConverter();
		}
		return instance;
	}

	private static final Map<Type, XAP_ENUM_EnumWrapper> ENUM_WRAPPERS_BY_TYPE_MAP
			= new Map<Type, XAP_ENUM_EnumWrapper>();

	public XAP_ENUM_EnumConverter put(Type enumType, XAP_ENUM_EnumWrapper enumWrapper) {
		ENUM_WRAPPERS_BY_TYPE_MAP.put(enumType, enumWrapper);
		return this;
	}

	public Object getEnumeration(Type enumType, String stringValue) {
		XAP_ENUM_EnumWrapper wrapper = ENUM_WRAPPERS_BY_TYPE_MAP.get(enumType);
		return (wrapper == null)
				? null
				: wrapper.getEnumValue(stringValue);

	}
}