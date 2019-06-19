public interface XAP_DAO_TRANS_DmlOperationIntf {
	XAP_DAO_TRANS_DmlResultIntf doDml(Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> prerequisitSObjectsByKeyMap);
}