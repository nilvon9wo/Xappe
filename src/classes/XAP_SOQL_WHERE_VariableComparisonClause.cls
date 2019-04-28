public class XAP_SOQL_WHERE_VariableComparisonClause implements XAP_SOQL_WHERE_ClauseIntf {
	XAP_SOQL_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	Object value;
	 
	public XAP_SOQL_WHERE_VariableComparisonClause (
			SObjectField sObjectField,
			XAP_SOQL_WHERE_ComparisonOperatorEnum comparisonOperator,
			Object value
		) {
		this.fieldName = XAP_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_SOQL_WHERE_ComparisonOpEnumHelper.getInstance().get(comparisonOperator);
		this.value = value;
	}
 
    public String toSOQL() {
    	Object someValue = this.value; 
		return fieldName  
			+ comparisonOperator
			+ ':someValue';    	 
    }
}