public class XAP_DAO_WHERE_BindingComparisonClause implements XAP_DAO_WHERE_ClauseIntf {
	XAP_DAO_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	String bindVariableName;
	 
	public XAP_DAO_WHERE_BindingComparisonClause (
			SObjectField sObjectField,
			XAP_DAO_WHERE_ComparisonOperatorEnum comparisonOperator,
			String bindVariableName
		) {
		this.fieldName = XAP_DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_DAO_WHERE_ComparisonOpEnumHelper.getInstance().get(comparisonOperator);
		this.bindVariableName = bindVariableName;
	}
 
    public String toSOQL() { 
		return fieldName  
			+ comparisonOperator
			+ ':' + bindVariableName;    	
    }
}