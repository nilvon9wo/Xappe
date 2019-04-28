public class XAP_DAO_SOQL_WHERE_OrClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	List<XAP_DAO_SOQL_WHERE_ClauseIntf> clauseList;
	 
	public XAP_DAO_SOQL_WHERE_OrClause(List<XAP_DAO_SOQL_WHERE_ClauseIntf> clauseList) {
		this.clauseList = clauseList;
	}
 
    public String toSOQL() {
    	List<String> stringList = new List<String>();
    	for (XAP_DAO_SOQL_WHERE_ClauseIntf clause : clauseList) {
    		stringList.add(clause.toSOQL());
    	}
		return '(' + String.join(stringList, ') OR (') + ')';    	
    }
    
}