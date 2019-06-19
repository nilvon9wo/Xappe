public interface XAP_DAO_TRANS_DmlResultIntf {
	Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> getResultSObjectsByKeyMap();
	XAP_DAO_DML_SuccessLevelEnum getSuccessLevel();
}