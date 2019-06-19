public class XAP_DAO_TRANS_DmlPartialSuccess extends XAP_DAO_TRANS_DmlResultAbs {
	public XAP_DAO_TRANS_DmlPartialSuccess(Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> resultSObjectsByKeyMap) {
		super.resultSObjectsByKeyMap = resultSObjectsByKeyMap;
		super.successLevel = XAP_DAO_DML_SuccessLevelEnum.PARTIAL;
	}
}