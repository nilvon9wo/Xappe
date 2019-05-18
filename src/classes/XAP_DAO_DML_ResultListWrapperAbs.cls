public abstract class XAP_DAO_DML_ResultListWrapperAbs implements XAP_DAO_DML_ResultListWrapperIntf {
    public abstract List<XAP_DAO_DML_ResultWrapperIntf> getResultWrapperList();

    XAP_DAO_DML_SuccessLevelEnum successLevel;
    public XAP_DAO_DML_SuccessLevelEnum getSuccessLevel() {
        if (this.successLevel == null) {
            this.calculateSuccessLevel();
        }
        return this.successLevel;
    }
    private XAP_DAO_DML_SuccessLevelEnum calculateSuccessLevel() {
        Boolean hasSuccess = false;
        Boolean hasFailure = false;

        for (XAP_DAO_DML_ResultWrapperIntf resultWrapper : this.getResultWrapperList()) {
            Boolean isSuccess = resultWrapper.isSuccess();
            if (isSuccess) {
                hasSuccess = true;
            }
            else {
                hasFailure = true;
            }
        }

        return (hasSuccess && !hasFailure)
                ? XAP_DAO_DML_SuccessLevelEnum.PERFECT
                : (hasSuccess && hasFailure)
                        ? XAP_DAO_DML_SuccessLevelEnum.PARTIAL
                        : XAP_DAO_DML_SuccessLevelEnum.NONE;
    }
}