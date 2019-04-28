public class XAP_DAO_SOQL_WHERE_BindingCompareClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	XAP_DAO_SOQL_WHERE_CompareOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	String bindVariableName;
	 
	public XAP_DAO_SOQL_WHERE_BindingCompareClause(
			SObjectField sObjectField,
			XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
			String bindVariableName
		) {
		this.fieldName = XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_DAO_SOQL_WHERE_CompareOpEnumHelper.getInstance().get(comparisonOperator);
		this.bindVariableName = bindVariableName;
	}
 
    public String toSOQL() { 
		return fieldName  
			+ comparisonOperator
			+ ':' + bindVariableName;    	
    }
}