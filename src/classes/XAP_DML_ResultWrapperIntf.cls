public interface XAP_DML_ResultWrapperIntf {
    Id getId();
    Boolean isSuccess();
    List<XAP_DML_DatabaseErrorWrapper> getErrorList();
}