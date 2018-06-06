public class XAP_DAO_WHERE_InStringSetClause implements XAP_DAO_WHERE_ClauseIntf {
	XAP_DAO_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	Set<String> stringSet;
	 
	public XAP_DAO_WHERE_InStringSetClause (
			SObjectField sObjectField,
			Set<String> stringSet
		) {
		this.fieldName = XAP_DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.stringSet = stringSet;
	}
  
    public String toSOQL() {
		return fieldName  
			+ ' IN '
			+ '(\'' 
				+ String.join(new List<String>(stringSet), '\',\'')
			 + '\')';    	 
    }
}