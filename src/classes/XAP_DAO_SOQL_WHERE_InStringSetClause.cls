public class XAP_DAO_SOQL_WHERE_InStringSetClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	XAP_DAO_SOQL_WHERE_CompareOpEnumHelper comparisonHelper;

	String fieldName;
	Set<String> stringSet;
	 
	public XAP_DAO_SOQL_WHERE_InStringSetClause (
			SObjectField sObjectField,
			Set<String> stringSet
		) {
		this.fieldName = XAP_DAO_SOQL_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.stringSet = stringSet;
	}
  
  	private static final String ALWAYS_FALSE = 'Id = null';
  
    public String toSOQL() {
    	if (this.stringSet == null || this.stringSet.isEmpty()) {
    		return ALWAYS_FALSE;
    	}

    	Set<String> escapedSingleQuotesSet = this.escapeSingleQuotes(this.stringSet);
		return fieldName  
			+ ' IN '
			+ '(\'' 
				+ String.join(new List<String>(escapedSingleQuotesSet), '\',\'')
			 + '\')';    	 
    } 
    
    private Set<String> escapeSingleQuotes(Set<String> stringSet) {
    	Set<String> escapedStringSet = new Set<String>();
    	for (String str : stringSet) {
    		escapedStringSet.add(String.escapeSingleQuotes(str));
    	}
    	return escapedStringSet;
    }
} 