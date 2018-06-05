public class DAO_WHERE_BindingComparisonClause implements DAO_WHERE_ClauseIntf {
	DAO_WHERE_ComparisonOperatorEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	String bindVariableName;
	 
	public DAO_WHERE_BindingComparisonClause (
			SObjectField sObjectField,
			DAO_WHERE_ComparisonOperatorEnum comparisonOperator,
			String bindVariableName
		) {
		this.fieldName = DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = DAO_WHERE_ComparisonOperatorEnumHelper.getInstance().get(comparisonOperator);
		this.bindVariableName = bindVariableName;
	}
 
    public String toSOQL() { 
		return fieldName  
			+ comparisonOperator
			+ ':' + bindVariableName;    	
    }
}