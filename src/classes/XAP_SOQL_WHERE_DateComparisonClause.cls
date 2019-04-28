public class XAP_SOQL_WHERE_DateComparisonClause implements XAP_SOQL_WHERE_ClauseIntf {
	XAP_SOQL_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	Date dateValue;
	 
	public XAP_SOQL_WHERE_DateComparisonClause (
			SObjectField sObjectField,
			XAP_SOQL_WHERE_ComparisonOperatorEnum comparisonOperator,
			Date dateValue
		) {
		this.fieldName = XAP_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_SOQL_WHERE_ComparisonOpEnumHelper.getInstance().get(comparisonOperator);
		this.dateValue = dateValue;
	}
 
    public String toSOQL() {
		return fieldName  
			+ comparisonOperator
			+ String.valueOf(this.dateValue);    	 
    }
}