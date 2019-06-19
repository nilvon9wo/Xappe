public virtual class XAP_UTIL_ClassHelper {
	public String getClassName(Object instance) {
		return String.valueOf(instance).split(':')[0];
	}
}