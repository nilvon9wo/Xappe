@IsTest
public class XAP_DAO_TRANS_MultiDmlOpProcessorMock extends XAP_DAO_TRANS_MultiDmlOperationProcessor {
	public Boolean wasPartialSuccessEnabled = false;
	public override XAP_DAO_TRANS_MultiDmlOperationProcessor enablePartialSuccess() {
		this.wasPartialSuccessEnabled = true;
		return this;
	}

	public List<XAP_DAO_TRANS_DmlOperationIntf> receivedDmlOperatonList;
	public XAP_DAO_TRANS_DmlResultIntf returnedDmlResult;
	public override XAP_DAO_TRANS_DmlResultIntf process(List<XAP_DAO_TRANS_DmlOperationIntf> dmlOperatonList) {
		this.receivedDmlOperatonList = dmlOperatonList;
		return this.returnedDmlResult;
	}
}