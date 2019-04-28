public class XAP_SOQL_WHERE_AndClause implements XAP_SOQL_WHERE_ClauseIntf {
	List<XAP_SOQL_WHERE_ClauseIntf> clauseList;
	 
	public XAP_SOQL_WHERE_AndClause(List<XAP_SOQL_WHERE_ClauseIntf> clauseList) {
		this.clauseList = clauseList;
	}
 
    public String toSOQL() {
    	List<String> stringList = new List<String>();
    	for (XAP_SOQL_WHERE_ClauseIntf clause : clauseList) {
    		stringList.add(clause.toSOQL());
    	}
		return '(' + String.join(stringList, ') AND (') + ')';    	
    }
    
}