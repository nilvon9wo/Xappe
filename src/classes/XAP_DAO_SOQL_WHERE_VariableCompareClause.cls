public class XAP_DAO_SOQL_WHERE_VariableCompareClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	XAP_DAO_SOQL_WHERE_CompareOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	Object value;
	 
	public XAP_DAO_SOQL_WHERE_VariableCompareClause(
			SObjectField sObjectField,
			XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
			Object value
		) {
		this.fieldName = XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_DAO_SOQL_WHERE_CompareOpEnumHelper.getInstance().get(comparisonOperator);
		this.value = value;
	}
 
    public String toSOQL() {
    	Object someValue = this.value; 
		return fieldName  
			+ comparisonOperator
			+ ':someValue';    	 
    }
}