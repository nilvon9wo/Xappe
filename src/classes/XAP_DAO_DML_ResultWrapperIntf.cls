public interface XAP_DAO_DML_ResultWrapperIntf {
	Id getId();
	Boolean isSuccess();
	List<XAP_DAO_DML_DatabaseErrorWrapper> getErrorList();
}