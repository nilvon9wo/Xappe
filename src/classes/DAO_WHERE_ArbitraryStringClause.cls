public class DAO_WHERE_ArbitraryStringClause implements DAO_WHERE_ClauseIntf {
	String clause;
	 
	public DAO_WHERE_ArbitraryStringClause(String clause) {
		this.clause = clause;
	}
 
    public String toSOQL() {
		return clause;    	
    }
}