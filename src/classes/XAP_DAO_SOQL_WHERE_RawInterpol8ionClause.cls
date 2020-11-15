public class XAP_DAO_SOQL_WHERE_RawInterpol8ionClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	XAP_DAO_SOQL_QueryInterpolation queryInterpolation;

	public XAP_DAO_SOQL_WHERE_RawInterpol8ionClause(XAP_DAO_SOQL_QueryInterpolation queryInterpolation) {
		this.queryInterpolation = queryInterpolation;
	}

	public XAP_DAO_SOQL_WHERE_RawInterpol8ionClause(String template, Map<String, Object> objectsByKeyMap) {
		this(new XAP_DAO_SOQL_QueryInterpolation(template, objectsByKeyMap));
	}

	public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
		return this.queryInterpolation;
	}
}