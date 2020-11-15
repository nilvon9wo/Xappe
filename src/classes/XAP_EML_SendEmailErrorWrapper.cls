public class XAP_EML_SendEmailErrorWrapper {
	@TestVisible public List<String> fieldList { get; private set; }
	@TestVisible public String message { get; private set; }
	@TestVisible public StatusCode statusCode { get; private set; }

	public XAP_EML_SendEmailErrorWrapper(Messaging.SendEmailError error) {
		this.fieldList = error.getFields();
		this.message = error.getMessage();
		this.statusCode = error.getStatusCode();
	}

	@TestVisible private XAP_EML_SendEmailErrorWrapper() {
	}
}