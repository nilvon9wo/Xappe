public class XAP_EML_SendEmailResultWrapper implements XAP_EML_SendEmailResultWrapperIntf { 
	private transient Messaging.SendEmailResult result;
	@TestVisible private Boolean wasSuccess;

	public XAP_EML_SendEmailResultWrapper(Messaging.SendEmailResult result) {
		this.result = result;
		this.wasSuccess = result.isSuccess();
	}

	@TestVisible
	private XAP_EML_SendEmailResultWrapper() {
	}

	public Boolean isSuccess() {
		return this.wasSuccess;
	}

	@TestVisible private List<XAP_EML_SendEmailErrorWrapper> errorList {
		get {
			if (this.errorList == null) {
				this.errorList = (new XAP_EML_SendEmailErrorRewrapper())
						.convert(result.errors);
			}
			return this.errorList;
		}
		set;
	}

	public List<XAP_EML_SendEmailErrorWrapper> getErrorList() {
		return this.errorList;
	}
}