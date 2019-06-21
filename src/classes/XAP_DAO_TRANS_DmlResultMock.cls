@IsTest
public class XAP_DAO_TRANS_DmlResultMock implements XAP_DAO_TRANS_DmlResultIntf {
	public Boolean wasCalledGetResultSObjectsByKeyMap = false;
	public Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> returnedResultSObjectsByKeyMap;
	public Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> getResultSObjectsByKeyMap() {
		this.wasCalledGetResultSObjectsByKeyMap = true;
		return this.returnedResultSObjectsByKeyMap;
	}

	public Boolean wasCalledGetSuccessLevel = false;
	public XAP_DAO_DML_SuccessLevelEnum returnedSuccessLevel;
	public XAP_DAO_DML_SuccessLevelEnum getSuccessLevel() {
		this.wasCalledGetSuccessLevel = true;
		return this.returnedSuccessLevel;
	}
}