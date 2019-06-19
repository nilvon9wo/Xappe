public class XAP_DAO_DML_UndeleteResultWrapper implements XAP_DAO_DML_ResultWrapperIntf {
	private Database.UndeleteResult result;
	@TestVisible private Id id;
	@TestVisible private Boolean wasSuccess;

	public XAP_DAO_DML_UndeleteResultWrapper(Database.UndeleteResult result) {
		this.result = result;
		this.id = result.id;
		this.wasSuccess = result.isSuccess();
	}

	@TestVisible
	private XAP_DAO_DML_UndeleteResultWrapper() {
	}

	public Id getId() {
		return this.id;
	}

	public Boolean isSuccess() {
		return this.wasSuccess;
	}

	@TestVisible private List<XAP_DAO_DML_DatabaseErrorWrapper> errorList {
		get {
			if (this.errorList == null) {
				this.errorList = (new XAP_DAO_DML_DatabaseErrorRewrapper()).convert(result.errors);
			}
			return this.errorList;
		}
		set;
	}

	public List<XAP_DAO_DML_DatabaseErrorWrapper> getErrorList() {
		return this.errorList;
	}
}