public interface XAP_DAO_TRANS_DmlOperationIntf {
	XAP_DAO_TRANS_DmlResultIntf doDml(Map<String, List<SObject>> prerequisitSObjectsByKeyMap);
}