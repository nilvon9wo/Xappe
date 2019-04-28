public class XAP_DAO_SOQL_WHERE_DateComparisonClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	XAP_DAO_SOQL_WHERE_CompareOpEnumHelper comparisonHelper;

	String fieldName;
	String comparisonOperator;
	Date dateValue;
	 
	public XAP_DAO_SOQL_WHERE_DateComparisonClause (
			SObjectField sObjectField,
			XAP_DAO_SOQL_WHERE_CompareOperatorEnum comparisonOperator,
			Date dateValue
		) {
		this.fieldName = XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.comparisonOperator = XAP_DAO_SOQL_WHERE_CompareOpEnumHelper.getInstance().get(comparisonOperator);
		this.dateValue = dateValue;
	}
 
    public String toSOQL() {
		return fieldName  
			+ comparisonOperator
			+ String.valueOf(this.dateValue);    	 
    }
}