@IsTest
public class XAP_DAO_DML_ResultListWrapperMock implements XAP_DAO_DML_ResultListWrapperIntf{

	List<XAP_DAO_DML_ResultWrapperIntf> returnedResultWrapperList;
	public List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList() {
		return this.returnedResultWrapperList;
	}

	XAP_DAO_DML_SuccessLevelEnum returnedSuccessLevel;
	public XAP_DAO_DML_SuccessLevelEnum getSuccessLevel() {
		return this.returnedSuccessLevel;
	}

	public Boolean wasCalledIsCompleteSuccess = false;
	public Boolean returnedIsCompleteSuccess;
	public Boolean isCompleteSuccess() {
		this.wasCalledIsCompleteSuccess = true;
		return this.returnedIsCompleteSuccess;
	}

	public Boolean wasCalledGetCombinedErrorMessage = false;
	public String returnedCombinedErrorMessage;
	public String getCombinedErrorMessage() {
		this.wasCalledGetCombinedErrorMessage = true;
		return this.returnedCombinedErrorMessage;
	}
}