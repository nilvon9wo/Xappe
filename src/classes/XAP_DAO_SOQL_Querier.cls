public virtual class XAP_DAO_SOQL_Querier {
	private XAP_DAO_SOQL_Querier() {
	}

	private static XAP_DAO_SOQL_Querier instance;
	public static XAP_DAO_SOQL_Querier getInstance() {
		instance = new XAP_DAO_SOQL_Querier();
		return instance;
	}

	private static Object object0;
	private static Object object1;
	private static Object object2;
	private static Object object3;
	private static Object object4;
	private static Object object5;
	private static Object object6;
	private static Object object7;
	private static Object object8;
	private static Object object9;
	private static final Integer LAST_OBJECT_NUMBER = 9;

	public List<SObject> selectFor(XAP_DAO_SOQL_QueryInterpolation queryInterpolation) {
		return Database.query(
				this.toSoql(queryInterpolation)
		);
	}

	public Database.QueryLocator getQueryLocatorFor(XAP_DAO_SOQL_QueryInterpolation queryInterpolation) {
		return Database.getQueryLocator(
				this.toSoql(queryInterpolation)
		);
	}

	public String toSoql(XAP_DAO_SOQL_QueryInterpolation queryInterpolation) {
		String localizedTemplate = queryInterpolation.template;
		Integer counter = 0;
		for (String key : queryInterpolation.objectsByKeyMap.keySet()) {
			localizedTemplate = this.rebind(
					localizedTemplate,
					key,
					queryInterpolation.objectsByKeyMap.get(key),
					counter++
			);
		}
		return localizedTemplate;
	}

	private String rebind(String localizedTemplate, String key, Object value, Integer index) {
		switch on index {
			when 0 {
				object0 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 1 {
				object1 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 2 {
				object2 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 3 {
				object3 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 4 {
				object4 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 5 {
				object5 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 6 {
				object6 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 7 {
				object7 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 8 {
				object8 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
			when 9 {
				object9 = value; return this.rebind(localizedTemplate, key, 'object' + index);
			}
		}

		throw new RebindObjectsLimitException(
				'XAP_DAO_SOQL_Querier currently only supports ' + LAST_OBJECT_NUMBER + ' bindings.'
						+ '  Attempted query requires ' + index + 1 + ' bindings'
		);
	}

	private String rebind(String localizedTemplate, String oldKey, String newKey) {
		return localizedTemplate.replace('${' + oldKey + '}', newKey);
	}

	private class RebindObjectsLimitException extends Exception {
	}
}