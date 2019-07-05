public interface XAP_DAO_DML_ResultListWrapperIntf {
	List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList();
	XAP_DAO_DML_SuccessLevelEnum getSuccessLevel();
	Boolean isCompleteSuccess();
	String getCombinedErrorMessage();
}