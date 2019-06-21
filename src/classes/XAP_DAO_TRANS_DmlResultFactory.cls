public virtual class XAP_DAO_TRANS_DmlResultFactory {
	@TestVisible
	protected XAP_DAO_TRANS_DmlResultFactory() {
	}

	private static XAP_DAO_TRANS_DmlResultFactory instance;

	public static XAP_DAO_TRANS_DmlResultFactory getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_TRANS_DmlResultFactory();
		}
		return instance;
	}

	public virtual XAP_DAO_TRANS_DmlResultIntf createFor(
			Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> resultSObjectListByKeyMap,
			XAP_DAO_DML_ResultListWrapperIntf resultListWrapper
	) {
		return resultListWrapper.getSuccessLevel() == XAP_DAO_DML_SuccessLevelEnum.PERFECT
				? (XAP_DAO_TRANS_DmlResultIntf) new XAP_DAO_TRANS_DmlPerfectSuccess(resultSObjectListByKeyMap)
				: resultListWrapper.getSuccessLevel() == XAP_DAO_DML_SuccessLevelEnum.PARTIAL
						? (XAP_DAO_TRANS_DmlResultIntf) new XAP_DAO_TRANS_DmlPartialSuccess(resultSObjectListByKeyMap)
						: (XAP_DAO_TRANS_DmlResultIntf) new XAP_DAO_TRANS_DmlFailure();
	}
}