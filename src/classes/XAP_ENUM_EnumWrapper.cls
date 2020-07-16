public class XAP_ENUM_EnumWrapper {
	private List<Object> enumValues;
	public XAP_ENUM_EnumWrapper(List<Object> enumValues) {
		this.enumValues = enumValues;
	}

	private Map<String, Object> enumValuesByStringMap {
		get {
			if (this.enumValuesByStringMap == null) {
				this.enumValuesByStringMap = new Map<String, Object>();
				for (Object enumValue : enumValues) {
					this.enumValuesByStringMap.put(String.valueOf(enumValue).toUpperCase(), enumValue);
				}
			}
			return this.enumValuesByStringMap;
		}
		set;
	}

	public Object getEnumValue(String enumeration) {
		return String.isBlank(enumeration)
				? null
				: this.enumValuesByStringMap.get(enumeration.toUpperCase());
	}
}