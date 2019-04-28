public class XAP_SOQL_WHERE_BindingComparisonClause implements XAP_SOQL_WHERE_ClauseIntf {
	XAP_SOQL_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	String bindVariableName;
	 
	public XAP_SOQL_WHERE_BindingComparisonClause (
			SObjectField sObjectField,
			XAP_SOQL_WHERE_ComparisonOperatorEnum comparisonOperator,
			String bindVariableName
		) {
		this.fieldName = XAP_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_SOQL_WHERE_ComparisonOpEnumHelper.getInstance().get(comparisonOperator);
		this.bindVariableName = bindVariableName;
	}
 
    public String toSOQL() { 
		return fieldName  
			+ comparisonOperator
			+ ':' + bindVariableName;    	
    }
}