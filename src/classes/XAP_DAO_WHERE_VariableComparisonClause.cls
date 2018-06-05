public class XAP_DAO_WHERE_VariableComparisonClause implements XAP_DAO_WHERE_ClauseIntf {
	XAP_DAO_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	Object value;
	 
	public XAP_DAO_WHERE_VariableComparisonClause (
			SObjectField sObjectField,
			XAP_DAO_WHERE_ComparisonOperatorEnum comparisonOperator,
			Object value
		) {
		this.fieldName = XAP_DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_DAO_WHERE_ComparisonOpEnumHelper.getInstance().get(comparisonOperator);
		this.value = value;
	}
 
    public String toSOQL() {
    	Object someValue = this.value; 
		return fieldName  
			+ comparisonOperator
			+ ':someValue';    	 
    }
}