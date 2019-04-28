public class XAP_DAO_SOQL_WHERE_InIdSetClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	XAP_DAO_SOQL_WHERE_CompareOpEnumHelper comparisonHelper;

	String fieldName;
	Set<Id> idSet;
	 
	public XAP_DAO_SOQL_WHERE_InIdSetClause (
			SObjectField sObjectField,
			Set<Id> idSet
		) {
		this.fieldName = XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
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