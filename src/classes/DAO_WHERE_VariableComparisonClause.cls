public class DAO_WHERE_VariableComparisonClause implements DAO_WHERE_ClauseIntf {
	DAO_WHERE_ComparisonOperatorEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	Object value;
	 
	public DAO_WHERE_VariableComparisonClause (
			SObjectField sObjectField,
			DAO_WHERE_ComparisonOperatorEnum comparisonOperator,
			Object value
		) {
		this.fieldName = DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = DAO_WHERE_ComparisonOperatorEnumHelper.getInstance().get(comparisonOperator);
		this.value = value;
	}
 
    public String toSOQL() {
    	Object someValue = this.value; 
		return fieldName  
			+ comparisonOperator
			+ ':someValue';    	 
    }
}