@IsTest
public class XAP_DAO_TRANS_DmlResultFactoryMock extends XAP_DAO_TRANS_DmlResultFactory {
	public Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> receivedResultSObjectListByKeyMap;
	public XAP_DAO_DML_ResultListWrapperIntf receivedResultListWrapper;
	public XAP_DAO_TRANS_DmlResultIntf returnedDmlResult;
	public override XAP_DAO_TRANS_DmlResultIntf createFor(
			XAP_DAO_DML_ResultListWrapperIntf resultListWrapper,
			Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> resultSObjectListByKeyMap
	) {
		this.receivedResultSObjectListByKeyMap = resultSObjectListByKeyMap;
		this.receivedResultListWrapper = resultListWrapper;
		return this.returnedDmlResult;
	}

	public override XAP_DAO_TRANS_DmlResultIntf createFor(XAP_DAO_DML_ResultListWrapperIntf resultListWrapper) {
		this.receivedResultListWrapper = resultListWrapper;
		return this.returnedDmlResult;
	}
}
