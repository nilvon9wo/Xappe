public class XAP_DAO_WHERE_AndClause implements XAP_DAO_WHERE_ClauseIntf {
	List<XAP_DAO_WHERE_ClauseIntf> clauseList;
	 
	public XAP_DAO_WHERE_AndClause(List<XAP_DAO_WHERE_ClauseIntf> clauseList) {
		this.clauseList = clauseList;
	}
 
    public String toSOQL() {
    	List<String> stringList = new List<String>();
    	for (XAP_DAO_WHERE_ClauseIntf clause : clauseList) {
    		stringList.add(clause.toSOQL());
    	}
		return '(' + String.join(stringList, ') AND (') + ')';    	
    }
    
}