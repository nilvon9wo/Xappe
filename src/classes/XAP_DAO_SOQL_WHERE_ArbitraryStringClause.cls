public class XAP_DAO_SOQL_WHERE_ArbitraryStringClause implements XAP_DAO_SOQL_WHERE_ClauseIntf {
	String clause;
	 
	public XAP_DAO_SOQL_WHERE_ArbitraryStringClause(String clause) {
		this.clause = clause;
	}
 
    public String toSOQL() {
		return clause;    	
    }
}