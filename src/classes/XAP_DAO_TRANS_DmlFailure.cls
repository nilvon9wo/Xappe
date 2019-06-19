public class XAP_DAO_TRANS_DmlFailure extends XAP_DAO_TRANS_DmlResultAbs {
	public XAP_DAO_TRANS_DmlOperationIntf dmlOperation { get; private set; }
	public Exception causeOfFailure { get; private set; }

	public XAP_DAO_TRANS_DmlFailure(XAP_DAO_TRANS_DmlOperationIntf dmlOperation, Exception ex) {
		super.successLevel = XAP_DAO_DML_SuccessLevelEnum.NONE;
		this.dmlOperation = dmlOperation;
		this.causeOfFailure = ex;
	}

	public XAP_DAO_TRANS_DmlFailure(
			XAP_DAO_TRANS_DmlOperationIntf dmlOperation,
			XAP_DAO_TRANS_DmlPartialSuccess partialResult
	) {
		this(dmlOperation, new XAP_DAO_TRANS_TransactionException('Partial Failure in ' + dmlOperation + ' not allowed.'));
		this.resultSObjectsByKeyMap = partialResult.resultSObjectsByKeyMap;
	}

	public XAP_DAO_TRANS_DmlFailure() {
		this(null, new XAP_DAO_TRANS_TransactionException('Unknown failure'));
	}
}