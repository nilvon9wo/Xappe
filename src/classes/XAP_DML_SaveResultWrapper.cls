public class XAP_DML_SaveResultWrapper implements XAP_DML_ResultWrapperIntf {
    private Database.SaveResult result;
    @TestVisible private Id id;
    @TestVisible private Boolean wasSuccess;

    public XAP_DML_SaveResultWrapper(Database.SaveResult result) {
        this.result = result;
        this.id = result.id;
        this.wasSuccess = result.isSuccess();
    }

    @TestVisible
    private XAP_DML_SaveResultWrapper() {
    }

    public Id getId() {
        return this.id;
    }

    public Boolean isSuccess() {
        return this.wasSuccess;
    }

    @TestVisible private List<XAP_DML_DatabaseErrorWrapper> errorList {
        get {
            if (this.errorList == null) {
                this.errorList = (new XAP_DML_DatabaseErrorRewrapper()).convert(result.errors);
            }
            return this.errorList;
        }
        set;
    }

    public List<XAP_DML_DatabaseErrorWrapper> getErrorList() {
        return this.errorList;
    }
}