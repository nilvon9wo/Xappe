public class XAP_DML_UpsertResultWrapper implements XAP_DML_ResultWrapperIntf {
    private Database.UpsertResult result;
    @TestVisible private Id id;
    @TestVisible private Boolean wasSuccess;
    @TestVisible private Boolean wasCreated;

    public XAP_DML_UpsertResultWrapper(Database.UpsertResult result) {
        this.result = result;
        this.id = result.id;
        this.wasCreated = result.isCreated();
        this.wasSuccess = result.isSuccess();
    }

    @TestVisible
    private XAP_DML_UpsertResultWrapper() {
    }

    public Id getId() {
        return this.id;
    }

    public Boolean isCreated() {
        return this.wasCreated;
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