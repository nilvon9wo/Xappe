public abstract class XAP_DAO_TRANS_DmlResultAbs implements XAP_DAO_TRANS_DmlResultIntf {
	protected Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> resultSObjectsByKeyMap;
	public Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> getResultSObjectsByKeyMap() {
		return this.resultSObjectsByKeyMap;
	}

	protected XAP_DAO_DML_SuccessLevelEnum successLevel;
	public XAP_DAO_DML_SuccessLevelEnum getSuccessLevel() {
		return this.successLevel;
	}
}