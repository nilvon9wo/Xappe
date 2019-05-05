public class XAP_DAO_SOQL_WHERE_StringCompareClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	String fieldName;
	XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator;
	String stringValue;
	 
	public XAP_DAO_SOQL_WHERE_StringCompareClause(
			SObjectField sObjectField,
			XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
			String stringValue
		) {
		this.fieldName = XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = comparisonOperator;
		this.stringValue = stringValue;
	}

	public XAP_DAO_SOQL_QueryInterpolation toQueryInterpolation() {
		String comparisonOperator = XAP_DAO_SOQL_WHERE_CompareOpEnumHelper.get(this.comparisonOperator);
		String template = fieldName + comparisonOperator + '${stringValue}';
		return new XAP_DAO_SOQL_QueryInterpolation(template, new Map<String, Object>{
				'stringValue' => this.stringValue
		});
	}
}