public class XAP_SOQL_WHERE_InIdSetClause implements XAP_SOQL_WHERE_ClauseIntf {
	XAP_SOQL_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	Set<Id> idSet;
	 
	public XAP_SOQL_WHERE_InIdSetClause (
			SObjectField sObjectField,
			Set<Id> idSet
		) {
		this.fieldName = XAP_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.idSet = idSet;
	}

	private static final String ALWAYS_FALSE = 'Id = null';
  
    public String toSOQL() {
    	if (this.idSet == null || this.idSet.isEmpty()) {
    		return ALWAYS_FALSE;
    	}

		return fieldName  
			+ ' IN '
			+ '(\'' 
				+ String.join(new List<Id>(idSet), '\',\'')
			 + '\')';    	 
    }
}