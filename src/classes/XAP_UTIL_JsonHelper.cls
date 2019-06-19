public virtual class XAP_UTIL_JsonHelper {
	public virtual String serialize(Object obj) {
		return System.JSON.serialize(obj);
	}

	public virtual Object deserializeStringList(String jsonString) {
		return this.deserialize(jsonString, List<String>.class);
	}

	public virtual Object deserialize(String jsonString, Type classType) {
		return System.JSON.deserialize(jsonString, classType);
	}
}