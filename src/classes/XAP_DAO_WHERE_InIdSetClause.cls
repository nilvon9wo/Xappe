public class XAP_DAO_WHERE_InIdSetClause implements XAP_DAO_WHERE_ClauseIntf {
	XAP_DAO_WHERE_ComparisonOpEnumHelper comparisonHelper;

	String fieldName;
	Set<Id> idSet;
	 
	public XAP_DAO_WHERE_InIdSetClause (
			SObjectField sObjectField,
			Set<Id> idSet
		) {
		this.fieldName = XAP_DAO_QueryFactoryFieldHelper.getInstance().getFieldTokenPath(sObjectField);
		this.idSet = idSet;
	}

  
    public String toSOQL() {
		return fieldName  
			+ ' IN '
			+ '(\'' 
				+ String.join(new List<Id>(idSet), '\',\'')
			 + '\')';    	 
    }
}