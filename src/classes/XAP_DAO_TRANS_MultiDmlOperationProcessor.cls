public virtual class XAP_DAO_TRANS_MultiDmlOperationProcessor {
	XAP_DAO_TRANS_TransactionHelper transactionHelper;

	@TestVisible
	private XAP_DAO_TRANS_MultiDmlOperationProcessor(XAP_DAO_TRANS_TransactionHelper transactionHelper) {
		this.transactionHelper = transactionHelper;
	}

	@TestVisible
	protected XAP_DAO_TRANS_MultiDmlOperationProcessor() {
		this(XAP_DAO_TRANS_TransactionHelper.getInstance());
	}

	private static XAP_DAO_TRANS_MultiDmlOperationProcessor instance;

	public static XAP_DAO_TRANS_MultiDmlOperationProcessor getInstance() {
		if (instance == null) {
			instance = new XAP_DAO_TRANS_MultiDmlOperationProcessor();
		}
		return instance;
	}

	@TestVisible
	private Boolean rollbackOnPartialSuccess = true;
	public virtual XAP_DAO_TRANS_MultiDmlOperationProcessor enablePartialSuccess() {
		this.rollbackOnPartialSuccess = false;
		return this;
	}

	private Boolean wasCompleteSuccess = true;

	public virtual XAP_DAO_TRANS_DmlResultIntf process(List<XAP_DAO_TRANS_DmlOperationIntf> dmlOperatonList) {
		Savepoint savepoint = this.transactionHelper.createSavePoint();
		Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> prerequisiteSObjectsByKeyMap
				= new Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>>();

		for (XAP_DAO_TRANS_DmlOperationIntf dmlOperation : dmlOperatonList) {
			XAP_DAO_TRANS_DmlResultIntf result;

			try {
				result = dmlOperation.doDml(prerequisiteSObjectsByKeyMap);
			}
			// We can't anticipate what might be thrown in someone else's XAP_DAO_TRANS_DmlOperationIntf
			// implementation, so we really do want to catch absolutely everything to be able to
			// guarantee the rollback.
			catch (Exception ex) {
				result = new XAP_DAO_TRANS_DmlFailure(dmlOperation, ex);
			}

			if (this.wasPartialSuccess(result)) {
				this.wasCompleteSuccess = false;
				if (this.rollbackOnPartialSuccess) {
					result = new XAP_DAO_TRANS_DmlFailure(dmlOperation, (XAP_DAO_TRANS_DmlPartialSuccess) result);
				}
			}

			if (this.wasFailure(result)) {
				XAP_DAO_TRANS_DmlFailure dmlFailure = (XAP_DAO_TRANS_DmlFailure) result;
				this.transactionHelper.rollback(savepoint, dmlFailure.causeOfFailure);
				return result;
			}

			prerequisiteSObjectsByKeyMap.putAll(result.getResultSObjectsByKeyMap());
		}

		return wasCompleteSuccess
				? (XAP_DAO_TRANS_DmlResultIntf) new XAP_DAO_TRANS_DmlPerfectSuccess(prerequisiteSObjectsByKeyMap)
				: (XAP_DAO_TRANS_DmlResultIntf) new XAP_DAO_TRANS_DmlPartialSuccess(prerequisiteSObjectsByKeyMap);
	}

	private String toErrorMessage(XAP_DAO_TRANS_DmlFailure failure) {
		String failureMessage = 'FAILURE: ';
		Exception causeOfFailure = failure.causeOfFailure;
		while (causeOfFailure != null) {
			failureMessage += '\n' + causeOfFailure.getMessage() + ':' + causeOfFailure.getStackTraceString();
			causeOfFailure = causeOfFailure.getCause();
		}
		return failureMessage + '\n!!!!';
	}

	@TestVisible
	private Boolean wasFailure(XAP_DAO_TRANS_DmlResultIntf result) {
		return result.getSuccessLevel() == XAP_DAO_DML_SuccessLevelEnum.NONE;
	}

	@TestVisible
	private Boolean wasPartialSuccess(XAP_DAO_TRANS_DmlResultIntf result) {
		return result.getSuccessLevel() == XAP_DAO_DML_SuccessLevelEnum.PARTIAL;
	}

}