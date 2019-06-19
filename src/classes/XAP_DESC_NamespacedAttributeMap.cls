public abstract class XAP_DESC_NamespacedAttributeMap {
	private static final Boolean IMPLY_NAMESPACE = true;
	@TestVisible
	protected String currentNamespace;
	protected Map<String, Object> valueByNameMap;

	protected XAP_DESC_NamespacedAttributeMap(Map<String, Object> valueByNameMap) {
		this.currentNamespace = XAP_DESC_SObjectDescribe.class
				.getName()
				.substringBefore('XAP_DESC_NamespacedAttributeMap')
				.removeEnd('.')
				.toLowerCase();

		this.valueByNameMap = valueByNameMap;
	}

	protected XAP_DESC_NamespacedAttributeMap() {
		this(new Map<String, Object>());
	}

	protected virtual Object getObject(String name) {
		return this.getObject(name, IMPLY_NAMESPACE);
	}

	protected virtual Object getObject(String name, Boolean implyNamespace) {
		if (name == null) {
			return null;
		}

		String preferredValue = this.getPreferredValue(name, implyNamespace);
		if (this.valueByNameMap.containsKey(preferredValue)) {
			return this.valueByNameMap.get(preferredValue);
		}
		else if (implyNamespace) {
			return this.valueByNameMap.get(name.toLowerCase());
		}
		else {
			return null;
		}
	}

	public virtual Boolean containsKey(String name) {
		return this.containsKey(name, true);
	}

	public virtual Boolean containsKey(String name, Boolean implyNamespace) {
		if (name == null) {
			return null;
		}

		String preferredValue = this.getPreferredValue(name, implyNamespace);
		return (
				this.valueByNameMap.containsKey(preferredValue)
						|| implyNamespace && this.valueByNameMap.containsKey(name.toLowerCase())
		);
	}

	public virtual Integer size() {
		return this.valueByNameMap.size();
	}

	public virtual Set<String> keySet() {
		return this.keySet(false);
	}

	public virtual Set<String> keySet(Boolean implyNamespace) {
		if (implyNamespace) {
			Set<String> result = new Set<String>();
			for (String key : this.valueByNameMap.keySet()) {
				result.add(
						key.removeStartIgnoreCase(this.currentNamespace + '__')
				);
			}
			return result;
		}
		else {
			return this.valueByNameMap.keySet();
		}
	}

	private String getPreferredValue(String name, Boolean implyNamespace) {
		return ((implyNamespace ? this.currentNamespace + '__' : '') + name).toLowerCase();
	}
}