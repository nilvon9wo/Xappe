public class DAO_WHERE_OrClause implements DAO_WHERE_ClauseIntf {
	List<DAO_WHERE_ClauseIntf> clauseList;
	 
	public DAO_WHERE_OrClause(List<DAO_WHERE_ClauseIntf> clauseList) {
		this.clauseList = clauseList;
	}
 
    public String toSOQL() {
    	List<String> stringList = new List<String>();
    	for (DAO_WHERE_ClauseIntf clause : clauseList) {
    		stringList.add(clause.toSOQL());
    	}
		return '(' + String.join(stringList, ') OR (') + ')';    	
    }
    
}