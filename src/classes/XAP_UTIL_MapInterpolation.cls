public class XAP_UTIL_MapInterpolation implements XAP_UTIL_InterpolationIntf {
	String template;
	Map<String, Object> valueByKeyMap;
	public XAP_UTIL_MapInterpolation(String phrase, Map<String, Object> valueByKeyMap) {
		this.template = phrase;
		this.valueByKeyMap = valueByKeyMap;
	}

	public override String toString() {
		String result = this.template;
		for (String key : this.valueByKeyMap.keySet()) {
			result = result.replace('${' + key + '}', String.valueOf(this.valueByKeyMap.get(key)));
		}
		return result;
	}
}